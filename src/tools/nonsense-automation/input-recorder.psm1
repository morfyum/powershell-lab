# ============================================
# input-recorder.psm1
# Full Input Recorder + Playback Module
# Supports:
#   - Mouse Move
#   - Left/Middle/Right Buttons
#   - Mouse Wheel
#   - Keyboard Input
#   - Accurate Timestamping
#   - JSON Export / Import
# ============================================

Add-Type -AssemblyName System.Windows.Forms

# ------------------------
# WinAPI for Mouse + Keyboard
# ------------------------
if (-not ([System.Management.Automation.PSTypeName]'NativeInput').Type) {
    Add-Type @"
using System;
using System.Runtime.InteropServices;

public static class NativeInput {

    // Mouse
    [DllImport("user32.dll")]
    public static extern bool SetCursorPos(int X, int Y);

    [DllImport("user32.dll")]
    public static extern void mouse_event(int dwFlags, int dx, int dy, int cButtons, int dwExtraInfo);

    public const int LEFTDOWN   = 0x02;
    public const int LEFTUP     = 0x04;
    public const int RIGHTDOWN  = 0x08;
    public const int RIGHTUP    = 0x10;
    public const int MIDDLEDOWN = 0x20;
    public const int MIDDLEUP   = 0x40;
    public const int WHEEL      = 0x0800;

    // Keyboard
    [DllImport("user32.dll")]
    public static extern void keybd_event(byte bVk, byte bScan, uint dwFlags, UIntPtr dwExtraInfo);

    public const int KEYEVENTF_KEYUP = 0x0002;


    // Mouse/Keyboard Hooks
    public delegate IntPtr HookProc(int code, IntPtr wParam, IntPtr lParam);

    [DllImport("user32.dll")]
    public static extern IntPtr SetWindowsHookEx(int idHook, HookProc callback, IntPtr hInstance, uint threadId);

    [DllImport("user32.dll")]
    public static extern bool UnhookWindowsHookEx(IntPtr hHook);

    [DllImport("user32.dll")]
    public static extern IntPtr CallNextHookEx(IntPtr idHook, int nCode, IntPtr wParam, IntPtr lParam);

    public const int WH_MOUSE_LL    = 14;
    public const int WH_KEYBOARD_LL = 13;

    public const int WM_MOUSEMOVE      = 0x0200;
    public const int WM_LBUTTONDOWN    = 0x0201;
    public const int WM_LBUTTONUP      = 0x0202;
    public const int WM_RBUTTONDOWN    = 0x0204;
    public const int WM_RBUTTONUP      = 0x0205;
    public const int WM_MBUTTONDOWN    = 0x0207;
    public const int WM_MBUTTONUP      = 0x0208;
    public const int WM_MOUSEWHEEL     = 0x020A;

    public const int WM_KEYDOWN = 0x0100;
    public const int WM_KEYUP   = 0x0101;

}
"@
}

# ------------------------
# Globals
# ------------------------
$global:inputEvents = @()
$global:hookMouse = $null
$global:hookKeyboard = $null
$global:startTime = $null

# ------------------------
# Start Recording
# ------------------------
function Start-InputRecording {
    param(
        [string]$File = "input_record.json"
    )

    $global:recordFile = $File
    $global:inputEvents = @()
    $global:startTime = Get-Date

    Write-Host "[+] Starting Input Recording..." -ForegroundColor Cyan

    # ------------------------
    # Mouse Hook
    # ------------------------
    $mouseHandler = {
        param($code, $wParam, $lParam)

        if ($code -ge 0) {
            $info = [Runtime.InteropServices.Marshal]::PtrToStructure(
                $lParam,
                ([Type][System.Windows.Forms.MouseEventArgs])
            )

            $raw = @{
                Time = ((Get-Date) - $global:startTime).TotalMilliseconds
                Type = "Mouse"
                Msg  = $wParam.ToInt32()
                X    = [System.Windows.Forms.Cursor]::Position.X
                Y    = [System.Windows.Forms.Cursor]::Position.Y
                Delta = 0
            }

            if ($wParam.ToInt32() -eq [NativeInput]::WM_MOUSEWHEEL) {
                $delta = [System.BitConverter]::ToInt16([BitConverter]::GetBytes($info.Delta), 0)
                $raw.Delta = $delta
            }

            $global:inputEvents += $raw
        }

        return [NativeInput]::CallNextHookEx($null, $code, $wParam, $lParam)
    }

    $script:mouseCallback = [NativeInput+HookProc]$mouseHandler
    $global:hookMouse = [NativeInput]::SetWindowsHookEx(
        [NativeInput]::WH_MOUSE_LL,
        $script:mouseCallback,
        [IntPtr]::Zero,
        0
    )

    # ------------------------
    # Keyboard Hook
    # ------------------------
    $keyboardHandler = {
        param($code, $wParam, $lParam)

        if ($code -ge 0) {

            $vkCode = [System.Runtime.InteropServices.Marshal]::ReadInt32($lParam)
            $event = @{
                Time  = ((Get-Date) - $global:startTime).TotalMilliseconds
                Type  = "Key"
                Msg   = $wParam.ToInt32()
                Key   = $vkCode
            }

            $global:inputEvents += $event
        }

        return [NativeInput]::CallNextHookEx($null, $code, $wParam, $lParam)
    }

    $script:keyCallback = [NativeInput+HookProc]$keyboardHandler
    $global:hookKeyboard = [NativeInput]::SetWindowsHookEx(
        [NativeInput]::WH_KEYBOARD_LL,
        $script:keyCallback,
        [IntPtr]::Zero,
        0
    )

    Write-Host "[*] Recording. Press Stop-InputRecording to finish." -ForegroundColor Green
}

