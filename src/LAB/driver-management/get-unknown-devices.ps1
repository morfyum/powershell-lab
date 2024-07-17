
#$testValue = "PCI\VEN_1B36&DEV_0100&SUBSYS_11001AF4&REV_05\3&11583659&0&08"
#$testValue = "Red Hat"
#$driverDirectory = "C:\Users\mars\Downloads\extracted-drivers\spice-guest-tools-latest"

function GetUnknownDevices {
    return Get-WmiObject Win32_PnPentity | Where-Object {$_.ConfigManagerErrorCode -ne 0}
    #return Get-WmiObject Win32_PnPentity | Where-Object {$_.Manufacturer -match "Red Hat"}
    #return Get-WmiObject Win32_PnPentity | Where-Object {$_.DeviceID -match $testValue}
}

function CheckDeviceIDInFile {
    param (
        [string]$FilePath,
        [string]$Pattern
    )
    $fileContent = Get-Content -Path $FilePath
    $Pattern = [Regex]::Escape($Pattern)
    $counter = 0
    foreach ($line in $FileContent) {
        $counter = $counter+1
        if ($line -match $Pattern -and $line -notmatch "^;" -and $null -ne $line) {
            Write-Host " ! $FilePath" -ForegroundColor Yellow
            Write-Host " ! $Pattern" -ForegroundColor Yellow
            Write-Host " ! [$line] on line $counter." -ForegroundColor Green
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
                    Start-Sleep -Seconds 3
                }
            } else {
                Write-Host " - skip: $pattern" -ForegroundColor Gray
            }
        }
    }
}

<#
$unknownDevices.HardwareID
$HWID = Get-WmiObject Win32_PnPentity | Where-Object {$_.PNPDeviceID -eq "PCI\VEN_1B36&DEV_0100&SUBSYS_11001AF4&REV_05\3&11583659&0&08"} | Select-Object HardwareID
#>
