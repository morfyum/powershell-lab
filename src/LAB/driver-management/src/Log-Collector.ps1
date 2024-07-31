# github.com/morfyum
# Korabban: getUnknownDevices.ps1

class UnknownDeviceModel {
    [string] $DeviceType = $null
    [string] $VendorID = $null
    [string] $DeviceID = $null
}

$unknownDeviceList = @()

function GenerateUnknownDeviceArray {
    $unknownDeviceStringList = @()
    Get-WmiObject Win32_PnPentity | Where-Object {$_.ConfigManagerErrorCode -ne 0} | Select-Object Status, ConfigManagerErrorCode, Name, DeviceID | ForEach-Object {
        Write-Host "Found Unknown device: $($_.DeviceID)" -ForegroundColor Yellow
        $unknownDeviceStringList += $($_.DeviceID)
    }  
    return $unknownDeviceStringList
}

function GetDeviceType {
    param (
        [Parameter(Mandatory=$true)]
        [string] $string
    )
    $deviceType = $string.Substring(0, $string.IndexOf("\"))
    #Write-Host "  DeviceType : $deviceType"
    return $deviceType
}

function GetVendorID {
    param (
        [Parameter(Mandatory=$true)]
        [string] $string
    )
    $match = $string -match "(?<=VEN_)\w+"
    if ($match -eq $true) {
        $vendorID = $Matches[0]
        #Write-Host "VendorID   : $($VendorID)" -ForegroundColor Green
    }
    return $vendorID
}

function GetDeviceID {
    param (
        [Parameter(Mandatory=$true)]
        [string] $string
    )
    $match = $string -match "(?<=DEV_)\w+"
    if ($match -eq $true) {
        $deviceID = $Matches[0]
        #Write-Host "DeviceID   : $($deviceID)" -ForegroundColor Green
    }
    return $deviceID
}

########## ########## APP ########## ##########

$unknownDevicesArray = GenerateUnknownDeviceArray


function LogCollector {

    $saveLocation = $($config.logLocation)
    $computerModel = (Get-WmiObject -Class Win32_ComputerSystem).Model
    $unitSerialNumber = $(Get-WmiObject -Class Win32_BIOS).SerialNumber
    $fullSaveLocation = "$($config.logLocation)/$computerModel"

    if ((Test-Path -Path $fullSaveLocation) -eq $false) {
        Write-Host "Create Directoy: [$computerModel] ON $saveLocation : $fullSaveLocation"
        New-Item -Path $fullSaveLocation -ItemType Directory
    } else {
        Write-Host "Directort Exists: $fullSaveLocation"
    }

    Write-Host "# Log Location       : $($config.logLocation)"
    $unknownDevicesArray | ForEach-Object {
        Write-Host "OK": $_ -ForegroundColor Green

        $deviceType = GetDeviceType -string $_
        $vendorID = GetVendorID -string $_
        $deviceID = GetDeviceID -string $_

        Write-Host "- Type   : $deviceType"
        Write-Host "- Vendor : $vendorID"
        Write-Host "- Device : $deviceID"

        $unknownDeviceInfo = [UnknownDeviceModel]::new()
        $unknownDeviceInfo.DeviceType = $deviceType
        $unknownDeviceInfo.VendorID = $vendorID
        $unknownDeviceInfo.DeviceID = $deviceID
        $unknownDeviceList += $unknownDeviceInfo
    }

    $unknownDeviceList

    $jsonString = $unknownDeviceList | ConvertTo-Json

    if ($jsonString.Length -eq 0) {
        Write-Host "All device ready to use" -ForegroundColor Green
        #New-Item -ItemType File -Path $fullSaveLocation -Name "$unitSerialNumber.PASS" -Force | Out-Null
        $jsonString | Out-File -FilePath "$fullSaveLocation/$unitSerialNumber.json"
    } else {
        $jsonString | Out-File -FilePath "$fullSaveLocation/$unitSerialNumber.json"
    }
}

# READ CONTENT IN THE FUTURE:
# $jsonData = Get-Content -Path .\unknownDeviceList.json | ConvertFrom-Json