Add-Type -AssemblyName System.Windows.Forms

$logFile = "mouse_record.json"
$events = @()
$lastPos = [System.Windows.Forms.Cursor]::Position
$lastState = $false
$startTime = Get-Date

Write-Host "Recording... Press CTRL+C to stop." -ForegroundColor Cyan

# --- CTRL+C kezelés ---
$global:stopRecording = $false
Register-EngineEvent PowerShell.Exiting -Action {
    $global:stopRecording = $true
}

try {
    while (-not $stopRecording) {
        $pos = [System.Windows.Forms.Cursor]::Position
        $leftDown = [System.Windows.Forms.Control]::MouseButtons -eq "Left"

        if ($pos.X -ne $lastPos.X -or $pos.Y -ne $lastPos.Y -or $leftDown -ne $lastState) {
            $event = [PSCustomObject]@{
                Time     = ((Get-Date) - $startTime).TotalMilliseconds
                X        = $pos.X
                Y        = $pos.Y
                LeftDown = $leftDown
            }

            $events += $event

            $lastPos = $pos
            $lastState = $leftDown
        }

        Start-Sleep -Milliseconds 10
    }
}
finally {
    Write-Host "[*] Stopping recorder..." -ForegroundColor Yellow
    $events | ConvertTo-Json | Out-File $logFile -Encoding UTF8
    Write-Host "[+] Saved $($events.Count) events to $logFile" -ForegroundColor Green
}