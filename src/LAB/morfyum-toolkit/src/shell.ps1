# SELF CONFIGURATION AND VARIABLES 
$selfLocation = (Get-Location).path
$selfConfig = Get-Content -Path "$selfLocation\shell-config.json" | Out-String | ConvertFrom-Json
$host.UI.RawUI.WindowTitle = "$($selfConfig.appName)"
$currentDate = Get-Date -Format "yyyy-MM-dd"
$lastCommand = ""

function Show-Menu {
    Clear-Host
    Write-Host "┌──────────────────────────────────────────────────────────────────────────────────────────────────┐"
    Write-Host "  Q  : Quit | $lastCommand" -ForegroundColor DarkGreen
    Write-Host "└──────────────────────────────────────────────────────────────────────────────────────────────────┘"
    Write-Host "| 0  : Analyze-system-health   | 10  : Windows 10 Activator      | 20  :                           |"
    Write-Host "| 1  : -                       | 11  : Windows 11 Activator      | 21  :                           |"
    Write-Host "| 2  : -                       | 12  : -                         | 22  :                           |"
    Write-Host "| 3  : -                       | 13  : -                         | 23  :                           |"
    Write-Host "| 4  : Policy status           | 14  : -                         | 24  :                           |"
    Write-Host "| 5  :                         | 15  : -                         | 25  :                           |"
    Write-Host "| 6  :                         | 16  : -                         | 26  :                           |"
    Write-Host "| 7  : Wifi-speed-test         | 17  : -                         | 27  :                           |"
    Write-Host "| 8  : Admin-Test              | 18  : -                         | 28  :                           |"
    Write-Host "| 9  : Check-Bitlocker-Status  | 19  : -                         | 29  :                           |"
    Write-Host "----------------------------------------------------------------------------------------------------"
    Write-Host "[ $($selfConfig.appName) ][ $($currentDate) ][ $(Get-ExecutionPolicy) ]"
    #Write-Host "[ $selfLocation ]"
    Write-Host "----------------------------------------------------------------------------------------------------"
}

function windowsAdminRequest {
    param (
        [Parameter(mandatory=$true)]
        [string[]] $RequestFor
    )
    Write-Host "┌ Request Administrator privileges..." -ForegroundColor Yellow
    Write-Host "│ Current directroy: [ $selfLocation ]" -ForegroundColor Gray
    Write-Host "└ Waiting for process..." -ForegroundColor Yellow
    #Start-Process powershell.exe -Verb runAs -ArgumentList "cd $selfLocation; powershell.exe -ExecutionPolicy RemoteSigned $RequestFor" -Wait
    Start-Process powershell.exe -Verb runAs -ArgumentList "powershell.exe -ExecutionPolicy RemoteSigned $RequestFor" -Wait
}

function SetCurrentUserExecutionPolicy {
    param (
        [Parameter(mandatory=$true)]
        [string] $ExecutionPolicy
    )
    Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy $ExecutionPolicy
    return Get-ExecutionPolicy
}

do {
    Show-Menu
    
    $shellInput = Read-Host "Input"
    while ($shellInput -eq "") {
        Show-Menu
        $shellInput = Read-Host "Input"
    }
    $lastCommand = $shellInput
    switch ($shellInput) {
        0  {$lastCommand = $lastCommand+': 🔥 TODO -> Not implemented'}
        1  {$lastCommand = $lastCommand+': TEST '}
        2  {$lastCommand = $lastCommand+": You chose option #2"}
        3  {$lastCommand = $lastCommand+': You chose option #3'}
        4  {$lastCommand = $lastCommand+": Policy status: [$(Get-ExecutionPolicy)]"}
        5  {$lastCommand = $lastCommand+": - "}
        6  {$lastCommand = $lastCommand+": - "}
        7  {$lastCommand = $lastCommand+": 🔥 TODO -> Not implemented"}
        8  {$lastCommand = $lastCommand+': Check-Bitlocker-Status'; windowsAdminRequest -RequestFor "C:\Users\mars\Desktop\git\powershell-lab\src\LAB\todo-elevate_ps1-and-wurcraft\tests\test_no_root_external_powershell.ps1" }
        9  {$lastCommand = $lastCommand+': Check-Bitlocker-Status'; windowsAdminRequest -RequestFor "$selfLocation\get-bitlocker-status\get-bitlocker-status.ps1" }
        10 {$lastCommand = $lastCommand+': 🔥 TODO -> Not implemented'}
        11 {$lastCommand = $lastCommand+': 🔥 TODO -> Not implemented'}
        '00' { Write-Host "Exit, Goodbye"; Exit 0}
    }
} until ($shellInput -eq 'q')
Write-Host "Exit, Goodbye! "