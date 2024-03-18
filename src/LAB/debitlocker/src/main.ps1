$selfLocation = (Get-Location).Path
function WindowsAdminRequest {
    param (
        [Parameter(mandatory=$true)]
        [string[]] $RequestFor
    )
    Write-Output "Request Administrator privileges..."
    Write-Output "Current directroy: [ $selfLocation ]"
    Write-Output "$RequestFor"
    Write-Output "Waiting for process..."
    Set-Location $selfLocation
    Start-Process powershell.exe -Verb runAs -ArgumentList "cd $selfLocation; powershell.exe -ExecutionPolicy ByPass -File $RequestFor"
}
windowsAdminRequest -RequestFor "debitlocker.ps1"