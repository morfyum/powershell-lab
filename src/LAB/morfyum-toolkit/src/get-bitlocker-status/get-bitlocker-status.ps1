$host.UI.RawUI.WindowSize = New-Object System.Management.Automation.Host.Size(40, 14)

Write-Host "========================================"
Write-Host "   Show Storage Encryption Percentage   " -ForegroundColor Green
Write-Host "========================================"

$assumedDrives = @("C:", "D:", "E:", "F:", "G:")

$assumedDrives | ForEach-Object {
    
    if ((Test-Path $($_)) -eq $true ) {
        Write-Host " - $($_)  [ $((Get-BitLockerVolume C:).EncryptionPercentage)% ]"
    }
    
}

Pause