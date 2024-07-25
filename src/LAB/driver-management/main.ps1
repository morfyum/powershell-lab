# Unknown Device Handler by github.com/morfyum
# IMPORT
. ./src/Unknown-Device-Handler-Tools.ps1
# GLOBAL VARIABLES
$config = Get-Content -Path "./src/Config.json" | ConvertFrom-Json
$unitModel = (Get-WmiObject -Class Win32_ComputerSystem).Model
$unitBiosVersion = $(Get-WmiObject -Class Win32_BIOS).Version
$unitSerialNumber = $(Get-WmiObject -Class Win32_BIOS).SerialNumber
$driverDirectory = "$($config.driverLocation)/$unitModel"
$unknownDevices = GetUnknownDevices
$infFiles = $infFiles = Get-ChildItem -Path $driverDirectory -Recurse -Filter *.inf
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
    exit 0
}

PNPInstallProcess -Install -UnknownDeviceList $unknownDevices -InfFiles $infFiles

PNPInstallProcess -Install -ByID "CompatibleID" -UnknownDeviceList $unknownDevices -InfFiles $infFiles

Write-Host "*** Special Config using for Ready unit ***" -ForegroundColor Cyan
$counter = 0
$(($config.units.isReady)) | ForEach-Object {
    if ($_ -eq $true) {
        Write-Host " - $(($config.units.name[$counter]))"
    }
    $counter++
}







####### LEGACY ###################
# $jsonData = Get-Content -Path .\unknownDeviceList.json | ConvertFrom-Json

<#
foreach ($infFile in $infFiles) {
    #Write-Host "*** INF LOOKUP ***" -ForegroundColor Cyan
    
    CheckDeviceIDInFile -FilePath $($infFile.FullName) -VendorID "1B36" -DeviceID "0100" | ForEach-Object {
        if ($_ -eq $true) {
            Write-Host "INSTALL"
            pnputil.exe /add-driver $infFile.FullName /install
        }
    }
}#>

