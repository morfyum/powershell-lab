# IMPORT
. .\bios-update-tool.ps1
<#
    TODO
    - fn ConnectToBIOSDriveStorage
    - EXTERNAL: MD5SUM list 
    - IF PC/BIOSVersion -lt CSV/BIOSVersion -> Update required!
    - IF FILE/MD5Checksum -eq EXTERNAL/MD5SZM -> Continue Update
#>
# VARIABLES FOR DEVELOPING AND TESTING
#$test_Bios_file_Path
$test_BIOS_file_path = "..\..\..\..\..\..\Downloads\sp143413.exe"
$test_SSID_variable = "8C2E"

# FUNCTIONALITY VARIABLES
$csvPath = ".\csv_example.csv"
$BIOSDriveIP = "127.0.0.1" # FOR FAIL TEST: 3333.3333.3333

function TestPathErrorHandler {
    param (
        [Parameter(mandatory=$true)]
        [string] $Path,
        [switch] $ShowSuccess
    )
    
    if ((Test-Path $Path) -eq $true) {
        if ($ShowSuccess -eq $true) {
            Write-Host "[ OK ] Test Path [$Path]" -ForegroundColor Green
        }
    } else {
        Write-Host "Test Path: ERROR [$Path] does not exists => Exit 1" -ForegroundColor Red
        Exit 1
    }     
}

function CheckConnection {
    param (
        [Parameter(mandatory=$true)]
        [string] $IPAddress
    )
    Test-Connection -IPAddress $IPAddress -Count 2 -ErrorAction SilentlyContinue | Out-Null
    if ($? -eq $false) {
        Write-Host "ERROR: No connection to BIOS drive: [$IPAddress] => Exit 3" -ForegroundColor Red
        Exit 3
    }
    Write-Host "[ OK ] Check Connection" -ForegroundColor Green
}

TestPathErrorHandler -Path $csvPath
$csvData = Import-Csv -Path $csvPath -Delimiter ";" -Header "Index", "SSID", "BIOSVersion", "FilePath", "UserID", "LastUpdate", "Description"

Write-Host "*** BIOS UPDATE UTILITY ***" -ForegroundColor Cyan

Write-Host "Gathering device information..." -ForegroundColor Cyan
$CurrentDevice = [DeviceInfo]::new()
$CurrentDevice.SerialNumber = (Get-WmiObject win32_bios).SerialNumber
$CurrentDevice.BIOSVersion = (Get-WmiObject win32_bios).Version
#$CurrentDevice.SSID = (Get-WmiObject Win32_BaseBoard).Product
$CurrentDevice.SSID = $test_SSID_variable # TODO - TEST ONLY 
Write-Host "PC/Serial Number   : [$($CurrentDevice.SerialNumber)]"
Write-Host "PC/BIOS Version    : [$($CurrentDevice.BIOSVersion)]"
Write-Host "PC/Baseboard(SSID) : [$($CurrentDevice.SSID)]"


Write-Host "Find match in CSV by BaseBoard (SSID)..." -ForegroundColor Cyan
$CurrentCSVInfo = [CSVInfo]::new()
$CurrentCSVInfo.SSID = "Not found"
$CurrentCSVInfo.BIOSVersion = "Not found"
$CurrentCSVInfo.FilePath = "Not found"
$CurrentCSVInfo.LastUpdate = "Not found"
$CurrentCSVInfo.Platform = "Not found"

$csvData | ForEach-Object {
    if ($($_.SSID) -eq $($CurrentDevice.SSID)) {
        $CurrentCSVInfo.SSID = $_.SSID
        $CurrentCSVInfo.BIOSVersion = $_.BIOSVersion
        #$CurrentCSVInfo.FilePath = $_.FilePath
        $CurrentCSVInfo.FilePath = $test_BIOS_file_path # TODO REMOVE TEST ONLY
        $CurrentCSVInfo.LastUpdate = $_.LastUpdate
        $CurrentCSVInfo.Platform = $_.Description
    }
}

if ($CurrentCSVInfo.SSID -eq "Not found") {
    Write-Host "FAIL: [$($CurrentDevice.SSID)] missing form HPWur database, because your PC Baseboard Code does Not exists => Exit 2" -ForegroundColor Red
    Exit 2
}

