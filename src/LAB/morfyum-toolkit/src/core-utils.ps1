function windowsAdminRequest {
    param (
        [Parameter(mandatory=$true)]
        [string[]] $RequestFor
    )
    Write-Output "Request Administrator privileges..."
    Write-Output "Current directroy: [ $selfLocation ]"
    Write-Output "$RequestFor"
    Write-Output "Waiting for process..."
    Start-Process powershell.exe -Verb runAs -ArgumentList "cd $selfLocation; powershell.exe -ExecutionPolicy RemoteSigned $RequestFor" -Wait
    #Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy Unrestricted -Force
    #Start-Process powershell.exe -Verb runAs -ArgumentList "powershell.exe -ExecutionPolicy RemoteSigned $RequestFor" -Wait
}