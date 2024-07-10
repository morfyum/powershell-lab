Write-Host "List Installed Drivers..."
#New-Item -Type Directory -Path C:\ -Name VMDrivers

Get-WindowsDriver -Online | ForEach-Object {
    "- $($_.Driver) -> $($_.OriginalFileName)"

    #pnputil.exe /export-Driver $_.Driver C:\VMDrivers
}