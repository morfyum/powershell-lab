<# EXTRA INFO

# Export installed drivers:
pnputil.exe /export-Driver $_.Driver C:\DeviceDrivers

# Install saved drivers
pnputil.exe /add-driver C:\VMDrivers\*.inf /subdirs /install

#>

Write-Host "List Installed Drivers..."
#New-Item -Type Directory -Path C:\ -Name VMDrivers

#Get-WindowsDriver -Online | ForEach-Object {
#    "- $($_.Driver) -> $($_.OriginalFileName)"
#    #pnputil.exe /export-Driver $_.Driver C:\VMDrivers
#}

function SaveDrivers {
    param (
        [switch] $DryRun,
        [string] $SaveLocation = $false,
        [switch] $CreateLocation
    )

    if ($CreateLocation -eq $true) {
        Write-Host "Create Directory path..." -ForegroundColor Green
        New-Item -ItemType Directory -Path $SaveLocation | Out-Null
    }

    if ( $SaveLocation -ne $false -and (Test-Path -Path $SaveLocation) -eq $false ) {
        Write-Host "Location does not exists. -> exit" -ForegroundColor Red
        exit
    }

    if ($DryRun -eq $true -or $SaveLocation -eq $false) {
        Write-Host "Dry Run: just list devices" -ForegroundColor Yellow
        Get-WindowsDriver -Online | ForEach-Object {
            "- $($_.Driver) -> $($_.OriginalFileName)"
        }
    } else {
        Get-WindowsDriver -Online | ForEach-Object {
            Write-Host "- $($_.Driver) -> $($_.OriginalFileName)" -ForegroundColor RED
            pnputil.exe /export-Driver $_.Driver $SaveLocation
        }
    }
}

function DeleteDrivers {
    param (
        [switch] $DryRun,
        [switch] $Force
    )

    # TODO : Reboot required or /remove-device needed
    # !! maybe remove-device decrease time of deleting dirvers

    Get-WindowsDriver -Online | ForEach-Object {
        "- $($_.Driver) -> $($_.OriginalFileName)"
        if ($DryRun -eq $true) {Write-Host "Dry Run without changes!" -ForegroundColor Yellow}
        if ($DryRun -eq $false) {
            if ($Force -eq $true) {
                pnputil.exe /delete-Driver $_.Driver /force
            } else {
                pnputil.exe /delete-Driver $_.Driver
            }
        }
    }
}

#### APP ####
SaveDrivers -DryRun -SaveLocation C:\VMDrivers