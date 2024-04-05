#IMPORT
. .\hp-summer.ps1

$config = [Config]::new()
$data = [DataCollection]::new()

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

$data.jsonData | Out-Null # required because static code analyst cries

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

Write-Host "*** TESTS / class: Config ***" -ForegroundColor Yellow
TestCase -InputValue $($config.usbkey) -ExpectedValue "E" -TestName "Config.usbkey eq [E]"
TestCase -InputValue $($config.invokedFile) -ExpectedValue "invokedFile.txt" -TestName "Config.invokedFile eq [invokedFile.txt]"
TestCase -InputValue $config.exampleTattooFile -ExpectedValue "exampleTattoo.tattoo" -TestName "config.exampleTattoo -eq [exampleTattoo.tattoo]"
TestCase -InputValue $config.APIServer -ExpectedValue "https://pro-psurf-app.glb.inc.hp.com" -TestName "config.APIServer -eq [https://pro-psurf-app.glb.inc.hp.com]"
TestCase -InputValue $config.SKUListFullPath -ExpectedValue "sku-list-test.csv" -TestName "config.SKUListFullPath -eq [sku-list-test.csv]"
TestCase -InputValue $config.KITListFullPath -ExpectedValue "kit-list-test.csv" -TestName "config.KITListFullPath -eq [kit-list-test.csv]"
TestCase -InputValue $config.imageList -ExpectedValue ".\prod\image-lista.txt" -TestName "config.imageList -eq [.\\prod\\image-lista.txt]"
TestCase -InputValue $config.imageQueryEnabled -ExpectedValue "yes" -TestName "config.imageQueryEnabled -eq [yes]"
TestCase -InputValue $config.fatalError -ExpectedValue $HPSideErrorMessage -TestName "config.fatalError -eq [var HPSideErrorMessage]" -SilentResult

<#
Write-Host "*** TESTS / class: DataCollection / unnecessary null test***" -ForegroundColor Cyan
TestCase -InputValue $data.jsonData -ExpectedValue $null -TestName "data.jsonData -eq null"
TestCase -InputValue $data.jsonLength -ExpectedValue 0 -TestName "data.jsonLength -eq [0]"
TestCase -InputValue $data.ProductNumber -ExpectedValue $null -TestName "data.ProductNumber -eq null"
TestCase -InputValue $data.tattooSerialNumber -ExpectedValue $null -TestName "data.tattooSerialNumber -eq null"
TestCase -InputValue $data.tattooProductNumber -ExpectedValue $null -TestName "data.tattooProductNumber -eq null"
TestCase -InputValue $data.tattooProductName -ExpectedValue $null -TestName "data.tattooProductName -eq null"
TestCase -InputValue $data.tattooBuildID -ExpectedValue $null -TestName "data.tattooBuildID -eq null"
TestCase -InputValue $data.tattooFeatureByte -ExpectedValue $null -TestName "data.tattooFeatureByte -eq null"

TestCase -InputValue $data.tattooSystemFamily -ExpectedValue "HP" -TestName "data.tattooSystemFamily -eq [HP]"

TestCase -InputValue $data.languageCode -ExpectedValue $null -TestName "data.languageCode -eq null"
TestCase -InputValue $data.imageVersion -ExpectedValue $null -TestName "data.imageVersion -eq null"
TestCase -InputValue $data.OS -ExpectedValue $null -TestName "data.OS -eq null"
TestCase -InputValue $data.platform -ExpectedValue $null -TestName "data.platform -eq null"
TestCase -InputValue $data.platformVersion -ExpectedValue $null -TestName "data.platformVersion -eq null"
TestCase -InputValue $data.hasImage -ExpectedValue $null -TestName "data.hasImage -eq null"

TestCase -InputValue $data.hasKIT -ExpectedValue $false -TestName "data.hasKIT -eq false"

TestCase -InputValue $data.ComponentNumber -ExpectedValue $null -TestName "data.ComponentNumber -eq null"
TestCase -InputValue $data.ComponentDescription -ExpectedValue $null -TestName "data.ComponentDescription -eq null"
TestCase -InputValue $data.ComponentSerialNo -ExpectedValue $null -TestName "data.ComponentSerialNo -eq null"
#>

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
#$data.jsonData > ".\validPNBrokentest.json"
$testValue = $data.jsonData.Body.SerialNumberBOM.wwsnrsinput.serial_no
TestCase -InputValue $testValue -ExpectedValue "4CE1222G4H" -TestName "Valid PN: 492K6EA"
#>

Write-Host "*** TESTS / checkImage / Last Update, image are availabe and not***" -ForegroundColor Cyan
$testValue = checkImage -ProductNumber "61S64EA#ABD" -FilePath "./this/path/does/not/exists/noexist.txt"
TestCase -InputValue $testValue[0] -ExpectedValue "Missing file: ./this/path/does/not/exists/noexist.txt" -TestName "Missing file"
$testValue = checkImage -ProductNumber "61S64EA#ABD" -FilePath $config.imageList
TestCase -InputValue $testValue[0] -ExpectedValue "21-03-2024 06:26:44" -TestName "Date"
$testValue = checkImage -ProductNumber "61S64EA#ABD" -FilePath $config.imageList
TestCase -InputValue $testValue[1] -ExpectedValue $true -TestName "hasImage: TRUE"
$testValue = checkImage -ProductNumber "A1B2C3A#ABD" -FilePath $config.imageList
TestCase -InputValue $testValue[1] -ExpectedValue $false -TestName "hasImage: FALSE"
