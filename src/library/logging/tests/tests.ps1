# IMPORT
. ../logging.ps1

$loggingDestination = ".\LOGTests.log"
Write-Host "# Test -Less logging" -ForegroundColor Cyan
Logging -LogLevel "INFO" -LogMessage "Test logging.ps1 -Less" -LogDestination $loggingDestination -SetColors -Less
Write-Host "# Test Logging colors" -ForegroundColor Cyan
Logging -LogLevel "INFO" -LogMessage "Test logging.ps1 INFO" -LogDestination $loggingDestination -SetColors
Logging -LogLevel "WARNING" -LogMessage "Test logging.ps1 WARNING" -LogDestination $loggingDestination -SetColors
Logging -LogLevel "ERROR" -LogMessage "Test logging.ps1 ERROR" -LogDestination $loggingDestination -SetColors
Logging -LogLevel "CRITICAL" -LogMessage "Test logging.ps1 CRITICAL" -LogDestination $loggingDestination -SetColors

Write-Host "# Test Logging no colors" -ForegroundColor Cyan
Logging -LogLevel "INFO" -LogMessage "Test logging.ps1 nocolors" -LogDestination $loggingDestination
Logging -LogLevel "WARNING" -LogMessage "Test logging.ps1 nocolors" -LogDestination $loggingDestination
Logging -LogLevel "ERROR" -LogMessage "Test logging.ps1 nocolors" -LogDestination $loggingDestination
Logging -LogLevel "CRITICAL" -LogMessage "Test logging.ps1 nocolors" -LogDestination $loggingDestination

Write-Host "# Test SetFileNameOnly" -ForegroundColor Cyan
Logging -LogLevel "INFO" -LogMessage "Test logging.ps1 SetFileNameOnly" -LogDestination $loggingDestination -SetFileNameOnly

Write-Host "# Test last log" -ForegroundColor Cyan
$currentLog = Logging -LogLevel "INFO" -LogMessage "Test logging.ps1" -LogDestination $loggingDestination
#Write-Output "FORCE TO FAIL TEST" >> $loggingDestination
$lastLog = (Get-Content -Tail 1 $loggingDestination)
if ($lastLog -eq $currentLog) {
    Write-Host "- PASS: $lastLog" -ForegroundColor Green
} else {
    Write-Host "- FAIL: $lastLog" -ForegroundColor Red
    Write-Host "  - LastLog: $lastlog"
    Write-Host "  - currentLog: $currentLog"
}