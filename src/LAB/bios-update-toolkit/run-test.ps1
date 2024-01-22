# IMPORT
. .\bios-update-tool.ps1

$test_BIOS_file_path = "..\..\..\..\..\..\Downloads\sp143413.exe"
$test_SSID_variable = "8C2E"
$csvPath = ".\csv_example.csv"
$csvData = Import-Csv -Path $csvPath -Delimiter ";" -Header "Index", "SSID", "BIOSVersion", "FilePath", "UserID", "LastUpdate", "Description"

$CurrentDevice = [DeviceInfo]::new()
$CurrentDevice.SerialNumber = (Get-WmiObject win32_bios).SerialNumber
$CurrentDevice.BIOSVersion = (Get-WmiObject win32_bios).Version
#$CurrentDevice.SSID = (Get-WmiObject Win32_BaseBoard).Product
$CurrentDevice.SSID = $test_SSID_variable # TODO - TEST ONLY 

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
$CurrentBIOSFileInfo = [BIOSFileInfo]::new()
$CurrentBIOSFileInfo.BIOSVersion = GetBIOSFileProductVersion -Path $($CurrentCSVInfo.FilePath)
$CurrentBIOSFileInfo.SSID = GetBIOSFileSSID -Path $($CurrentCSVInfo.FilePath)
$CurrentBIOSFileInfo.MD5Sum = (Get-FileHash -Algorithm MD5 -Path $($CurrentCSVInfo.FilePath)).Hash


Write-Host "TEST: DeviceInfo as CurrentDevice" -ForegroundColor Yellow
testClassValues -classValue ($CurrentDevice).SerialNumber -expectedValue "" -TestName "Device/SerialNumber"
testClassValues -classValue ($CurrentDevice).BIOSVersion -expectedValue "BOCHS  - 1" -TestName "Device/BIOSVersion"
testClassValues -classValue ($CurrentDevice).SSID -expectedValue "8C2E" -TestName "Device/SSID"

Write-Host "TEST: CSVInfo as CurrentCSVInfo" -ForegroundColor Yellow
testClassValues -classValue $CurrentCSVInfo.SSID -expectedValue "8C2E" -TestName "CSVInfo/SSID"
testClassValues -classValue $CurrentCSVInfo.BIOSVersion -expectedValue "F.12" -TestName "CSVInfo/BIOSVersion"
testClassValues -classValue $CurrentCSVInfo.FilePath -expectedValue "\\10.222.245.225\images\bios\common\Roku1C23" -TestName "CSVInfo/FilePath"
testClassValues -classValue $CurrentCSVInfo.LastUpdate -expectedValue "2023. 11. 24. 0:00:00" -TestName "CSVInfo/LastUpdate"
testClassValues -classValue $CurrentCSVInfo.Platform -expectedValue "Roku - 1C23" -TestName "CSVInfo/BIOSVersion"

Write-Host "TEST: BIOSFileInfo as CurrentBIOSFileInfo" -ForegroundColor Yellow
testClassValues -classValue ($CurrentBIOSFileInfo).BIOSVersion -expectedValue "F.56" -TestName "BIOSFile/BIOSVersion"
testClassValues -classValue ($CurrentBIOSFileInfo).SSID -expectedValue "8437" -TestName "BIOSFile/SSID:"