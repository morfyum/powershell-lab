<#  Windows symptoms By Morfyum
    VERSION: 7
    BORN: 2021-jan-18
    COPYRIGHT: 2022 
    WINDOWS VERSIONS: https://docs.microsoft.com/en-us/windows/release-information/
#>

$currentUser = "$env:UserName"
$serialNumber = (Get-CimInstance win32_bios).SerialNumber
$today = $((Get-Date).ToString('yyyy-MM-dd HHmm'))

function EventLogFilter {
    # DOCS: https://devblogs.microsoft.com/scripting/use-filterhashtable-to-filter-event-log-with-powershell/
    # Leve: Information: [ 4 ] , Warning: [ 3 ], Error: [ 2 ], Critical: [ 1 ], LogAlways: [ 0 ].
    param (
        [string]$LogName,
        [string]$LogID,
        [string]$LogLevel,
        [string]$LogCustomTitle,
        [string]$LogCustomDescription
    )

    switch ($LogLevel) {
        # 1:CRITICAL 2:ERROR 3:WARNING 4:INFORMATION
        1 { $logLevelName = "CRITICAL" }
        2 { $logLevelName = "ERROR" }
        3 { $logLevelName = "WARNING" }
        4 { $logLevelName = "INFORMATION" }
    }

    try {
        #by source:  Get-EventLog -LogName System -EntryType Error, Warning -Source nvlddmkm -ErrorAction stop
        $eventLogs = Get-WinEvent -FilterHashtable @{logname="$($LogName)"; ID=$LogID; level=$LogLevel} -ErrorAction stop
        $eventLogsCounted = $eventLogs.Count
        $eventLogName = $eventLogs[0].ProviderName
        $eventLogMessage = $eventLogs[0].Message
        Write-Host "- $LogLevelName ($($eventLogsCounted)x) [$LogName] / eventID: $LogID / $LogLevel : [$LogCustomTitle]" -ForegroundColor Yellow
        Write-Host "  Name: $eventLogName"
        Write-Host "  Message: $eventLogMessage"
    }
    catch {
        Write-Host "- [ OK ] [$LogCustomTitle] : [$LogName] / $LogID / $LogLevel" -ForegroundColor Green
    }
}


function GetBSODInfo {
    # DOCS: https://devblogs.microsoft.com/scripting/use-filterhashtable-to-filter-event-log-with-powershell/
    Write-Host "# Event Log Analyze: BSOD" -ForegroundColor Cyan    
    $pattern = "0x.{8}"
    $BSOD = $null
    try {
        $BSODLogs = Get-WinEvent -FilterHashtable @{LogName='System';Id=1001; level=2 } -ErrorAction stop
        $BSODLogs | ForEach-Object {
            Write-Host "- $($_.ProviderName)" -ForegroundColor Red
            Write-Host "$($_.Message)"
            if ($($_.Message) -match $pattern) {
                $Matches.Values | ForEach-Object {
                    $BSOD =$_
                    Write-Host "BSOD: $BSOD"
                }
            } else {
                Write-Host "Nincs találat."
            }
        }
        #$BSODLogName = $BSODLogs[0].ProviderName
        #$BSODLogMessage = $BSODLogs[0].Message
        #Get-WinEvent -FilterHashtable @{logname='System'; ID=1001; level=2}
        #$BSODLogs
    }
    catch {
        Write-Host "- [ OK ] eventID: 1001 [ BSOD ]: not found." -ForegroundColor Green
    }

}

