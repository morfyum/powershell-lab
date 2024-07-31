. ..\src\Unknown-Device-Handler-Tools.ps1

$udvcs = Get-WmiObject Win32_PnPentity | Where-Object {$_.ConfigManagerErrorCode -ne 0 -or ($_.PNPClass -eq "Display" -and $_.Service -match "BasicDisplay")}
$testPath = "C:\Users\mars\Downloads\extracted-drivers"
$infFiles = Get-ChildItem -Path $testPath -Recurse -Filter *.inf

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


function PNPInstallByVenDevID {
    param (
        [switch] $Install,
        [array] $UnknownDeviceList,
        [object] $InfFiles
    )
    $UnknownDeviceList.DeviceID | ForEach-Object {
        $_ 
        $vendorID = GetVendorID -string $_
        $deviceID = GetDeviceID -string $_
        Write-Host "VEN: $vendorID & DEV: $deviceID"
        #$pattern = VEN_1B36&DEV_0100
        $pattern = "VEN_$vendorID&DEV_$deviceID"
        Write-Host "Pattern: $pattern"
        Write-Host "PNPINSTALL: $pattern /install $InfFiles"

        foreach ($infFile in $InfFiles) {
            Write-Host "[+] $infFile >>> $($infFile.FullName)" -ForegroundColor Cyan
            $result = CheckDeviceIDInFile -FilePath $($infFile.FullName) -Pattern $pattern
            if ($result -eq $true) {
                Write-Host " - Found : $pattern" -ForegroundColor Green
                if ($Install -eq $true) {
                    Write-Host "*** Install driver: $($infFile.FullName)***" -ForegroundColor Green
                    pnputil.exe /add-driver $($infFile.FullName) /install /force
                    #$UnknownDeviceList = GetUnknownDevices  # New Line for refresh unknown device list after install driver
                }
            } else {
                Write-Host " - skip: $pattern" -ForegroundColor Gray
            }
        }
    }
}

PNPInstallByVenDevID -UnknownDeviceList $udvcs -InfFiles $infFiles