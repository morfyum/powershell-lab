$refreshInSeconds = 3

function PrintDone {
    Write-Host ""
    Write-Host "DDDDDDDD       OOOOOOOO    NNNN     NNN  EEEEEEEEEE" -ForegroundColor Green
    Write-Host "DDDDDDDDDD    OOO    OOO   NNNNN    NNN  EEEE" -ForegroundColor Green
    Write-Host "DDD     DDD  OOO      OOO  NNNNNN   NNN  EEEEEEEEEE" -ForegroundColor Green
    Write-Host "DDD     DDD  OOO      OOO  NNN NNNNNNNN  EEEEEEEEEE" -ForegroundColor Green
    Write-Host "DDDDDDDDDD    OOO    OOO   NNN   NNNNNN  EEEE" -ForegroundColor Green
    Write-Host "DDDDDDDD       OOOOOOOO    NNN     NNNN  EEEEEEEEEE" -ForegroundColor Green
    Write-Host ""
}

function SetCompactMode {
    $host.UI.RawUI.WindowSize = New-Object System.Management.Automation.Host.Size(60, 14)    
}

function ShowState {
    param (
        [Parameter(mandatory=$true)]
        [hashtable] $VolumeList
    )
    $unlockRequire = $false
    $greatestValue = 0

    foreach ($key in $VolumeList.Keys) {
        if ($VolumeList.$key -eq 0) {
            Write-Host "Unlocked:...........$key  $($VolumeList.$key)%" -ForegroundColor Green
        } else {
            $unlockRequire = $true
            $greatestValue = $($VolumeList.$key)
            Write-Host "Locked:.............$key  $($VolumeList.$key)%" -ForegroundColor Red
        }
    }
 
    if ($unlockRequire -eq $true) {
        $inpuValue = Read-Host "Do you want Unlock all drive? [y/N]"
        if ($inpuValue -eq "y") {
            Debitlocker
            while ($greatestValue -gt 0) {
                Clear-Host
                $VolumeList = GetBitlockerStatus
                foreach ($key in $VolumeList.Keys) {
                    if ($VolumeList.$key -eq 0) {
                        #$unlockRequire = $false
                        $greatestValue = $($VolumeList.$key)
                        Write-Host "Unlocked:...........$key  $($VolumeList.$key)%" -ForegroundColor Green
                    } else {
                        #$unlockRequire = $true
                        if ($($VolumeList.$key) -gt $greatestValue) {
                            $greatestValue = $($VolumeList.$key)
                        }
                        Write-Host "In progress:........$key  $($VolumeList.$key)%" -ForegroundColor Red
                    }
                }
                Start-Sleep -Seconds $refreshInSeconds
            }
            PrintDone
        } else {
            Write-Host "Skip"
        }
    }
}

function GetBitlockerStatus {
    $volumeTable = @{}
    Get-BitLockerVolume | ForEach-Object {
        $volumeTable.Add($_.MountPoint, $_.EncryptionPercentage)
    }
    return $volumeTable
}

function Debitlocker {
    Write-Host "Unlock in progress..." -ForegroundColor Cyan
    (Get-BitLockerVolume).MountPoint | ForEach-Object { 
        Write-Host "Unlocking:... $_"
        manage-bde.exe -autounlock -ClearAllKeys $_
        manage-bde.exe -off $_
    }
}