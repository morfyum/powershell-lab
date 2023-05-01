# STATISTICS
# Get-Service -Name "vss" |select starttype, status, name, displayName
#
# Display running services:
# Get-Service | Where-Object {$_.Status -eq "Running"} | Measure-Object | Select-Object).Count
#

Write-Host "*** Count Processes: ( 76-80 before) ***" -ForegroundColor Yellow
$running_processes = (Get-Process | Measure-Object | Select-Object).Count
Write-Host "Processes: [ $running_processes ]"


Write-Host "*** Count Services: ALL: 258 ***" -ForegroundColor Yellow
$all_service = (Get-Service | Measure-Object | Select-Object).Count
Write-Host "All: [ $all_service ]"


Write-Host "*** Running Services: 78-80 ***" -ForegroundColor Yellow
$running_services = (Get-Service | Where-Object {$_.Status -eq "Running"} | Measure-Object | Select-Object).Count
Write-Host "Running [ $running_services ]"

