
class UnknownDeviceInfo {
    [string] $VendorID
    [string] $DeviceID
}

function GetUnknownDevices {
    Get-WmiObject Win32_PnPentity | Where-Object {$_.ConfigManagerErrorCode -ne 0} | Select-Object Status, ConfigManagerErrorCode, Name, DeviceID | ForEach-Object {
        Write-Host "Found Unknown device: $($_.DeviceID)" -ForegroundColor Yellow
    }
}


function TestPathErrorHandler {
    param (
        [Parameter(mandatory=$true)]
        [string] $Path,
        [switch] $ShowSuccess
    )


GetUnknownDevices

