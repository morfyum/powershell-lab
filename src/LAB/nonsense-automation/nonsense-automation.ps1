Add-Type -AssemblyName System.Windows.Forms
Add-Type -MemberDefinition '[DllImport("user32.dll")] public static extern void mouse_event(int flags, int dx, int dy, int cButtons, int info);' -Name U32 -Namespace W;
[console]::InputEncoding = [console]::OutputEncoding = New-Object System.Text.UTF8Encoding
$OutputEncoding = [console]::InputEncoding = [console]::OutputEncoding = [System.Text.UTF8Encoding]::new()

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
    Write-Host "Current Position: $Position" -ForegroundColor Cyan
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
    Start-Sleep -Seconds 1
}

function CursorMove {
    param (
        [int] $PositionX,
        [int] $PositionY,
        [switch] $Click
    )
    Write-Host "[-] Cursore Move" -ForegroundColor Cyan
    #$Position = [System.Windows.Forms.Cursor]::Position
    $GetCurrentPositionX = [System.Windows.Forms.Cursor]::Position.X
    $GetCurrentPositionY = [System.Windows.Forms.Cursor]::Position.Y
    Write-Host "[i] Current Position: $GetCurrentPositionX, $GetCurrentPositionY"
    Write-Host "[i] Set Position: $PositionX, $PositionY"
    [System.Windows.Forms.Cursor]::Position = New-Object System.Drawing.Point($PositionX, $PositionY)

    if ($Click -eq $true) {
        CursorClickLeft
    }
}

function CursorClickLeft {
    [W.U32]::mouse_event(6,0,0,0,0);
    Write-Host "[-] Left Click" -ForegroundColor Cyan
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
        default     {Typing -String $String}
    }
    Start-Sleep -Seconds 1
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
function Enter {
    Write-Host "[-] Enter" -ForegroundColor Cyan
    [System.Windows.Forms.SendKeys]::SendWait("{ENTER}")
}