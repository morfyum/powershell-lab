. .\get-unknown-devices.ps1

$driverDirectory = "C:\Users\mars\Downloads\extracted-drivers\spice-guest-tools-latest"

$unknownDevices = GetUnknownDevices
$infFiles = Get-ChildItem -Path $driverDirectory -Recurse -Filter *.inf

if ($unknownDevices.Length -eq 0) {
    Write-Host "All device ready to use. Exit" -ForegroundColor Green
    Exit 0
}



PNPInstallProcess -Install
