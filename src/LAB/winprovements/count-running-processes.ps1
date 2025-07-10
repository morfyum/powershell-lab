# STATISTICS
# Get-Service -Name "vss" |select starttype, status, name, displayName
#
# Display running services:
# Get-Service | Where-Object {$_.Status -eq "Running"} | Measure-Object | Select-Object).Count
#

Write-Host "*** Running Processes ***" -ForegroundColor Cyan
Write-Host "  - Default: 76-80 on Windows 10" -ForegroundColor Gray
$running_processes = (Get-Process | Measure-Object | Select-Object).Count
Write-Host "  - Currently running Processes: [ $running_processes ]" -ForegroundColor Green

$all_service = (Get-Service | Measure-Object | Select-Object).Count
#Write-Host "All: [ $all_service ]"

Write-Host "*** Running Services ***" -ForegroundColor Cyan
Write-Host "  - Default: 78-80 on Windows 10 (all: $all_service)" -ForegroundColor Gray
$running_services = (Get-Service | Where-Object {$_.Status -eq "Running"} | Measure-Object | Select-Object).Count
Write-Host "  - Currently Running: [ $running_services ]" -ForegroundColor Green

