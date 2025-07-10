. .\debitlocker.ps1

function TestCase {
    param (
        [string] $TestCase,
        [string] $ExpectedValue,
        [string] $Name
    )
    if ($testCase -eq $expectedValue) {
        Write-Host "[PASS] .......... [$TestCase]" -ForegroundColor Green
    } else {
        Write-Host "[FAIL] .......... [$TestCase]" -ForegroundColor Red
    }
}


Write-Host "*** TEST / GetBitlockerState is 0 ***" -ForegroundColor Cyan
$testBitlockerStatus = GetBitlockerStatus
$cValue = $testBitlockerStatus["C:"]
if ($cValue -eq 0) {
    Write-Host "PASS....................[$cValue]" -ForegroundColor Green
    <# Action to perform if the condition is true #>
} else {
    Write-Host "FAIL....................[$cValue]" -ForegroundColor Red
}

Write-Host "*** TEST / ShowState ***" -ForegroundColor Cyan
$STATES = GetBitlockerStatus
$STATES.Add("D:", 100)
ShowState -VolumeList $STATES
