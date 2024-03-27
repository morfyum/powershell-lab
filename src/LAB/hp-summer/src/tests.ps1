#IMPORT
Import-Module ".\PSMenu\0.2.0\PSMenu.psm1"
. .\models.ps1
. .\hp-summer.ps1

$config = [Config]::new()
$data = [DataCollection]::new()

#$imageListFullPath = ".\prod\"+$config.imageList

function TestCase {
    param (
        [string] $InputValue,
        [string] $ExpectedValue,
        [string] $TestName,
        [switch] $SilentResult
    )
    
    if ($InputValue -eq $ExpectedValue) {
        if ($SilentResult -eq $true) { $InputValue = "TestCase/Silent"}
        Write-Host "[PASS].................... $TestName => [$InputValue]" -ForegroundColor Green
    } else {
        Write-Host "[FAIL].................... $TestName => [$InputValue]" -ForegroundColor Red
    }
}

Write-Host "*** TESTS / ValidateSerialNumber: null, 10a ***" -ForegroundColor Cyan
$testValue = ValidateSerialNumber -InputSerialNumber "AAA"
TestCase -InputValue $testValue -ExpectedValue $null -TestName "Pass when null"
$testValue = ValidateSerialNumber -InputSerialNumber "aaaaaaaaaa"
TestCase -InputValue $testValue -ExpectedValue "aaaaaaaaaa" -TestName "Pass when correct"

Write-Host "*** TESTS / ValidateProductNumberWithoutLanguageCode: 3a, to long and short to null and Clear ***" -ForegroundColor Cyan
$testValue = ValidateProductNumberWithoutLanguageCode -InputProductNumber "aaa"
TestCase -InputValue $testValue -ExpectedValue $null -TestName "aaa to null"
$testValue = ValidateProductNumberWithoutLanguageCode -InputProductNumber "1A2B3CX#ABD" 
TestCase -InputValue $testValue -ExpectedValue "1A2B3CX" -TestName "Clear 1A2B3CX#ABD"
$testValue = ValidateProductNumberWithoutLanguageCode -InputProductNumber "1A2B3CX#AB" 
TestCase -InputValue $testValue -ExpectedValue $null -TestName "Invalid shorter 1A2B3CX#AB to null"
$testValue = ValidateProductNumberWithoutLanguageCode -InputProductNumber "1A2B3CX#ABZZ" 
TestCase -InputValue $testValue -ExpectedValue $null -TestName "Invalid longer 1A2B3CX#ABZZ to null"

<#
Write-Host "*** TESTS / primaryWebRequest: 0, 26 ***" -ForegroundColor Cyan
$data.jsonData = primaryWebRequest -ApiServer $config.APIServer -SerialNumber "aaaaaaaaaa"
$data.jsonLength = ($data.jsonData.Body.SerialNumberBOM.unit_configuration.part_description).length
TestCase -InputValue $data.jsonLength -ExpectedValue 0 -TestName "Invalid SN"

# Body.SerialNumberBOM.unit_configuration.part_description
# Body.SerialNumberBOM.unit_configuration
$data.jsonData = primaryWebRequest -ApiServer $config.APIServer -SerialNumber "CND03023JQ"
$data.jsonLength = ($data.jsonData.Body.SerialNumberBOM.unit_configuration.part_description).Length
TestCase -InputValue $data.jsonLength -ExpectedValue 26 -TestName "Valid SN"

Write-Host "*** TESTS / primaryWebRequest: Invalid URL ***" -ForegroundColor Cyan
$data.jsonData = primaryWebRequest -ApiServer "https://xxxxXXXxxxxDoesnotExistDoaminxXxxxxxxxXX" -SerialNumber "CND03023JQ"
$data.jsonLength = ($data.jsonData.Body.SerialNumberBOM.unit_configuration.part_description).Length
TestCase -InputValue $data.jsonData -ExpectedValue $HPSideErrorMessage -TestName "Invalid URL" -SilentResult

Write-Host "*** TESTS / primaryWebRequest / Seconary Request: Invalid PN***" -ForegroundColor Cyan
$data.jsonData = primaryWebRequest -ApiServer $config.APIServer -SerialNumber "CND03023JQ" -ProductNumber "asdasdasd"
TestCase -InputValue $data.jsonData -ExpectedValue $HPSideErrorMessage -TestName "InvalidPN: asdasdasd" -SilentResult

Write-Host "*** TESTS / primaryWebRequest / Seconary Request: Valid PN***" -ForegroundColor Cyan
$data.jsonData = primaryWebRequest -ApiServer $config.APIServer -SerialNumber "4CE1222G4H" -ProductNumber "492K6EA"
$data.jsonData > ".\validPNBrokentest.json"
$testValue = $data.jsonData.Body.SerialNumberBOM.wwsnrsinput.serial_no
TestCase -InputValue $testValue -ExpectedValue "4CE1222G4H" -TestName "Valid PN: 492K6EA"
#>

Write-Host "[TODO]: TESTS / Config Class" -ForegroundColor Yellow
Write-Host "[TODO]: TESTS / DataCollection Class" -ForegroundColor Yellow
$data.jsonData

Write-Host "*** TESTS / checkImage / Last Update, image are availabe and not***" -ForegroundColor Cyan
$testValue = checkImage -ProductNumber "61S64EA#ABD" -FilePath "./this/path/does/not/exists/noexist.txt"
TestCase -InputValue $testValue[0] -ExpectedValue "Missing file: ./this/path/does/not/exists/noexist.txt" -TestName "Missing file"
$testValue = checkImage -ProductNumber "61S64EA#ABD" -FilePath $config.imageList
TestCase -InputValue $testValue[0] -ExpectedValue "21-03-2024 06:26:44" -TestName "Date"
$testValue = checkImage -ProductNumber "61S64EA#ABD" -FilePath $config.imageList
TestCase -InputValue $testValue[1] -ExpectedValue $true -TestName "hasImage: TRUE"
$testValue = checkImage -ProductNumber "A1B2C3A#ABD" -FilePath $config.imageList
TestCase -InputValue $testValue[1] -ExpectedValue $false -TestName "hasImage: FALSE"

