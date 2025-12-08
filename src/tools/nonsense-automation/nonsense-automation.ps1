Add-Type -AssemblyName System.Windows.Forms
Add-Type @"
using System;
using System.Runtime.InteropServices;

public class MouseEvent {
    [DllImport("user32.dll", CharSet = CharSet.Auto, CallingConvention = CallingConvention.StdCall)]
    public static extern void mouse_event(int dwFlags, int dx, int dy, int cButtons, int dwExtraInfo);

    public const int MOUSEEVENTF_LEFTDOWN = 0x0002;
    public const int MOUSEEVENTF_LEFTUP   = 0x0004;
}
"@
# Character Encoding settings

$delayInMiliseconds = 250

<#
# AVAILABLE INPUT KEYS:
https://www.jesusninoc.com/11/05/simulate-key-press-by-user-with-sendkeys-and-powershell/
BACKSPACE       {BACKSPACE}, {BS}, or {BKSP}
BREAK           {BREAK}
CAPS LOCK       {CAPSLOCK}
DEL or DELETE   {DELETE} or {DEL}
DOWN ARROW      {DOWN}
END             {END}
ENTER           {ENTER} or ~
ESC             {ESC}
HELP            {HELP}
HOME            {HOME}
INS or INSERT   {INSERT} or {INS}
LEFT ARROW      {LEFT}
NUM LOCK        {NUMLOCK}
PAGE DOWN       {PGDN}
PAGE UP         {PGUP}
PRINT SCREEN    {PRTSC} (reserved for future use)
RIGHT ARROW     {RIGHT}
SCROLL LOCK     {SCROLLLOCK}
TAB             {TAB}
UP ARROW        {UP}
F1-F16          {F1}-{F16}
Keypad add      {ADD}
Keypad subtract {SUBTRACT}
Keypad multiply {MULTIPLY}
Keypad divide   {DIVIDE}
SHIFT   : +
CTRL    : ^
ALT     : %
# Window Title + Enter ~ = {ENTER   }
$wshell = New-Object -ComObject wscript.shell;
$wshell.AppActivate('title of the application window')
Sleep 1
$wshell.SendKeys('~')
#>

function GetCursorPosition {
    $Position = [System.Windows.Forms.Cursor]::Position
    Write-Host "Current Position: $Position | X: [$($Position.X)] Y: [$($Position.Y)]" -ForegroundColor Cyan
}

function GetScreenWidth {
    $screenWidth = (Get-WmiObject -Class Win32_DesktopMonitor).ScreenWidth
    return $screenWidth
}
function GetScreenHeight {
    $screenHeight = (Get-WmiObject -Class Win32_DesktopMonitor).ScreenHeight
    return $screenHeight
}

function GetOpenedWindows {
    return (Get-Process | Where-Object {$_.mainWindowTitle} |format-table id,name,mainwindowtitle -AutoSize)
}

function FocusWindow {
    param (
        [string] $WindowNameOrID 
    )
    $wshell = New-Object -ComObject wscript.shell;
    $wshell.AppActivate($WindowNameOrID)
    Start-Sleep -Milliseconds $delayInMiliseconds
}

function CursorMove {
    param (
        [int] $PositionX,
        [int] $PositionY,
        [switch] $Click
    )
    Write-Host "[-] Cursore Move" -ForegroundColor Cyan
    $GetCurrentPositionX = [System.Windows.Forms.Cursor]::Position.X
    $GetCurrentPositionY = [System.Windows.Forms.Cursor]::Position.Y
    Write-Host "[i] Current Position: $GetCurrentPositionX, $GetCurrentPositionY"
    Write-Host "[i] Set Position: $PositionX, $PositionY"
    [System.Windows.Forms.Cursor]::Position = New-Object System.Drawing.Point($PositionX, $PositionY)
    Start-Sleep -Milliseconds $delayInMiliseconds
    if ($Click -eq $true) {
        CursorClickLeft
    }
}

function CursorClickLeft {
    [W.U32]::mouse_event(6,0,0,0,0);
    Write-Host "[-] Left Click" -ForegroundColor Cyan
    Start-Sleep -Milliseconds $delayInMiliseconds
}

function CursorMouseDownLeft {
    Write-Host "[-] Left Mouse Down" -ForegroundColor Yellow
    [MouseEvent]::mouse_event([MouseEvent]::MOUSEEVENTF_LEFTDOWN, 0, 0, 0, 0)
}

function CursorMouseUpLeft {
    Write-Host "[-] Left Mouse Up" -ForegroundColor Yellow
    [MouseEvent]::mouse_event([MouseEvent]::MOUSEEVENTF_LEFTUP, 0, 0, 0, 0)
}

function CursorClickLeft2 {
    CursorMouseDownLeft
    Start-Sleep -Milliseconds 80
    CursorMouseUpLeft
}

