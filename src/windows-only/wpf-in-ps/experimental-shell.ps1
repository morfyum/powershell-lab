
$lastCommand = ""
function Show-Menu {
Clear-Host
Write-Host "┌─────────────────────────────────────────────────────────────────────────────────────────────────────────────────┐"
Write-Host "  Q  : Quit | $lastCommand" -ForegroundColor DarkGreen
Write-Host "└─────────────────────────────────────────────────────────────────────────────────────────────────────────────────┘"
Write-Host "| 0  : Option 0                | 10  : Windows 10 Activator      | 20  : "
Write-Host "| 1  : WPF Applicatons         | 11  : Windows 11 Activator      | 21  : "
Write-Host "| 2  : App manager             | 12  : -                         | 22  : "
Write-Host "| 3  : Option 4                | 13  : -                         | 23  : "
Write-Host "| 4  : Option 5                | 14  : -                         | 24  : "
Write-Host "| 5  : Option 6                | 15  : -                         | 25  : "
Write-Host "| 6  : Option 7                | 16  : -                         | 26  : "
Write-Host "| 7  : Option 8                | 17  : -                         | 27  : "
Write-Host "| 8  : Option 9                | 18  : -                         | 28  : "
Write-Host "| 9  : Option 10               | 19  : -                         | 29  : "
Write-Host "-------------------------------------------------------------------------------------------------------------------"
}


do {
    Show-Menu
    
    $shellInput = Read-Host "Input"
    while ($shellInput -eq "") {
        $shellInput = Read-Host "Input"
    }
    $lastCommand = $shellInput
    switch ($shellInput) {
        0  {$lastCommand = $lastCommand+': Try an another button '}
        1  {$lastCommand = $lastCommand+': WPF App '; .\app.ps1} 
        2  {$lastCommand = $lastCommand+': You chose option #2'}
        3  {$lastCommand = $lastCommand+': You chose option #3'}
        10 {$lastCommand = $lastCommand+': W10 Activator '}
        11 {$lastCommand = $lastCommand+': W11 Activator'}
        '00' { Write-Host "Exit, Goodbye"; Exit 0}
    }

} until ($shellInput -eq 'q')
Write-Host "Exit, Goodbye! "
