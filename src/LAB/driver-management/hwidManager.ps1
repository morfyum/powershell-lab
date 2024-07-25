. .\get-unknown-devices.ps1

$driverDirectory = "C:\Users\mars\Downloads\extracted-drivers\spice-guest-tools-latest"
$unknownDevices = GetUnknownDevices
$infFiles = Get-ChildItem -Path $driverDirectory -Recurse -Filter *.inf

# Error handling before run
SelfTestPathCheck -Path $driverDirectory -ExitOnFail
SelfTestUnknownDevices -UnknownDevices $unknownDevices -ExitOnPass
SelfTestInfFiles -InfArray $infFiles -ExitOnFail

# Runk without -Install to check What files are matched with unknown devices HardwareIDs
PNPInstallProcess -Install