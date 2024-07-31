# Unknown Device Handler by github.com/morfyum
# IMPORT
. ./src/Unknown-Device-Handler-Tools.ps1
. ./src/Log-Collector.ps1
# GLOBAL VARIABLES
$config = Get-Content -Path "./src/Config.json" | ConvertFrom-Json
$unitModel = (Get-WmiObject -Class Win32_ComputerSystem).Model
$unitBiosVersion = $(Get-WmiObject -Class Win32_BIOS).SMBIOSBIOSVersion
$unitSerialNumber = $(Get-WmiObject -Class Win32_BIOS).SerialNumber
$driverDirectory = "$($config.driverLocation)/$unitModel"
$unknownDevices = GetUnknownDevices
$infFiles = Get-ChildItem -Path $driverDirectory -Recurse -Filter *.inf
##### INFO #####
"#### Config.json #####
# Maintenance        : $($config.maintenance)
# Version            : $($config.appVersion)
# Driver Location    : $($config.driverLocation)
# Log Location       : $($config.logLocation)
# Available units    : [ $(($config.units.name).Length) ] > $($config.units.name)
# Ready units:"
$counter = 0
$(($config.units.isReady)) | ForEach-Object {
    if ($_ -eq $true) {
        Write-Host " - $(($config.units.name[$counter]))"
    }
    $counter++
}
"###### Unit Info ######
# Unit Model          : $unitModel
# Driver Directory    : $driverDirectory
# BIOS Version        : $unitBiosVersion
# Serial Number       : $unitSerialNumber
"
##### APP #####
if ($($config.maintenance) -eq $true) {
    Write-Host "****************************************************************************************************" -ForegroundColor Red
    Write-Host "*                                                                                                  *" -ForegroundColor Red
    Write-Host "*  ATTENTION! Maintenance mode are enabled in Config.josn! (Config.json / maintenance: true)       *" -ForegroundColor Red
    Write-Host "*  In Maintenance mode Driver Updating is unavailable. EXIT                                        *" -ForegroundColor Red
    Write-Host "*                                                                                                  *" -ForegroundColor Red
    Write-Host "****************************************************************************************************" -ForegroundColor Red
} else {
    $runAgain = $true
    $unknownDevicesCurrent = $unknownDevices
    while ($runAgain -eq $true) {
        PNPInstallByVenDevID -Install -UnknownDeviceList $unknownDevices -InfFiles $infFiles
        PNPInstallProcess -Install -UnknownDeviceList $unknownDevices -InfFiles $infFiles
        PNPInstallProcess -Install -ByID "CompatibleID" -UnknownDeviceList $unknownDevices -InfFiles $infFiles
        $unknownDevices = GetUnknownDevices
        if ($unknownDevicesCurrent -ne $unknownDevices) {
            $runAgain = $true
            $unknownDevicesCurrent = $unknownDevices
            Write-Host "OK! Run again"
            pause
        } else {
            Write-Host "Done because solve nothing" -ForegroundColor Yellow
            $runAgain = $false
        }
    }

    Write-Host "*** Special Config using for Ready unit ***" -ForegroundColor Cyan
    $counter = 0
    $(($config.units.isReady)) | ForEach-Object {
        if ($_ -eq $true) {
            Write-Host "Ready: $(($config.units.name[$counter]))"
        }
        $counter++
    }
}
