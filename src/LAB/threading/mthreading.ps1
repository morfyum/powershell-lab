
$path = "C:\Users\mars\Desktop"
$file = "loading.ps1"
$fullPath = "$path\$file"
$maxProcesses = 5
$processLifetime = Get-Random -Maximum 30 -Minimum 10

$processList = @()
$processMaxLifeInSeconds = @()


function startThisProcess {
    Start-Process -FilePath "powershell.exe" -ArgumentList "-NoExit", "-File", "$fullPath"
    Start-Sleep -Seconds 2
    $processId = Get-Process | Where-Object { $_.ProcessName -eq "powershell" -and $_.StartTime -ge (Get-Date).AddMinutes(-1) } | Sort-Object StartTime -Descending
    $lastProcessId = $processId[0].Id
    return $lastProcessId
}

$counter = 0

while ($true) {
    $index = 0
    if ($processList.Length -lt $maxProcesses) {
        
        $currentProcessId = startThisProcess
        $processLifetime = Get-Random -Maximum 60 -Minimum 15
        
        Write-Output "ProcessID: [$currentProcessId] => New Process for $processLifeTime seconds..."
        $processList += $currentProcessId
        $processMaxLifeInSeconds +=  $processLifeTime
        $counter++
        Start-Sleep -Seconds 3
    } else {
        Clear-Host
        Write-Output "Watching... counter[$counter] i[$index]"
        $processList | ForEach-Object {
            Write-Output "Process: [$_] $($processMaxLifeInSeconds[$index])"
            if ($($processMaxLifeInSeconds[$index]) -gt 0) {
                $processMaxLifeInSeconds[$index] = $($processMaxLifeInSeconds[$index])-1
            }
            if ( $processMaxLifeInSeconds[$index] -eq 0 -and $processList[$index] -ne "Stopped") {
                #Write-Host "Start New process..."
                Write-Output "Stop Process... $($processList[$index])"
                Stop-Process -Id $($processList[$index])
                $processList[$index] = "Stopped"
            } else {
                # pass
            }
            $index++
        }
        Start-Sleep -Seconds 1
    }
}




<#
while ($processList.Length -lt $maxProcesses) {
    Write-Output "Start New Process $($porcessList.Length)"
    $processList += "$($processList.Length)"
    Write-Output "$processList"
}#>

# Ellenőrzés, hogy létezik-e még a folyamat

<#if (Get-Process -Id $processId -ErrorAction SilentlyContinue) {
    Write-Output "Running: $processId"
} else {
    Write-Output "Stopped: $processId"
}
#>


