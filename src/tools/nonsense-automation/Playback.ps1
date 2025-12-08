# Ha még nincs betöltve a MouseEvent típus, csak akkor adjuk hozzá
if (-not ([System.Management.Automation.PSTypeName]'MouseEvent').Type) {

    Add-Type @"
using System;
using System.Runtime.InteropServices;

public class MouseEvent {
    [DllImport("user32.dll")] public static extern bool SetCursorPos(int X, int Y);

    [DllImport("user32.dll")] public static extern void mouse_event(int dwFlags, int dx, int dy, int cButtons, int dwExtraInfo);

    public const int LEFTDOWN = 0x02;
    public const int LEFTUP   = 0x04;
}
"@
}

$events = Get-Content "mouse_record.json" | ConvertFrom-Json

Write-Host "Replaying..." -ForegroundColor Green

$prevTime = 0

foreach ($e in $events) {

    $delay = $e.Time - $prevTime
    Start-Sleep -Milliseconds $delay
    $prevTime = $e.Time

    # mozgatás
    [MouseEvent]::SetCursorPos($e.X, $e.Y)

    # bal gomb lenyomása vagy felengedése
    if ($e.LeftDown -eq $true) {
        [MouseEvent]::mouse_event([MouseEvent]::LEFTDOWN, 0, 0, 0, 0)
    } else {
        [MouseEvent]::mouse_event([MouseEvent]::LEFTUP, 0, 0, 0, 0)
    }
}
