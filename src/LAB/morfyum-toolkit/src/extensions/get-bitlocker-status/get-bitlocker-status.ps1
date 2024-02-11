$host.UI.RawUI.WindowSize = New-Object System.Management.Automation.Host.Size(100, 26)

#<#
Write-Host "============================================================"
Write-Host "             Show Storage Encryption Percentage             " -ForegroundColor Green
Write-Host "============================================================"
Write-Host ""
$assumedDrives = @("C:", "D:", "E:", "F:", "G:")
$assumedDrives | ForEach-Object {
    if ((Test-Path $($_)) -eq $true ) {
        Write-Output "MountPoint    EncryptionPercentage"
        Write-Output "----------    --------------------"
        Write-Output " $($_)            $((Get-BitLockerVolume $_).EncryptionPercentage)%"
    }
}
Write-Host ""
#>

#Get-BitLockerVolume | Select-Object -Property "MountPoint", "EncryptionPercentage"
Pause