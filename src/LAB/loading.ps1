# loading Prompt

function Run-AsAdmin {
    if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
        Start-Process -FilePath "PowerShell.exe" -ArgumentList "-NoProfile -ExecutionPolicy Unrestricted -File `"$PSCommandPath`"" -Verb RunAs
        exit
    }
}

function loadingProcess {
    param (
        [string] $ProcessPath,
        [string] $messageLoading,
        [string] $messageFinish,
        [string] $messageFailed = "Failed"
    )
    #$spinner = @('-','\','|','/')
    $spinner = @('[.  ]','[:  ]','[:. ]','[:: ]','[::.]','[:::]','[::.]','[:: ]','[:. ]','[:  ]','[.  ]','[   ]')
    Write-Host "$messageLoading" -NoNewline -ForegroundColor Cyan
    
    $job = Start-Job -ScriptBlock {
        param ($processPath)
        if (Test-Path $processPath) {
            #Start-Process $processPath -Wait
            #Start-Process -FilePath "PowerShell.exe" -ArgumentList "-NoProfile -ExecutionPolicy Unrestricted -Command `"$processPath`"" -Wait
            Start-Process -FilePath "PowerShell.exe" ` -ArgumentList "-NoProfile -ExecutionPolicy Unrestricted -Command `"$processPath`"" ` -Verb RunAs -Wait
        } else {
            Throw "Process file not found: [$processPath]"
        }
    } -ArgumentList $ProcessPath

    while ($job.State -eq 'Running') {
        Write-Host "`r$messageLoading $($spinner[$counter % $spinner.Length])" -NoNewline -ForegroundColor Cyan
        $counter++
        Start-Sleep -Milliseconds 200
    }

    if ($job.State -eq 'Completed') {
        Write-Host "`r$messageFinish                " -ForegroundColor Green
    } elseif ($job.State -eq 'Failed') {
        Write-Host "`r$messageFailed                " -ForegroundColor Red
        Receive-Job -Job $job  # Show error output
    } else {
        Write-Host "`rProcess was stopped or encountered an issue.           " -ForegroundColor Yellow
    }

    Remove-Job -Job $job -Force
}

loadingProcess -ProcessPath "C:\windows\SYSTEM32\cleanmgr.exe" -messageLoading "Loading..." -messageFinish "Finished"
loadingProcess -ProcessPath "C:\Users\mars\Desktop\Get-BitLockerVolume.ps1" -messageLoading "Loading..." -messageFinish "Finished"
loadingProcess -ProcessPath "C:\Users\mars\Desktop\not-found-this.file" -messageLoading "Loading..." -messageFinish "Finished"