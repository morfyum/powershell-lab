# msync.ps1 2025-09-24
function Show-LoadingAnimation {
    param (
        [string]$Message = "Loading"
    )
    
    #$chars = @("|", "/", "-", "\")
    $chars = @(".  ", ":  ", ":. ", ":: ", "::.", ":::", "::.", ":: ", ":. ", ":  ", ".  ", "   ")
    $i = 0

    $process = Start-Job -ScriptBlock {
        Start-Sleep -Seconds (Get-Random -Minimum 3 -Maximum 6)
    }

    while ($process.State -eq 'Running') {
        Write-Host "$Message $($chars[$i])" -NoNewline
        Start-Sleep -Milliseconds 200
        Write-Host "`r" -NoNewline
        $i = ($i + 1) % $chars.Count
    }
    
    Write-Host "`r$($Message) Complete!      " -ForegroundColor Green
    Remove-Job -Job $process
}

function msync {
    Param(
        [string] $Source,
        [string] $Destination,
        [switch] $Verify,
        [switch] $Force
    )
    #Write-Host "Sync from   : $Source" -ForegroundColor Cyan
    #Write-Host "Destination : $Destination" -ForegroundColor Cyan
    Write-Host "Gathering informations..."
    $sourceList = (Get-ChildItem -Recurse $Source)
    $destinationList = (Get-ChildItem -Recurse $Destination)

    $sourceList | Foreach-Object {
        Write-Host "Sync [$($_.FullName)] to [$Destination/$($_.Name)]" -ForegroundColor Cyan

        if ((Test-Path -Path "$Destination/$($_.Name)") -eq $false ) {
            if ($Verify) {
                Write-Host "  Verify: Missing file $Destination/$($_.Name)" -ForegroundColor Red
            } else {
                Show-LoadingAnimation -Message "Sync"
            }
        } else {
            $sourceFileHash = (Get-FileHash -Algorithm MD5 $_.FullName).Hash
            $destinationFileHash = (Get-FileHash -Algorithm MD5 "$Destination/$($_.Name)").Hash
            if ($sourceFileHash -eq $destinationFileHash) {
                Write-Host "  OK: Source and Destination are the same" -ForegroundColor Green
            } else {

                if ($Force -or $Verify) {
                    $userInput = "Y"
                    if ($Verify) {
                        $userInput = "Verify"
                    }
                } else {
                    $userInput = Read-Host "  Do you want to override Destination file? [y/N]"
                } 
                if ($Verify) {
                    $userInput = "Verify"
                }
                
                "  Source      : $sourceFileHash - Modified: $($_.LastWriteTime) - Size: $($_.Length) byte"
                $destinationFile = (Get-Item -Path "$Destination/$($_.Name)")
                "  Destination : $destinationFileHash - Modified: $($destinationFile.LastWriteTime) - Size: Unknown" # doesnt work: $($destinationFile.Length)
                                    
                if ($userInput -eq "") {
                    $userInput = "N"
                    Write-Host "- AutoSkip"
                } elseif ($userInput -eq "N" ) {
                    Write-Host "- Skip"
                } elseif ($userInput -eq "Y") {
                    Show-LoadingAnimation -Message "Overwrite"
                } elseif ($userInput -eq "Verify") {
                    Write-Host "  Verify: Files are different" -ForegroundColor Yellow
                }
            }
        }

    }

}


msync -Source "./tests/source-dir" -Destination "./tests/dest-dir" -Force