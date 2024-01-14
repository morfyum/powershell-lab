# msync.ps1 # DEV: morfyum # github.com/morfyum
[CmdletBinding()]
param (
    [ValidateSet( "help", "sync", "verify", "diff", "makeSum")]
    [string] $Mode,
    [Parameter(Mandatory=$true)]
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

            ## EXAMPLE
            
                msync.ps1 -Mode sync -Path ./ -Destination ./other/folder/

        verify
            ## verify mode check differences between source (PATH) and checksum file elements.
            - Show different elements

            ## EXAMPLE

            msync.ps1 -Mode verify -Path ./folder/ ???
            VAGY
            msync.ps1 -Mode verify -Source ./folder/summary.csv -Destination ./folder/

        diff 
            ## Show only differences between source (PATH) and DESTINATION

            msync.ps1 -Mode diff -Source ./original/ -Destination ./other/folder/

        makeSum
            ## Create checksum file with MD5 checksums and files to
    " -ForegroundColor Green
    Exit 0
}

# Default Mode when not set
if (!$Mode -and $Destination -ne "") {$Mode = "sync"}
if (!$Mode -and $Destination -eq "") {$Mode = "makeSum"}
if ($Path -eq $Destination) { #  -and $Path -ne "" -and $Destination -ne "" 
    Write-Host "WARNING: Path and Destination are same => Switch to makeSum mode!" -ForegroundColor Yellow
    $Mode = "makeSum"
}

Write-Host "### MODE: [$Mode] # PATH: [$Path] # Destination [$Destination] # SUM: [$SaveSumFile] ###" -ForegroundColor Cyan

##############################
###       COMPONENTS       ###
##############################
#$fileInfoArray
#$fileInfoArray | Format-Table

function GetCurrentDate {
    $CurrentDate = Get-Date -Format "yyyyMMdd-HHmm"
    Return $CurrentDate
}

function sync {
    # In sync mode requires Destination source!
    param(
        #[Parameter(Mandatory=$true)]
        #[string] $Destination
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
    param (
        [string] $Source = $Path,
        [string] $OutFile = "summary.csv",
        [switch] $Force     # TODO: Replace Y/n question to auto-exit when -Force not $true ?
    )
    <#
    foreach ($element in $fileInfoArray) {
        Write-Host " - ",$element.MD5Sum, "|", $element.LastWriteTime "|", $element.FullName
    }#>

    if ( (Test-Path "$Path/summary.csv") -eq $true) {
        $Input = Read-Host "WARNING: summary.csv exist, do you want to Overwrie? [Y/n]"
        if ($Input.ToLower() -eq "y") {

            $selectedPropertiesArray = $fileInfoArray | ForEach-Object {
                if ($_.Name -ne $OutFile) {
                    [PSCustomObject]@{
                        MD5Sum = $_.MD5Sum
                        FileName = $_.FullName
                        LastWriteTime = $_.LastWriteTime
                    }
                }
            }
            #$selectedPropertiesArray | Export-Csv -Path "$Path/summary-$(GetCurrentDate).csv" -NoTypeInformation
            $selectedPropertiesArray | Export-Csv -Path "$Path/summary.csv" -NoTypeInformation

        } else {
            Write-Host "Abort. Exit"
            Exit 0
        }
    }
}

##############################
###          CODE          ###
##############################
$fileInfoArray = @()

Get-ChildItem -Path $Path -Recurse | ForEach-Object {

    $fileInfo = [PSCustomObject]@{
        Name = $_.Name
        FullName = $_.FullName
        DirectoryName = $_.DirectoryName
        Size = $_.Length  #(Get-ChildItem .\msync.ps1 | measure Length -s).Sum # / 1Mb # Or / 1Gb
        LastWriteTime = $_.LastWriteTime    #(Get-ChildItem .\msync.ps1).LastWriteTime
        MD5Sum = (Get-FileHash -Path $_.FullName -Algorithm MD5).Hash
    }

    # Mode prompt config
    switch ($Mode) {
        sync     {}
        verify   {}
        diff     {}
        makeSum  {
            $ModeParameters = "$($fileInfo.MD5Sum) $($fileInfo.LastWriteTime)"
        }
    }

    $cmdLetString = "$Mode : $ModeParameters $_"
    Write-Host $cmdLetString -ForegroundColor Green


    $fileInfoArray += $fileInfo

}


switch ($Mode) {
    sync     {sync}
    verify   {verify}
    diff     {diff}
    makeSum  {
        Write-Host "- Call: makeSum"
        $(makeSum -Force)
    }
}