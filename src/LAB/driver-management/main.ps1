# Unknown Device Handler by github.com/morfyum
. .\infInstall.ps1

# $jsonData = Get-Content -Path .\unknownDeviceList.json | ConvertFrom-Json

foreach ($infFile in $infFiles) {
    #Write-Host "*** INF LOOKUP ***" -ForegroundColor Cyan
    
    CheckDeviceIDInFile -FilePath $($infFile.FullName) -VendorID "1B36" -DeviceID "0100" | ForEach-Object {
        if ($_ -eq $true) {
            Write-Host "INSTALL"
            pnputil.exe /add-driver $infFile.FullName /install
        }
    }
}

