# msync

[CmdletBinding()]
param (
    [ValidateSet( "help", "sync", "verify", "diff", "makeSum")]
    [string] $Mode,
    #[Parameter(Mandatory=$true)]
    [string] $Path,
    #[Parameter(Mandatory=$true)]
    [string] $Destination,
    [switch] $SaveSumFile
)

if ($Mode -eq "help") {
    Write-Host "***** msync basics *****
    # msync modes: -Mode
        help
            ## Print this menu
        sync
            ## Default mode, copy files from PATH to DESTINATION.
            - When the source (PATH) and DESTINATION file are similar, program do nothing
            - When the source (PATH) and DESTINATION file are different, msync overwrite destination path 
            - TODO: No overwrite WHEN Destination is NEWER, and Add -Force option to overwrite 
        verify
            ## verify mode check differences between source (PATH) and checksum file elements.
            - Show different elements
        diff 
            ## diff show only differences between souurce (PATH) and DESTINATION
        makeSum
            ## Create checksum file with MD5 checksums and files
    " -ForegroundColor Green
    Exit 0
}
# Default Mode when not set
if (!$Mode) {$Mode = "sync"}
if ($Path -eq $Destination -and $Mode) { #  -and $Path -ne "" -and $Destination -ne "" 
    Write-Host "WARNING: Path and Destination are same => Switch to makeSum mode!" -ForegroundColor Yellow
    $Mode = "makeSum"
}


Write-Host "### MODE: [$Mode] # FROM: [$Path] # PathTo [$Destination] # SUM: [$SaveSumFile] ###" -ForegroundColor Cyan

##################
### COMPONENTS ###
##################

#$fileInfoArray
#$fileInfoArray | Format-Table

function sync {
    # In sync mode requires Destination source!
    param(
        [Parameter(Mandatory=$true)]
        [ValidateScript({Test-Path $_})]
        [string] $Destination
    )
    Write-Host "Call: sync()"

}

function verify {
    # In verify mode, requires only path! Destination will be Path too
    param (
        [Parameter(Mandatory=$true)]
        [string] $UseSumFile
    )    
}

function makeSum {
    $Destination = $Path
}

##################
###### CODE ######
##################
$fileInfoArray = @()

Get-ChildItem -Path $Path -Recurse | ForEach-Object {
    Write-Host "$Mode : $_" -ForegroundColor Green

    switch ($Mode) {
        sync     {sync}
        verify   {verify}
        diff     {diff}
        makeSum  {makeSum}

    }

    $fileInfo = [PSCustomObject]@{
        Name = $_.Name
        FullName = $_.FullName
        DirectoryName = $_.DirectoryName
        Size = $_.Length  #(Get-ChildItem .\msync.ps1 | measure Length -s).Sum # / 1Mb # Or / 1Gb
        LastWriteTime = $_.LastWriteTime    #(Get-ChildItem .\msync.ps1).LastWriteTime
        MD5Sum = (Get-FileHash -Path $_.FullName -Algorithm MD5).Hash
    }

    $fileInfoArray += $fileInfo
}