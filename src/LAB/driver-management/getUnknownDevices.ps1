# github.com/morfyum

$saveLocation = "C:\"
$computerModel = (Get-WmiObject -Class Win32_ComputerSystem).Model
$fullSaveLocation = $saveLocation+$computerModel

if ((Test-Path -Path $fullSaveLocation) -eq $false) {
    Write-Host "Create Directoy: $computerModel on $saveLocation"
    #mkdir $fullSaveLocation
} else {
    Write-Host "Directort Exists."
}


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
$jsonString | Out-File -FilePath "$computerModel.json"

# READ CONTENT IN THE FUTURE:
# $jsonData = Get-Content -Path .\unknownDeviceList.json | ConvertFrom-Json