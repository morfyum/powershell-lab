# IMPORT

$path = (Get-Location).Path
$file = "loading.ps1"
$fullPath = "$path\$file"
$maxProcesses = (Get-WmiObject -Class Win32_processor).NumberOfLogicalProcessors
#$processLifetime = Get-Random -Maximum 30 -Minimum 10
$global:processList = @()
$global:processMaxLifeInSeconds = @()
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
        $PID | Out-File -FilePath "$path\proc\MainProcessPID"  
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

function StartThreads {
    param (
        [int] $MainProcessPID = $PID,
        [int] $SetProcessLifetime,
        [switch] $Loop
    )

    if ($Loop -eq $true) {
        $SetProcessLifetime = 1
    } else {
        if ([int32]$SetProcessLifetime -is [int32] -and $SetProcessLifetime -gt 1) {
            $curremtProcessLifetime = $SetProcessLifetime
        } else {
            Write-Error "Leave empty this value for infinit loop or give a number in seconds what greater than 0"
            Exit
        }
    }


    $counter = 0
    while ($true) {
        $index = 0
        if ($global:processList.Length -lt $maxProcesses) {

            Write-Host "LEN: $($global:processList.Length)"
            Write-Host "LIST: $global:processList"
            Pause
            
            $currentProcessId = startNewProcess -FilePath  .\mersenne-prime-stress.ps1 #$fullPath
            #$curremtProcessLifetime = 20 #Get-Random -Maximum 20 -Minimum 15
            $curremtProcessLifetime = $SetProcessLifetime
            
            Write-Output "ProcessID: [$currentProcessId] => New Process for [$curremtProcessLifetime] seconds..."
            $global:processList += $currentProcessId
            $global:processMaxLifeInSeconds +=  $curremtProcessLifetime

            $dictionary.Add($currentProcessId, $null)

            $counter++
            Start-Sleep -Seconds 1
        } else {
            [Console]::Clear()
            [Console]::WriteLine("Watching [ $counter ] started process...")
            #GetDictState # -Key $_
            $global:processList | ForEach-Object {
                [Console]::WriteLine("Process[$index]: [$_] $($global:processMaxLifeInSeconds[$index])")
                if ($($global:processMaxLifeInSeconds[$index]) -gt 0) {
                    if ($Loop -eq $true) {
                        $global:processMaxLifeInSeconds[$index]++
                    } else {
                        $global:processMaxLifeInSeconds[$index]--
                    }
                    SetDictValue -Key $_

                    if ($(Get-Process -Id $($global:processList[$index]) -ErrorAction SilentlyContinue) -eq $null ) {
                        $global:processList[$index] = "Stopped"
                        $global:processMaxLifeInSeconds[$index] = 0
                    }
                }
                if ( $global:processMaxLifeInSeconds[$index] -eq 0 -and $global:processList[$index] -ne "Stopped") {
                    [Console]::WriteLine("Stop Process... $($global:processList[$index])")

                    if ($(Get-Process -Id $($global:processList[$index]) -ErrorAction SilentlyContinue) -eq $null ) {
                        #Porcess exitest by self
                    }
                    else {
                        #$thisProcessName = (Get-Process -Id $($global:processList[$index])).ProcessName
                        Stop-Process -Id $($global:processList[$index]) -Force
                        #Stop-Process -Name $thisProcessName
                        #Start-Sleep -Seconds 1
                    }
                    $global:processList[$index] = "Stopped"
                }

                if ($global:processList[$index] -eq "Stopped") {
                    Write-Host "Ready To start New process in ID [$index]"
                }

                $index++
            }
            Start-Sleep -Seconds 1
        }
    }

}


###########################
######## START APP ########
###########################
Write-Host "Number of Logical Cores: [$maxProcesses]" -ForegroundColor Green
$aggreeMaxProcesses = Read-Host "Press enter or set a number of cores..."
if ($aggreeMaxProcesses -eq "") {
    # pass
} else {
    if ([int32]$aggreeMaxProcesses -is [int32] -and $aggreeMaxProcesses -ne 0) {
        $maxProcesses = $aggreeMaxProcesses
    } else {
        Write-Error "Required input is an [ Enter ] or number from 1-128 [$aggreeMaxProcesses]"
        Exit
    }
}
Write-Host "Start stress with [ $maxProcesses ] thread."
StartThreads -Loop