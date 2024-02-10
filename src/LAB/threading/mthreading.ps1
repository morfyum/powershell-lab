$path = (Get-Location).Path
$file = "loading.ps1"
$fullPath = "$path\$file"
$maxProcesses = 3
#$processLifetime = Get-Random -Maximum 30 -Minimum 10
$processList = @()
$processMaxLifeInSeconds = @()
$dictionary = @{}

class ProcessData {
    [int] $ProcessID
    [string] $ProcessState
    [string] $ProcessLifetime
    [string] $ProcessRemainingLife
    [string] $ProcessResult
}
#$CurrentProcessData = [ProcessData]::new()

function GetDictState {
    foreach ($Key in $dictionary.Keys) {
        Write-Host "Key: $Key Value: $($dictionary[$Key])"
    }
}

function SetDictValue {
    param (
        [int] $Key
    )
    if ((Test-Path ".\proc\$Key" -ErrorAction SilentlyContinue) -ne $false  ) {
        $dictionary[$Key] = Get-Content -Path ".\proc\$Key"
        Remove-Item -Path ".\proc\$Key"
    }
}


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
        #Start-Process -FilePath "powershell.exe" -ArgumentList "-NoExit", "-File", "$FilePath" #-WindowStyle hidden
        Start-Process -FilePath "powershell.exe" -ArgumentList "-File", "$FilePath" #-WindowStyle hidden
        $processPattern = "powershell"
    } else {
        Start-Process -FilePath $FilePath
        $processPattern = $FilePath
    }

    if ($StartSlow -eq $true) { Start-Sleep -Seconds 6 }

    # processIdArray required, because we need to calculate what process started. Currently LAST ID is the last started process.
    $processIdArray = Get-Process | Where-Object { $_.ProcessName -eq $processPattern -and $_.StartTime -ge (Get-Date).AddMinutes(-1) } | Sort-Object StartTime -Descending
    $processId = $processIdArray[0].Id
    return $processId
}

$counter = 0
while ($true) {
    $index = 0
    if ($processList.Length -lt $maxProcesses) {
        
        $currentProcessId = startNewProcess -FilePath  .\dummy-process.ps1 #$fullPath
        $curremtProcessLifetime = 20 #Get-Random -Maximum 20 -Minimum 15
        
        Write-Output "ProcessID: [$currentProcessId] => New Process for [$curremtProcessLifetime] seconds..."
        $processList += $currentProcessId
        $processMaxLifeInSeconds +=  $curremtProcessLifetime

        $dictionary.Add($currentProcessId, $null)

        $counter++
        Start-Sleep -Seconds 1
    } else {
        [Console]::Clear()
        [Console]::WriteLine("Watching [ $counter ] started process...")
        GetDictState # -Key $_
        $processList | ForEach-Object {
            [Console]::WriteLine("Process[$index]: [$_] $($processMaxLifeInSeconds[$index])")
            if ($($processMaxLifeInSeconds[$index]) -gt 0) {
                $processMaxLifeInSeconds[$index]--
                SetDictValue -Key $_

                if ($(Get-Process -Id $($processList[$index]) -ErrorAction SilentlyContinue) -eq $null ) {
                    $processList[$index] = "Stopped"
                    $processMaxLifeInSeconds[$index] = 0
                }
            }
            if ( $processMaxLifeInSeconds[$index] -eq 0 -and $processList[$index] -ne "Stopped") {
                [Console]::WriteLine("Stop Process... $($processList[$index])")

                if ($(Get-Process -Id $($processList[$index]) -ErrorAction SilentlyContinue) -eq $null ) {
                    #Porcess exitest by self
                }
                else {
                    #$thisProcessName = (Get-Process -Id $($processList[$index])).ProcessName
                    Stop-Process -Id $($processList[$index]) -Force
                    #Stop-Process -Name $thisProcessName
                    #Start-Sleep -Seconds 1
                }
                $processList[$index] = "Stopped"
            }

            if ($processList[$index] -eq "Stopped") {
                Write-Host "Ready To start New process in ID [$index]"
            }

            $index++
        }
        Start-Sleep -Seconds 1
    }
}