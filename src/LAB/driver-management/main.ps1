# Control process for Unknown Device Handler
# github.com/morfyum
. .\infInstall.ps1

# $jsonData = Get-Content -Path .\unknownDeviceList.json | ConvertFrom-Json

foreach ($infFile in $infFiles) {
    #Write-Host "*** INF LOOKUP ***" -ForegroundColor Cyan
    CheckDeviceIDInFile -FilePath $($infFile.FullName) -VendorID "1B36" -DeviceID "0100"
    #pnputil.exe /add-driver $infFile.FullName /install
}

