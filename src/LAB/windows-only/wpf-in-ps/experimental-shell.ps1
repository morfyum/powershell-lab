
$lastCommand = ""
function Show-Menu {
Clear-Host
Write-Host "┌─────────────────────────────────────────────────────────────────────────────────────────────────────────────────┐"
Write-Host "  Q  : Quit | $lastCommand" -ForegroundColor DarkGreen
Write-Host "└─────────────────────────────────────────────────────────────────────────────────────────────────────────────────┘"
Write-Host "| 0  : Option 0                | 10  : Windows 10 Activator      | 20  :                           |"
Write-Host "| 1  : WPF Applicatons         | 11  : Windows 11 Activator      | 21  :                           |"
Write-Host "| 2  : App manager             | 12  : -                         | 22  :                           |"
Write-Host "| 3  : Option 3                | 13  : -                         | 23  :                           |"
Write-Host "| 4  : Policy status           | 14  : -                         | 24  :                           |"
Write-Host "| 5  : Set: Rest               | 15  : -                         | 25  :                           |"
Write-Host "| 6  : Set: RemoteSigned       | 16  : -                         | 26  :                           |"
Write-Host "| 7  : Option 8                | 17  : -                         | 27  :                           |"
Write-Host "| 8  : Option 9                | 18  : -                         | 28  :                           |"
Write-Host "| 9  : Option 10               | 19  : -                         | 29  :                           |"
Write-Host "-------------------------------------------------------------------------------------------------------------------"
}

function ShowExecutionPolicy {
    return Get-ExecutionPolicy
}

function SetCurrentUserExecutionPolicy {
    param (
        [Parameter(mandatory=$true)]
        [string] $ExecutionPolicy
    )
    Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy $ExecutionPolicy
    return ShowExecutionPolicy
}

ShowExecutionPolicy

do {
    Show-Menu
    
    $shellInput = Read-Host "Input"
    while ($shellInput -eq "") {
        Show-Menu
        $shellInput = Read-Host "Input"
    }
    $lastCommand = $shellInput
    switch ($shellInput) {
        0  {$lastCommand = $lastCommand+': Try an another button '}
        1  {$lastCommand = $lastCommand+': WPF App '; ./app.ps1}
        2  {$lastCommand = $lastCommand+": You chose option #2"}
        3  {$lastCommand = $lastCommand+': You chose option #3'}
        4  {$lastCommand = $lastCommand+": Policy status: [$(ShowExecutionPolicy)]"}
        5  {$lastCommand = $lastCommand+": Set Restricted: [$(SetCurrentUserExecutionPolicy -ExecutionPolicy Restricted)]"}
        6  {$lastCommand = $lastCommand+": Set RemoteSigned: [$(SetCurrentUserExecutionPolicy -ExecutionPolicy RemoteSigned)]"}
        10 {$lastCommand = $lastCommand+': W10 Activator '}
        11 {$lastCommand = $lastCommand+': W11 Activator'}
        '00' { Write-Host "Exit, Goodbye"; Exit 0}
    }

} until ($shellInput -eq 'q')
Write-Host "Exit, Goodbye! "