# ------------------------
# Stop Recording
# ------------------------
function Stop-InputRecording {
    Write-Host "[+] Stopping Recording..." -ForegroundColor Yellow

    if ($global:hookMouse) {
        [NativeInput]::UnhookWindowsHookEx($global:hookMouse) | Out-Null
    }
    if ($global:hookKeyboard) {
        [NativeInput]::UnhookWindowsHookEx($global:hookKeyboard) | Out-Null
    }

    $global:inputEvents | ConvertTo-Json -Depth 4 | Out-File $global:recordFile -Encoding UTF8

    Write-Host "[+] Saved $($global:inputEvents.Count) events to $global:recordFile" -ForegroundColor Green
}

# ------------------------
# Playback
# ------------------------
function Play-InputRecording {
    param(
        [string]$File = "input_record.json"
    )

    $events = Get-Content $File | ConvertFrom-Json

    Write-Host "[+] Playing back $($events.Count) events..." -ForegroundColor Cyan

    $prev = 0

    foreach ($e in $events) {
        $delay = $e.Time - $prev
        Start-Sleep -Milliseconds $delay
        $prev = $e.Time

        switch ($e.Type) {

            "Mouse" {
                [NativeInput]::SetCursorPos($e.X, $e.Y)

                switch ($e.Msg) {
                    ([NativeInput]::WM_LBUTTONDOWN) { [NativeInput]::mouse_event([NativeInput]::LEFTDOWN,0,0,0,0) }
                    ([NativeInput]::WM_LBUTTONUP)   { [NativeInput]::mouse_event([NativeInput]::LEFTUP,0,0,0,0) }
                    ([NativeInput]::WM_RBUTTONDOWN) { [NativeInput]::mouse_event([NativeInput]::RIGHTDOWN,0,0,0,0) }
                    ([NativeInput]::WM_RBUTTONUP)   { [NativeInput]::mouse_event([NativeInput]::RIGHTUP,0,0,0,0) }
                    ([NativeInput]::WM_MBUTTONDOWN) { [NativeInput]::mouse_event([NativeInput]::MIDDLEDOWN,0,0,0,0) }
                    ([NativeInput]::WM_MBUTTONUP)   { [NativeInput]::mouse_event([NativeInput]::MIDDLEUP,0,0,0,0) }
                    ([NativeInput]::WM_MOUSEWHEEL)  {
                        [NativeInput]::mouse_event(
                            [NativeInput]::WHEEL,
                            0, 0, $e.Delta, 0
                        )
                    }
                }
            }

            "Key" {
                if ($e.Msg -eq [NativeInput]::WM_KEYDOWN) {
                    [NativeInput]::keybd_event([byte]$e.Key, 0, 0, [UIntPtr]::Zero)
                }
                elseif ($e.Msg -eq [NativeInput]::WM_KEYUP) {
                    [NativeInput]::keybd_event([byte]$e.Key, 0, [NativeInput]::KEYEVENTF_KEYUP, [UIntPtr]::Zero)
                }
            }
        }
    }

    Write-Host "[+] Playback complete." -ForegroundColor Green
}

Export-ModuleMember -Function Start-InputRecording, Stop-InputRecording, Play-InputRecording
