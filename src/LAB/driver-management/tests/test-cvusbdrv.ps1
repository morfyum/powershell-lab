<# TEST / "cvusbdrv.inf" - ISSUE 
PATTERN:    USB\VID_0A5C&PID_5843&REV_0102
PATTERN:    USB\VID_0A5C&PID_5843
#>

<# DIFFS 
    
#>

function GetUnknownDevices {
    #return Get-WmiObject Win32_PnPentity | Where-Object {$_.ConfigManagerErrorCode -ne 0 -or ($_.PNPClass -eq "Display" -and $_.Service -eq "BasicDisplay")}
    return Get-WmiObject Win32_PnPentity | Where-Object {$_.ConfigManagerErrorCode -ne 0 -or ($_.PNPClass -eq "Display" -or $_.Service -match "BasicDisplay")}
}

$infFiles = Get-ChildItem -Path ./ -Recurse -Filter *.inf
Write-Host "--------------------------------------------------------------------------------"
Write-Host "*** INF FILES: ***" -ForegroundColor Cyan
$infFiles.FullName
Write-Host "--------------------------------------------------------------------------------"
$unknownDeviceList = @("USB\VID_0A5C&PID_5843&REV_0102")
$unknownDeviceList += "USB\VID_0A5C&PID_5843"
#$unknownDeviceList = GetUnknownDevices
Write-Host "*** UNKNOWN DEVICE LIST: ***" -ForegroundColor Cyan
"LENGTH: $($unknownDeviceList.Length)"
Write-Host "*** CUSTOM LIST ***" -ForegroundColor Cyan
$unknownDeviceList
Write-Host "*** PNPDeviceID ***" -ForegroundColor Cyan
$unknownDeviceList.PNPDeviceID
Write-Host "*** HardwareID ***" -ForegroundColor Cyan
$unknownDeviceList.HardwareID
Write-Host "*** CompatibleID ***" -ForegroundColor Cyan
$unknownDeviceList.CompatibleID
#$unknownDeviceList
Write-Host "--------------------------------------------------------------------------------"

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
    param (
        [switch] $Install,
        [array] $UnknownDeviceList,
        [array] $InfFiles,
        [string] $Comment = $null
    )
    if ($Install -eq $false) {
        Write-Host "=============================================================" -ForegroundColor Cyan
        Write-Host "*** Running in TEST mode. Add -Install to install drivers ***" -ForegroundColor Cyan
        Write-Host "=============================================================" -ForegroundColor Cyan
    }
    Write-Host "[i] PNPInstallProcess: Using [$Comment]" -ForegroundColor Cyan
    if ($($UnknownDeviceList.Length) -eq 0) {
        return "[-] ??? return because Not found Unknown Device !!!"
    }
    foreach ($infFile in $InfFiles) {
        Write-Host "[+] $infFile >>> $($infFile.FullName)" -ForegroundColor Cyan
        foreach ($pattern in $UnknownDeviceList) {
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

### MAIN.PS1 MODIFICATIONS! ###
#PNPInstallProcess -UnknownDeviceList $unknownDeviceList.PNPDeviceID -InfFiles $infFiles
#PNPInstallProcess -UnknownDeviceList $unknownDeviceList.HardwareID -InfFiles $infFiles
#PNPInstallProcess -UnknownDeviceList $unknownDeviceList.CompatibleID -InfFiles $infFiles
PNPInstallProcess -UnknownDeviceList $unknownDeviceList -InfFiles $infFiles -Comment "Custom List"