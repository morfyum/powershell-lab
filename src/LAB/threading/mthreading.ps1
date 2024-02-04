
$path = (Get-Location).Path
$file = "loading.ps1"
$fullPath = "$path\$file"
$maxProcesses = 5
#$processLifetime = Get-Random -Maximum 30 -Minimum 10

$processList = @()
$processMaxLifeInSeconds = @()

if ((Test-Path -Path $fullPath) -eq $false) {
    Write-Error "Wrong $fullPath. Exit"
    Exit
}

function startNewProcess {
    param (
        [Parameter(mandatory=$true)]
        [string] $FilePath,
        [switch] $StartSlow
    )
    #Start-Process -FilePath "powershell.exe" -ArgumentList "-NoExit", "-File", "$FilePath"
    if ($FilePath -match ".ps1") {
        Start-Process -FilePath "powershell.exe" -ArgumentList "-NoExit", "-File", "$FilePath"
        $processPattern = "powershell"
    } else {
        Start-Process -FilePath $FilePath
        $processPattern = $FilePath
    }

    if ($StartSlow -eq $true) {
        Start-Sleep -Seconds 6
    }
    # processIdArray required, because we need to calculate what process started. Currently LAST ID is the last started process.
    $processIdArray = Get-Process | Where-Object { $_.ProcessName -eq $processPattern -and $_.StartTime -ge (Get-Date).AddMinutes(-1) } | Sort-Object StartTime -Descending
    $processId = $processIdArray[0].Id
    return $processId
}

$counter = 0

while ($true) {
    $index = 0
    if ($processList.Length -lt $maxProcesses) {
        
        $currentProcessId = startNewProcess -FilePath $fullPath # "notepad.exe" # $fullPath
        $curremtProcessLifetime = 10 #Get-Random -Maximum 20 -Minimum 15
        
        Write-Output "ProcessID: [$currentProcessId] => New Process for [$curremtProcessLifetime] seconds..."
        $processList += $currentProcessId
        $processMaxLifeInSeconds +=  $curremtProcessLifetime
        $counter++
        Start-Sleep -Seconds 1
    } else {
        #Clear-Host
        [Console]::Clear()
        #Write-Output "Watching... [$counter] started."
        [Console]::WriteLine("Watching [ $counter ] started process...")
        $processList | ForEach-Object {
            #Write-Output "Process: [$_] $($processMaxLifeInSeconds[$index])"
            [Console]::WriteLine("Process: [$_] $($processMaxLifeInSeconds[$index])")
            if ($($processMaxLifeInSeconds[$index]) -gt 0) {
                $processMaxLifeInSeconds[$index]--

                #if ($(Get-Process -Id $($processList[$index]) -ErrorAction SilentlyContinue) -eq $null ) {
                #    $processList[$index] = "Stopped"
                #    $processMaxLifeInSeconds[$index] = 0
                #}
            }
            if ( $processMaxLifeInSeconds[$index] -eq 0 -and $processList[$index] -ne "Stopped") {
                #Write-Host "Start New process..."
                #Write-Output "Stop Process... $($processList[$index])"
                [Console]::WriteLine("Stop Process... $($processList[$index])")

                if ($(Get-Process -Id $($processList[$index]) -ErrorAction SilentlyContinue) -eq $null ) {
                    #pass
                }
                else {
                    #$thisProcessName = (Get-Process -Id $($processList[$index])).ProcessName
                    Stop-Process -Id $($processList[$index]) -Force
                    #Stop-Process -Name $thisProcessName
                    #Start-Sleep -Seconds 1
                }
                $processList[$index] = "Stopped"
            }
            $index++
        }
        Start-Sleep -Seconds 1
    }
}