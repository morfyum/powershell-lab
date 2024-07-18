
#$testValue = "PCI\VEN_1B36&DEV_0100&SUBSYS_11001AF4&REV_05\3&11583659&0&08"
#$testValue = "Red Hat"
#$driverDirectory = "C:\Users\mars\Downloads\extracted-drivers\spice-guest-tools-latest"

function GetUnknownDevices {
    #return Get-WmiObject Win32_PnPentity | Where-Object {$_.ConfigManagerErrorCode -ne 0 -or ($_.PNPClass -eq "Display" -and $_.Service -eq "BasicDisplay")}
    return Get-WmiObject Win32_PnPentity | Where-Object {$_.ConfigManagerErrorCode -ne 0 -or ($_.PNPClass -eq "Display" -and $_.Service -match "BasicDisplay")}
}

function CheckDeviceIDInFile {
    param (
        [string]$FilePath,
        [string]$Pattern,
        [switch]$Silent
    )
    $fileContent = Get-Content -Path $FilePath
    $Pattern = [Regex]::Escape($Pattern)
    $counter = 0
    foreach ($line in $FileContent) {
        $counter = $counter+1
        if ($line -match $Pattern -and $line -notmatch "^;" -and $null -ne $line) {
            if ($Silent -eq $false) {
                Write-Host " ! $FilePath" -ForegroundColor Yellow
                Write-Host " ! $Pattern" -ForegroundColor Yellow
                Write-Host " ! [$line] on line $counter." -ForegroundColor Green
            }
            return $true
        }
    }
    return
}


function PNPInstallProcess {
    param (
        [switch] $Install,
        [string] $DefaultID = "HardwareID"
    )
    if ($Install -eq $false) {
        Write-Host "=====================================================" -ForegroundColor Cyan
        Write-Host "*** Running in TEST mode. Add -Install to install ***" -ForegroundColor Cyan
        Write-Host "=====================================================" -ForegroundColor Cyan
    }
    foreach ($infFile in $infFiles) {
        Write-Host "[+] $($infFile.FullName)" -ForegroundColor Cyan
        Write-Host "[+] $infFile" -ForegroundColor Cyan
        
        foreach ($pattern in $unknownDevices.$DefaultID) {  #  CompatibleID | HardwareID
            #Write-Host " - $pattern" -ForegroundColor Gray
            $result = CheckDeviceIDInFile -FilePath $($infFile.FullName) -Pattern $pattern
            if ($result -eq $true) {
                Write-Host " - $pattern" -ForegroundColor Green
                if ($Install -eq $true) {
                    Write-Host "*** Install driver ***" -ForegroundColor Green
                    #Start-Sleep -Seconds 3
                    pnputil.exe /add-driver $($infFile.FullName) /install /force
                }
            } else {
                Write-Host " - skip: $pattern" -ForegroundColor Gray
            }
        }
    }
}

function SelfTestPathCheck {
    param (
        [string] $Path,
        [switch] $ExitOnFail
    )
    if ((Test-Path -Path $Path) -eq $false) {
        if ($ExitOnFail -eq $true) {
            Write-Host "Missing path: [$Path]" -ForegroundColor Red
            Exit 1
        }
        return "Missing path: [$Path]"
    }
}

function SelfTestInfFiles {
    param (
        [array] $InfArray,
        [switch] $ExitOnFail
    )
    if ($InfArray.Length -eq 0) {
        if ($ExitOnFail -eq $true) {
            Write-Host "Missing .inf file list. Exit" -ForegroundColor Red
            Exit 1
        }
        return "Missing .inf file list. Exit"
    }
}

function SelfTestUnknownDevices {
    param (
        [array] $UnknownDevices,
        [switch] $ExitOnPass
    )
    if ($UnknownDevices.Length -eq 0) {
        if ($ExitOnPass -eq $true) {
            Write-Host "All device ready to use. Exit" -ForegroundColor Green
            Exit 0
        }
        return "All device ready to use."
    }
    return $UnknownDevices.Length
}

<#
$unknownDevices.HardwareID
$HWID = Get-WmiObject Win32_PnPentity | Where-Object {$_.PNPDeviceID -eq "PCI\VEN_1B36&DEV_0100&SUBSYS_11001AF4&REV_05\3&11583659&0&08"} | Select-Object HardwareID
#>
