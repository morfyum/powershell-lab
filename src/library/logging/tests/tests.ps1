# IMPORT
. ../logging.ps1

$loggingDestination = "C:\Users\mars\Desktop\git\powershell-lab\src\LAB\logging\LOGTests.log"
Write-Host "# Test -Less logging" -ForegroundColor Cyan
Logging -LoggingLevel "INFO" -LoggingMessage "Test logging.ps1 -Less" -LoggingDestination $loggingDestination -SetColors -Less
Write-Host "# Test Logging colors" -ForegroundColor Cyan
Logging -LoggingLevel "INFO" -LoggingMessage "Test logging.ps1 INFO" -LoggingDestination $loggingDestination -SetColors
Logging -LoggingLevel "WARNING" -LoggingMessage "Test logging.ps1 WARNING" -LoggingDestination $loggingDestination -SetColors
Logging -LoggingLevel "ERROR" -LoggingMessage "Test logging.ps1 ERROR" -LoggingDestination $loggingDestination -SetColors
Logging -LoggingLevel "CRITICAL" -LoggingMessage "Test logging.ps1 CRITICAL" -LoggingDestination $loggingDestination -SetColors

Write-Host "# Test Logging no colors" -ForegroundColor Cyan
Logging -LoggingLevel "INFO" -LoggingMessage "Test logging.ps1 nocolors" -LoggingDestination $loggingDestination
Logging -LoggingLevel "WARNING" -LoggingMessage "Test logging.ps1 nocolors" -LoggingDestination $loggingDestination
Logging -LoggingLevel "ERROR" -LoggingMessage "Test logging.ps1 nocolors" -LoggingDestination $loggingDestination
Logging -LoggingLevel "CRITICAL" -LoggingMessage "Test logging.ps1 nocolors" -LoggingDestination $loggingDestination

Write-Host "# Test SetFileNameOnly" -ForegroundColor Cyan
Logging -LoggingLevel "INFO" -LoggingMessage "Test logging.ps1 SetFileNameOnly" -LoggingDestination $loggingDestination -SetFileNameOnly

Write-Host "# Test last log" -ForegroundColor Cyan
$currentLog = Logging -LoggingLevel "INFO" -LoggingMessage "Test logging.ps1" -LoggingDestination $loggingDestination
#Write-Output "FORCE TO FAIL TEST" >> $loggingDestination
$lastLog = (Get-Content -Tail 1 $loggingDestination)
if ($lastLog -eq $currentLog) {
    Write-Host "- PASS: $lastLog" -ForegroundColor Green
} else {
    Write-Host "- FAIL: $lastLog" -ForegroundColor Red
}