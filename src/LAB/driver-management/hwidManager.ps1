. .\get-unknown-devices.ps1

$driverDirectory = "C:\Users\mars\Downloads\extracted-drivers\spice-guest-tools-latest"
$unknownDevices = GetUnknownDevices
$infFiles = Get-ChildItem -Path $driverDirectory -Recurse -Filter *.inf

# Error handling before run
if ((Test-Path -Path $driverDirectory) -eq $false) {
    Write-Host "Missing driverDirectory path: $driverDriectory. Exit" -ForegroundColor Red
    Exit 1
}

if ($unknownDevices.Length -eq 0) {
    Write-Host "All device ready to use. Exit" -ForegroundColor Green
    Exit 0
}
if ($infFiles.Length -eq 0) {
    Write-Host "Missing .inf file list. Exit" -ForegroundColor Red
    Exit 1
}

# Runk without -Install to check What files are matched with unknown devices HardwareIDs
PNPInstallProcess -Install