function ErrorHandler {
    param(
        [string] $Message 
    )
    Write-Host "********** [ ERROR HANDLER ] *******************************" -ForegroundColor Red
    Write-Host ""
    Write-Host " $Message" -ForegroundColor Red
    Write-Host ""
    Write-Host "************************************************************" -ForegroundColor Red
}