<#
$osRawVersion = [System.Environment]::OSVersion.Version | Select-Object Build | Select-String [0-9]
$osClearVersion = $osRawVersion -replace "[^0-9]",""
# 2004 > 1903 > old
# 18362 = 1903
# 18363 = 1909
# 19041 = 2004
# 19042 = 20H2
# 22000 = 21H2 22000.258
$checkNetFrameworkIsInstalled = (Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\NET Framework Setup\NDP\v4\Full").Release -ge 378389
$listNetFrameworkVersions = Get-ChildItem 'HKLM:\SOFTWARE\Microsoft\NET Framework Setup\NDP' -recurse | Get-ItemProperty -name Version,Release -EA 0 | Where { $_.PSChildName -match '^(?!S)\p{L}'} | Select PSChildName, Version, Release
Test-Path "HKLM:\SOFTWARE\Microsoft\NET Framework Setup\NDP\v3.0\*
#>

function CheckMinidumpFolder {
    Write-Host "# MINIDUMP" -ForegroundColor Cyan
    $bsodPath = "C:\Windows\minidump"
    switch (Test-Path $bsodPath){
        "True" {
            Write-Host "- Minidump directory exists: [$bsodPath ]" -ForegroundColor Yellow
        }
        "False" {
            Write-Host "- [ OK ] $bsodPath not found" -ForegroundColor Green
        }
    }
}

function CheckUnknownDevices {
    Write-Host "# Check Unknown Devices" -ForegroundColor Cyan
    $unknownDevices = Get-WmiObject Win32_PNPEntity | Where-Object {$_.ConfigManagerErrorCode -gt 0 }

    if ($null -eq $unknownDevices){
        Write-Host "[ OK ] DEVICE MANAGER (no unknown device)" -ForegroundColor Green
    } else {
        Write-Host "[ FAIL ] 1 OR MORE UNKNOWN DEVICE FOUND!" -ForegroundColor Red
        $unknownDevices
    }
   
}


function StartAppCamera {
    Write-Host "# START APP: CAMERA" -ForegroundColor Cyan

    $startAppxList = @(
        'Microsoft.WindowsCamera'
        #'Microsoft.WindowsSoundRecorder'
    )
    foreach ($element in $startAppxList) {
        Write-Host "- $element"
        Start-Sleep -Seconds 2
        Get-AppxPackage *$element* | % {& Explorer.exe $('Shell:AppsFolder\' + $_.PackageFamilyName + ‚!' + $((Get-AppxPackageManifest $_.PackageFullName).Package.Applications.Application.id))}
    }
}


function GetWindowsLicensingStatus {
    #Get-CimInstance SoftwareLicensingProduct -Filter "Name like 'Windows%'" |
    #where { $_.PartialProductKey } | select LicenseStatus
    #slmgr /xpr
    # Get-CimInstance SoftwareLicensingProduct -Filter "LicenseStatus = 1"
    # Get-CimInstance SoftwareLicensingProduct -Filter "LicenseStatus = 1" | Select-Object Description, LicenseStatus, ProductKeyChannel, PartialProductKey
    #$lStatus = (Get-CimInstance SoftwareLicensingProduct -Filter "Name like 'Windows%'" | where { $_.PartialProductKey } | select LicenseStatus).LicenseStatus
    $lStatus = (Get-CimInstance -Query "SELECT LicenseStatus from SoftwareLicensingProduct WHERE name LIKE 'Windows%' AND LicenseStatus = 1").LicenseStatus
    if ( $lStatus -eq 1 ){
        Write-Host "- [ OK ] Windows has active License" -ForegroundColor Green;
    }
    elseif ( $lStatus -eq 0 ){
        Write-Host "- [ Oops ] Windows Activation Required" -ForegroundColor Red;
    }
    else{
        Write-Host "- [ Oops ] Something Went Wrong. Please report this issue" -ForegroundColor Yellow;
    }
}

########################################################################################################################
########################################################################################################################
Write-Host "# POWER LOSS" -ForegroundColor Cyan
EventLogFilter -LogName "System" -LogID 41 -LogLevel 1 -LogCustomTitle "CRITICAL Kernel-Power"
Write-Host "# MB/WLAN / ?PCI" -ForegroundColor Cyan 
EventLogFilter -LogName "System" -LogID 17 -LogLevel 1 -LogCustomTitle "CRITICAL WHEA-Logger"
EventLogFilter -LogName "System" -LogID 17 -LogLevel 3 -LogCustomTitle "WARNING WHEA-Logger"
Write-Host "# WLAN / ?PCI" -ForegroundColor Cyan
#CRITICAL: RTWLanE 5002 - wifi problema
EventLogFilter -LogName "System" -LogID 5001 -LogLevel 2 -LogCustomTitle "ERROR RTWlanE (slow wifi speed?)"
EventLogFilter -LogName "System" -LogID 5002 -LogLevel 1 -LogCustomTitle "CRITICAL RTWLanE 5002 - wifi problema"
EventLogFilter -LogName "System" -LogID 5002 -LogLevel 2 -LogCustomTitle "ERROR RTWLanE 5002 - wifi problema"
EventLogFilter -LogName "System" -LogID 5006 -LogLevel 2 -LogCustomTitle "ERROR RTWlanE (slow wifi speed?)"
EventLogFilter -LogName "System" -LogID 5010 -LogLevel 2 -LogCustomTitle "ERROR Netwtw10"
Write-Host "# DISC/FILESYSTEM" -ForegroundColor Cyan
EventLogFilter -LogName "System" -LogID 3 -LogLevel 2 -LogCustomTitle "FilterMaster"
EventLogFilter -LogName "System" -LogID 7 -LogLevel 2 -LogCustomTitle "Disc"
EventLogFilter -LogName "System" -LogID 51 -LogLevel 3 -LogCustomTitle "Disc"
EventLogFilter -LogName "System" -LogID 55 -LogLevel 2 -LogCustomTitle "Disc"
EventLogFilter -LogName "System" -LogID 98 -LogLevel 3 -LogCustomTitle "Ntfs (Microsoft-Windows-Ntfs) 98"
EventLogFilter -LogName "System" -LogID 140 -LogLevel 3 -LogCustomTitle "Ntfs"
EventLogFilter -LogName "System" -LogID 4102 -LogLevel 2 -LogCustomTitle "ERROR iaStorAC (SMART ERROR)"
Write-Host " DISC PERFORMANCE" -ForegroundColor Cyan
EventLogFilter -LogName "System" -LogID 153 -LogLevel 3 -LogCustomTitle "WARNING Disc I/O performance issue"
Write-Host "# NVIDIA" -ForegroundColor Cyan
EventLogFilter -LogName "System" -LogID 4101 -LogLevel 3 -LogCustomTitle "Nvidia/Display"
EventLogFilter -LogName "System" -LogID 13 -LogLevel 2 -LogCustomTitle "Nvidia: nvlddmkm"

GetBSODInfo
CheckMinidumpFolder
CheckUnknownDevices
Write-Host "# Check Windows Licensing Status" -ForegroundColor Cyan
GetWindowsLicensingStatus
#StartAppCamera
pause