function MouseDrag {
    param(
        [int]$StartX,
        [int]$StartY,
        [int]$EndX,
        [int]$EndY,
        [int]$Delay = 200   # ms
    )
    Write-Host "[-] Mouse Drag"
    Write-Host "[i] Start: $StartX, $StartY"
    Write-Host "[i] End:   $EndX, $EndY"
    [System.Windows.Forms.Cursor]::Position = New-Object System.Drawing.Point($StartX, $StartY)
    Start-Sleep -Milliseconds 100
    # Hold left button
    [MouseEvent]::mouse_event([MouseEvent]::MOUSEEVENTF_LEFTDOWN, 0, 0, 0, 0)
    # Few waiting (Sometimes required)
    Start-Sleep -Milliseconds $Delay
    Write-Host "[i] Set Position: $EndX, $EndY"
    [System.Windows.Forms.Cursor]::Position = New-Object System.Drawing.Point($EndX, $EndY)
    Start-Sleep -Milliseconds $Delay
    Write-Host "[i] Drag done." -ForegroundColor Gray
    [MouseEvent]::mouse_event([MouseEvent]::MOUSEEVENTF_LEFTUP, 0, 0, 0, 0)
}

function CursorDrag {
    param(
        [int] $StartX,
        [int] $StartY,
        [int] $EndX,
        [int] $EndY,
        [int] $DragDelay = 250
    )
    Write-Host "[-] Cursor Drag Operation" -ForegroundColor Green
    Write-Host "[i] Start: $StartX, $StartY"
    Write-Host "[i] End:   $EndX, $EndY"
    # Start position
    [System.Windows.Forms.Cursor]::Position = New-Object System.Drawing.Point($StartX, $StartY)
    Start-Sleep -Milliseconds $($DragDelay/2)  ## 80
    # Cursor Down
    CursorMouseDownLeft
    Start-Sleep -Milliseconds $DragDelay
    # Pull to the end
    [System.Windows.Forms.Cursor]::Position = New-Object System.Drawing.Point($EndX, $EndY)
    Start-Sleep -Milliseconds $($DragDelay/2)  # 80
    # Cursor Up
    CursorMouseUpLeft
    Write-Host "[+] Drag done." -ForegroundColor Green
}

function CursorDragSmooth {
    param(
        [int] $StartX,
        [int] $StartY,
        [int] $EndX,
        [int] $EndY,
        [int] $Steps = 25,           # minél nagyobb, annál simább
        [int] $StepDelay = 5         # ms, minél kisebb, annál gyorsabb
    )
    Write-Host "[-] Smooth Cursor Drag" -ForegroundColor Magenta
    Write-Host "[i] Start: $StartX, $StartY"
    Write-Host "[i] End:   $EndX, $EndY"
    # Start pozíció beállítása
    [System.Windows.Forms.Cursor]::Position = New-Object System.Drawing.Point($StartX, $StartY)
    Start-Sleep -Milliseconds 50
    # Egér lenyomása
    CursorMouseDownLeft
    # A távolság kiszámítása
    $dx = $EndX - $StartX
    $dy = $EndY - $StartY
    # 50 lépésben mozgatjuk (alapértelmezés)
    for ($i = 1; $i -le $Steps; $i++) {
        $newX = $StartX + ($dx * $i / $Steps)
        $newY = $StartY + ($dy * $i / $Steps)
        [System.Windows.Forms.Cursor]::Position = New-Object System.Drawing.Point([int]$newX, [int]$newY)
        Start-Sleep -Milliseconds $StepDelay
    }
    # Egér felengedése
    CursorMouseUpLeft
    Write-Host "[+] Smooth drag completed." -ForegroundColor Green
}



function SendInput {
    param (
        [string] $String
    )
    switch ($String.ToLower()) {
        enter       {Enter}
        ctrla       {CtrlA}
        ctrl+a      {CtrlA}
        ctrlc       {CtrlC}
        ctrl+c      {CtrlC}
        ctrlv       {CtrlV}
        ctrl+v      {CtrlV}
        alttab      {AltTab}
        alt+tab     {AltTab}
        tab         {Tab}
        default     {Typing -String $String}
    }
    Start-Sleep -Milliseconds $delayInMiliseconds
}

function Typing {
    param (
        [string] $String
    )
    Write-Host "[-] Typing: $String" -ForegroundColor Cyan
    [System.Windows.Forms.SendKeys]::SendWait("$String")
}
function CtrlA {
    Write-Host "[-] Ctrl + A" -ForegroundColor Cyan
    [System.Windows.Forms.SendKeys]::SendWait("^{a}")
}
function CtrlC {
    Write-Host "[-] Ctrl + C" -ForegroundColor Cyan
    [System.Windows.Forms.SendKeys]::SendWait("^{c}")
}
function CtrlV {
    Write-Host "[-] Ctrl + V" -ForegroundColor Cyan
    [System.Windows.Forms.SendKeys]::SendWait("^{v}")
}
function AltTab {
    Write-Host "[-] Alt + Tab" -ForegroundColor Cyan
    [System.Windows.Forms.SendKeys]::SendWait("%{TAB}")
}
function AltTabTab {
    Write-Host "[-] Alt + Tab + Tab" -ForegroundColor Cyan
    [System.Windows.Forms.SendKeys]::SendWait("%({TAB}{TAB})")
}
function Enter {
    Write-Host "[-] Enter" -ForegroundColor Cyan
    [System.Windows.Forms.SendKeys]::SendWait("{ENTER}")
}
function Tab {
    Write-Host "[-] Tab" -ForegroundColor Cyan
    [System.Windows.Forms.SendKeys]::SendWait("{TAB}")
}