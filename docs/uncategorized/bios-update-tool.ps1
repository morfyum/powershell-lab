# BIOS UPDATE UTILITY FOR FLEX DIAG-REPAIR PROCESS IMPROVEMENT

$test_Bios_file_Path = "..\Downloads\sp143413.exe"

class DeviceInfo {
    [string] $SerialNumber
    [string] $BIOSVersion
    [string] $SSID
    [string] $Platform
    
    DeviceInfo() { $this.Init(@{}) }
    
    # Convenience constructor from hashtable
    DeviceInfo([hashtable]$Properties) { $this.Init($Properties) }

    # Common constructor Example
    #DeviceInfo([string]$SerialNumber, [string]$BIOSVersion) {
    #    $this.Init(@{SerialNumber = $SerialNumber; BIOSVersion = $BIOSVersion })
    #}
    
    # Shared initializer method
    [void] Init([hashtable]$Properties) {
        foreach ($Property in $Properties.Keys) {
            $this.$Property = $Properties.$Property
        }
    }
}

#$CurrentDevice = [DeviceInfo]::new()
$CurrentDevice = [DeviceInfo]::new(@{
    SerialNumber = (Get-WmiObject win32_bios).SerialNumber
    BIOSVersion = (Get-WmiObject win32_bios).Version
    SSID = "Not Implemented"
    Platform = "Not Implemented"
})


class CSVInfo {
    [string]$BIOSVersion
    [string]$SSID
    [string]$Platform
}

$CurrentCSVInfo = [CSVInfo]::new()
$CurrentCSVInfo.BIOSVersion = "Not Implemented"
$CurrentCSVInfo.SSID = "Not Implemented"
$CurrentCSVInfo.Platform = "Not Implemented"

class BIOSFileInfo {
    [string]$BIOSVersion
    [string]$SSID
    [string]$Platform
}

function GetBIOSFileProductVersion {
    param (
        [Parameter(mandatory=$true)]
        [string] $Path
    )
    if (Test-Path $Path) {
        $BIOSVersion = (Get-Item $Path).VersionInfo.ProductVersion
        Return $BIOSVersion    
    }  else {
        $error_message = "Error: Path Does not exists => GetBIOSFileProductVersion()" 
        Write-Host $error_message -ForegroundColor Red
        Return $error_message
    }
}

function GetBIOSFileSSID {
    param (
        [Parameter(mandatory=$true)]
        [string] $Path
    )

    if (Test-Path $Path) {
        $BIOSSSID = (Get-Item $Path ).VersionInfo.FileDescription | Select-String -Pattern 'SSID\s+(\d{4})' -AllMatches | ForEach-Object { $_.Matches.Groups[1].Value }
        Return $BIOSSSID
    }  else {
        $error_message = "Error: Path Does not exists => GetBIOSFileSSID()"
        Write-Host $error_message -ForegroundColor Red
        Return $error_message
    }
}

$CurrentBIOSFileInfo = [BIOSFileInfo]::new()
$CurrentBIOSFileInfo.BIOSVersion = GetBIOSFileProductVersion -Path "$test_Bios_file_Path"
$CurrentBIOSFileInfo.SSID = GetBIOSFileSSID -Path $test_Bios_file_Path
$CurrentBIOSFileInfo.Platform = "Not Implemented"

# TEST Outputs
function testClassValues {
    param (
        [string]$TestName,
        #[Parameter(mandatory=$true)]
        [string]$classValue,
        #[Parameter(mandatory=$true)]
        [string]$expectedValue
    )

    class TestStatus {
        [string] $TestName
        [string] $FunctionReturn
        [string] $Result
    }
    $TestStatus = [TestStatus]::new()

    $nameLength = $TestName.Length
    $print_TestName = $TestName
    $maxLength = 25
    # Handle Test Params
    if ($TestName -eq "") { $TestName = "NoName"}
    
    for ($currentLength=$nameLength; $currentLength -lt $maxLength; $currentLength=$currentLength+1) {
        $print_TestName = $print_TestName+" "
    }

    $TestStatus.TestName = $print_TestName
    $TestStatus.FunctionReturn = $classValue

    if ($classValue -eq $expectedValue) {
        $TestStatus.Result = "[ OK ]"
        Write-Host "[ OK ] : Test/$print_TestName -> [$classValue]" -ForegroundColor Green
        #Return $TestStatus
    } else {
        ($TestStatus).Result = "[FAIL]"
        Write-Host "[FAIL] : Test/$print_TestName -> [$classValue]" -ForegroundColor Red
        #Return $TestStatus
    }

}

#$CurrentDevice.SerialNumber = (Get-WmiObject win32_bios).SerialNumber
#$CurrentDevice.BIOSVersion = (Get-WmiObject win32_bios).Version
#$CurrentDevice.SSID = "SSID"
#$CurrentDevice.Platform = "Platform"

Write-Host "TEST: DeviceInfo as CurrentDevice" -ForegroundColor Yellow
testClassValues -classValue ($CurrentDevice).SerialNumber -expectedValue "" -TestName "Device/SerialNumber"
testClassValues -classValue ($CurrentDevice).BIOSVersion -expectedValue "BOCHS  - 1" -TestName "Device/BIOSVersion"
testClassValues -classValue ($CurrentDevice).SSID -expectedValue "1A2B" -TestName "Device/SSID"
testClassValues -classValue ($CurrentDevice).Platform -expectedValue "1A2B" -TestName "Device/Platform"

Write-Host "TEST: BIOSFileInfo as CurrentBIOSFileInfo" -ForegroundColor Yellow
testClassValues -classValue ($CurrentBIOSFileInfo).BIOSVersion -expectedValue "F.56" -TestName "BIOSFile/BIOSVersion"
testClassValues -classValue ($CurrentBIOSFileInfo).SSID -expectedValue "8437" -TestName "BIOSFile/SSID:"
testClassValues -classValue ($CurrentBIOSFileInfo).Platform -expectedValue "Unknown" -TestName "BIOSFile/Platform"

Write-Host "TEST: CSVInfo as CurrentCSVInfo" -ForegroundColor Yellow
testClassValues -classValue $CurrentCSVInfo.BIOSVersion -expectedValue "BOCHS  - 1" -TestName "CSVInfo/BIOSVersion"
testClassValues -classValue $CurrentCSVInfo.SSID -expectedValue "1A2B" -TestName "CSVInfo/BIOSVersion"
testClassValues -classValue $CurrentCSVInfo.Platform -expectedValue "Test-Platform" -TestName "CSVInfo/BIOSVersion"


class Worker {

}