. ../src/Unknown-Device-Handler-Tools.ps1

function TestCase {
    param (
        [string] $InputValue,
        [string] $ExpectedValue,
        [string] $TestName,
        [switch] $SilentResult
    )
    
    if ($InputValue -eq $ExpectedValue) {
        if ($SilentResult -eq $true) { $InputValue = "TestCase/Silent"}
        Write-Host "[PASS]............... $TestName => [$InputValue]" -ForegroundColor Green
    } else {
        Write-Host "[FAIL]............... $TestName => [$InputValue]" -ForegroundColor Red
    }
}
"### TEST CONDITIONS ####################################################################################################"
#Write-Host ">>> Disabled tests here <<<"
$testDevices = Get-WmiObject Win32_PnPentity | Where-Object {$_.PNPClass -eq "Display" -and $_.Manufacturer -match "Red Hat"}
$infFiles = Get-ChildItem -Path ".\" -Recurse -Filter *.inf
PNPInstallProcess -UnknownDeviceList $testDevices -InfFiles $infFiles
"########################################################################################################################"
Write-Host "*** Test Config.json Availability" -ForegroundColor Cyan
$config = Get-Content -Path "../src/Config.json" | ConvertFrom-Json
$config
"########################################################################################################################"
Write-Host "*** Test get-unknown-devices.ps1 / GetUnknownDevices ***" -ForegroundColor Cyan
$testInput = GetUnknownDevices
$testExcepted = 0
TestCase -InputValue $testInput.Length -ExpectedValue $testExcepted -TestName "GetUnknownDevices + MicrosofotBasicDisplay / PASS drivers  "
$testInput = GetUnknownDevices
$testExcepted = 2
Write-Host "[MISS] Missing Failed device test" -ForegroundColor Yellow
#TestCase -InputValue $testInput.Length -ExpectedValue $testExcepted -TestName "GetUnknownDevices + MicrosofotBasicDisplay / FAIL drivers !!! CANT TEST !!!"
"########################################################################################################################"
Write-Host "*** Test get-unknown-devices.ps1 / CheckDeviceIDInFile ***" -ForegroundColor Cyan
$testInput = CheckDeviceIDInFile -FilePath ".\testInf.txt" -Pattern "VEN_1234&DEV_5678"
$testExcepted = $null
TestCase -InputValue $testInput -ExpectedValue $testExcepted -TestName "Check ; is ignored -> null"

$testInput = CheckDeviceIDInFile -FilePath ".\testInf.txt" -Pattern ""
$testExcepted = $null
TestCase -InputValue $testInput -ExpectedValue $testExcepted -TestName "Check EMPTY (null) pattern not matching any row"

$testInput = CheckDeviceIDInFile -FilePath ".\testInf.txt" -Pattern " "
$testExcepted = $null
TestCase -InputValue $testInput -ExpectedValue $testExcepted -TestName "Check EMPTY (space) pattern not matching any row"

$testInput = CheckDeviceIDInFile -FilePath ".\testInf.txt" -Pattern "PCI\VEN_1B36&DEV_0100" -Silent
$testExcepted = $true
TestCase -InputValue $testInput -ExpectedValue $testExcepted -TestName "TRUE - Pattern match"

$testInput = CheckDeviceIDInFile -FilePath "./qxl.inf" -Pattern "PCI\VEN_1b36&DEV_0100&SUBSYS_11001af4" -Silent
$testExcepted = $true
TestCase -InputValue $testInput -ExpectedValue $testExcepted -TestName "CheckDeviceIDInFile xql.inf / true                         "

$testInput = CheckDeviceIDInFile -FilePath "./qxldod.inf" -Pattern "4d36e968-e325-11ce-bfc1-08002be10318" -Silent
$testExcepted = $true
TestCase -InputValue $testInput -ExpectedValue $testExcepted -TestName "CheckDeviceIDInFile qxldod.inf / true                      "

$testInput = CheckDeviceIDInFile -FilePath "./qxldod.inf" -Pattern "http://www.apache.org/licenses/LICENSE-2.0"
$testExcepted = ""
TestCase -InputValue $testInput -ExpectedValue $testExcepted -TestName "CheckDeviceIDInFile qxldod.inf / false for row start with ;"
"########################################################################################################################"
Write-Host "*** Test get-unknown-devices.ps1 / SelfTests ***" -ForegroundColor Cyan
$testInput = SelfTestPathCheck -Path "C:\not\existing\path"
$testExcepted = "Missing path: [C:\not\existing\path]"
TestCase -InputValue $testInput -ExpectedValue $testExcepted -TestName "SelfTestPathCheck / non existing path"

$testInput = SelfTestPathCheck -Path "C:\Windows" -ExitOnFail
$testExcepted = $true
TestCase -InputValue $testInput -ExpectedValue $testExcepted -TestName "SelfTestPathCheck / existing path    "

$testInput = SelfTestInfFiles -InfArray (Get-ChildItem -Path ".\" -Recurse -Filter *.inf) -ExitOnFail
$testExcepted = ""
TestCase -InputValue $testInput -ExpectedValue $testExcepted -TestName "SelfTestInfFiles / OK                "

$testInput = SelfTestInfFiles -InfArray (Get-ChildItem -Path "C:\Users\Public\Videos\" -Recurse -Filter *.inf)
$testExcepted = "Missing .inf file list. Exit"
TestCase -InputValue $testInput -ExpectedValue $testExcepted -TestName "SelfTestInfFiles / FAIL              "

$testInputArray = @()
$testInput = SelfTestUnknownDevices -UnknownDevices $testInputArray
$testExcepted = "All device ready to use."
TestCase -InputValue $testInput -ExpectedValue $testExcepted -TestName "SelfTestUnknownDevices / PASS : 0=$($unknownDevices.Length)  "

$testInputArray = @("1", "2")
$testInput = SelfTestUnknownDevices -UnknownDevices $testInputArray
$testExcepted = "2"
TestCase -InputValue $testInput -ExpectedValue $testExcepted -TestName "SelfTestUnknownDevices / Exist: 2=$($testInputArray.Length)  "