Write-Host "CSV/Baseboard      : [$($CurrentCSVInfo.SSID)]"
Write-Host "CSV/BiosVersion    : [$($CurrentCSVInfo.BiosVersion)]"
Write-Host "CSV/FilePath       : [$($CurrentCSVInfo.FilePath)]"
Write-Host "CSV/LastUpdate     : [$($CurrentCSVInfo.LastUpdate)]"
Write-Host "CSV/Platform       : [$($CurrentCSVInfo.Platform)]"


Write-Host "Analyze BIOS File on CSV/FilePath..." -ForegroundColor Cyan
CheckConnection -IPAddress $BIOSDriveIP
TestPathErrorHandler -Path $($CurrentCSVInfo.FilePath) -ShowSuccess
$CurrentBIOSFileInfo = [BIOSFileInfo]::new()
$CurrentBIOSFileInfo.BIOSVersion = GetBIOSFileProductVersion -Path $($CurrentCSVInfo.FilePath)
$CurrentBIOSFileInfo.SSID = GetBIOSFileSSID -Path $($CurrentCSVInfo.FilePath)
$CurrentBIOSFileInfo.MD5Sum = (Get-FileHash -Algorithm MD5 -Path $($CurrentCSVInfo.FilePath)).Hash
Write-Host "FILE/BIOSVersion   : $($CurrentBIOSFileInfo.BIOSVersion)"
Write-Host "FILE/Baseboard     : $($CurrentBIOSFileInfo.SSID)"
Write-Host "FILE/MD5Checksum   : $($CurrentBIOSFileInfo.MD5Sum)"



Write-Host "Extra Check: ($($CurrentDevice.SSID)=$($CurrentBIOSFileInfo.SSID) ?)" -ForegroundColor Yellow
if ($CurrentDevice.SSID -eq $CurrentBIOSFileInfo.SSID) {
    Write-Host "OK" -ForegroundColor Green
} else {
    Write-Host "WARNING: Computer BaseBoard Code (SSID) not equal with BIOS File SSID!" -ForegroundColor Yellow
    $stillContinue = Read-Host "Do you want to conitune? [Y/n]"
    if ($stillContinue.ToLower() -eq "y") {
        # Continue
    } else {
        Write-Host "Cancelled. Exit"
    }
}
Write-Host "Check MD5SumDatabase..." -ForegroundColor Cyan

<#
Write-Host "TEST: DeviceInfo as CurrentDevice" -ForegroundColor Yellow
testClassValues -classValue ($CurrentDevice).SerialNumber -expectedValue "" -TestName "Device/SerialNumber"
testClassValues -classValue ($CurrentDevice).BIOSVersion -expectedValue "BOCHS  - 1" -TestName "Device/BIOSVersion"
testClassValues -classValue ($CurrentDevice).SSID -expectedValue "1A2B" -TestName "Device/SSID"

Write-Host "TEST: BIOSFileInfo as CurrentBIOSFileInfo" -ForegroundColor Yellow
testClassValues -classValue ($CurrentBIOSFileInfo).BIOSVersion -expectedValue "F.56" -TestName "BIOSFile/BIOSVersion"
testClassValues -classValue ($CurrentBIOSFileInfo).SSID -expectedValue "8437" -TestName "BIOSFile/SSID:"

Write-Host "TEST: CSVInfo as CurrentCSVInfo" -ForegroundColor Yellow
testClassValues -classValue $CurrentCSVInfo.SSID -expectedValue "8C2E" -TestName "CSVInfo/SSID"
testClassValues -classValue $CurrentCSVInfo.BIOSVersion -expectedValue "F.12" -TestName "CSVInfo/BIOSVersion"
testClassValues -classValue $CurrentCSVInfo.FilePath -expectedValue "\\10.222.245.225\images\bios\common\Roku1C23" -TestName "CSVInfo/FilePath"
testClassValues -classValue $CurrentCSVInfo.LastUpdate -expectedValue "2023. 11. 24. 0:00:00" -TestName "CSVInfo/LastUpdate"
testClassValues -classValue $CurrentCSVInfo.Platform -expectedValue "Roku - 1C23" -TestName "CSVInfo/BIOSVersion"
#>