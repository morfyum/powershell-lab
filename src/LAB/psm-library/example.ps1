Import-Module ./example/example.psm1
Import-Module ./psmHelper/psmHelper.psm1

Write-Host "**** Functions ****" -ForegroundColor Yellow
Get-Something
Set-Something
New-Something

Write-Host "**** Get-Command -Module example ****" -ForegroundColor Yellow
Get-Command -Module example

Write-Host "**** Get-Command -Module psmHelper ****" -ForegroundColor Yellow
Get-Command -Module psmHelper

Write-Host "**** Exec ****" -ForegroundColor Yellow

psm-Helper asd
