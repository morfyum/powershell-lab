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
    if ($Pattern -eq " " -or $Pattern -eq "") {
        return $null
    }
    $Pattern = [Regex]::Escape($Pattern)
    $counter = 0
    #Write-Host "[i] Pattern: [$Pattern]"
    foreach ($line in $FileContent) {
        $counter = $counter+1
        #if ($line -match $Pattern -and $line -notmatch "^;" -and $null -ne $line) {
        if ($line -ne "" -and $line -notmatch "^\s*;" -and $line -match $Pattern) {
            if ($Silent -eq $false) {
                Write-Host " ! Pattern  : $Pattern" -ForegroundColor Yellow
                Write-Host " ! FilePath : $FilePath" -ForegroundColor Yellow
                Write-Host " ! [$line] on line $counter." -ForegroundColor Green
            }
            return $true
        }
    }
    return $null
}


function PNPInstallProcess {
    <#
    .SYNOPSIS
    Find matching unknown device identifier ID in .inf files by using CheckDeviceIDInFile
    .DESCRIPTION
    PNPInstallProcess iterate on UnknownDeviceList object (This is a powershell system object),
    and iterate on INF file list.
    Check all inf file for matching HardwareIDs of unknown device. 
    CheckDeviceIDinFile when found match, return with $true and PNPInstallProcess start installation when -Install parameter is set.
    ! Use "Microsoft" instead of "Red Hat" on non linux based windows VM for testing.
    $testDevices = Get-WmiObject Win32_PnPentity | Where-Object {$_.PNPClass -eq "Display" -and $_.Manufacturer -match "Red Hat"}
    $infFiles = Get-ChildItem -Path ".\" -Recurse -Filter *.inf
    PNPInstallProcess -UnknownDeviceList $testDevices -InfFiles $infFiles
    .PARAMETER Install
    Without -Install, PNPInstallProcess just list matching files.
    .PARAMETER UnknownDeviceList
    This is not a smiple ARRAY! This is an Object of Unknown devices with device parameters: .HardwareID, CompatibleID, ...etc
    Get-WmiObject Win32_PnPentity | Where-Object {$_.PNPClass -eq "Display"}
    .PARAMETER InfFiles
    This is not a simple array. This is an object with file paramteters: .FullName, Name, ...etc
    Get-ChildItem -Path ".\" -Recurse -Filter *.inf
    (Get-ChildItem -Path ".\" -Recurse -Filter *.inf).FullName
    .EXAMPLE
    PNPInstallProcess -UnknownDeviceList $testDevices -InfFiles $infFiles
    .NOTES
    General notes
    #>
    param (
        [switch] $Install,
        [object] $UnknownDeviceList,
        [object] $InfFiles,
        [string] $ByID = ""
    )
    if ($ByID -eq "") {
        $ByID = "HardwareID"
        Write-Host "Using [$byID] by default. < HardwareID | CompatibleID >"
    } else {
        Write-Host "Using [$ByID]"
    }
    if ($Install -eq $false) {
        Write-Host "=============================================================" -ForegroundColor Cyan
        Write-Host "*** Running in TEST mode. Add -Install to install drivers ***" -ForegroundColor Cyan
        Write-Host "=============================================================" -ForegroundColor Cyan
    }
    foreach ($infFile in $InfFiles) {
        Write-Host "[+] $infFile >>> $($infFile.FullName)" -ForegroundColor Cyan
        #Write-Host "[+] " -ForegroundColor Cyan
        foreach ($pattern in $UnknownDeviceList.$ByID) {  #  CompatibleID | HardwareID
            #Write-Host " - $pattern" -ForegroundColor Gray
            $result = CheckDeviceIDInFile -FilePath $($infFile.FullName) -Pattern $pattern
            if ($result -eq $true) {
                Write-Host " - Add : $pattern" -ForegroundColor Green
                if ($Install -eq $true) {
                    Write-Host "*** Install driver ***" -ForegroundColor Green
                    pnputil.exe /add-driver $($infFile.FullName) /install /force
                    $UnknownDeviceList = GetUnknownDevices  # New Line for refresh unknown device list after install driver
                    return
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
    return $true
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
