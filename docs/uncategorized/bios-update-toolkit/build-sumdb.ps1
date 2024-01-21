# TEST VARIABLE
#$test_BIOS_file_path = "..\..\..\..\..\..\Downloads\"
# REQUIRED VARIABLES
$csvPath = ".\csv_example.csv"
$BIOSDriveIP = "333.0.0.1" # FOR FAIL TEST: 3333.3333.3333
$csvData = Import-Csv -Path $csvPath -Delimiter ";" -Header "Index", "SSID", "BIOSVersion", "FilePath", "UserID", "LastUpdate", "Description"
$summaryDatabase = @()
$tooMuchFile = @()
$exePattern ="*.exe"
$MD5Pattern = '^[0-9A-Fa-f]{32}$'

class summaryDatabaseStructure {
    [string] $SSID 
    [string] $FilePath
    [string] $MD5Sum
}

function TestPathErrorHandler {
    param (
        [Parameter(mandatory=$true)]
        [string] $Path,
        [switch] $ShowSuccess
    )
    
    if ((Test-Path $Path) -eq $true) {
        if ($ShowSuccess -eq $true) {
            Write-Host "[ OK ] Test Path [$Path]" -ForegroundColor Green
        }
    } else {
        Write-Host "Test Path: ERROR [$Path] does not exists => Exit 1" -ForegroundColor Red
        #Exit
    }     
}

function CheckConnection {
    param (
        [Parameter(mandatory=$true)]
        [string] $IPAddress
    )
    Test-Connection -IPAddress $IPAddress -Count 2 -ErrorAction SilentlyContinue | Out-Null
    if ($? -eq $false) {
        Write-Host "ERROR: No connection to BIOS drive: [$IPAddress] => Exit" -ForegroundColor Red
        Exit
    }
    Write-Host "[ OK ] Check Connection" -ForegroundColor Green
}

function MountBIOSDrive {
    Write-Host "Mount BIOS drive..." -ForegroundColor Green
}

CheckConnection -IPAddress $BIOSDriveIP
MountBIOSDrive
TestPathErrorHandler $csvPath

$csvData | ForEach-Object {
    $CurrentRow = [summaryDatabaseStructure]::new()
    Write-Host "SSID: [$($_.SSID)] | Path: [$($_.FilePath)]" -ForegroundColor Green
    # WHEN REQUIRED WE CAN SKIP NON 1AB2 matched SSID-s
    <#if ($_.SSID -match '^[0-9A-Fa-f]{4}$') { 
    } else {
        Write-Host "Skip: $($_.SSID) - Invalid SSID"
    }#>
    $CurrentRow.SSID = $_.SSID
    $CurrentRow.FilePath = $_.FilePath
    $fullPath = "$($_.FilePath)\$exePattern"
    TestPathErrorHandler -Path $fullPath -ShowSuccess
    Write-Host "- Calculate MD5Sum... [$fullPath]"
    #Start-Sleep -Seconds 2  # Sleep when reqiored delay
    #$dummyfullPath = "$test_BIOS_file_path\$exePattern"
    #$CurrentRow.MD5Sum = (Get-FileHash -Algorithm MD5 -Path $dummyfullPath).Hash # (Get-FileHash -Algorithm MD5 -Path $($_.FilePath)\*.exe).Hash
    $CurrentRow.MD5Sum = (Get-FileHash -Algorithm MD5 -Path $fullPath).Hash
    # Check created MD5Sum is only one 
    if ($CurrentRow.MD5Sum -match $MD5Pattern) {
        Write-Host "  $($CurrentRow.MD5Sum)"
    } else {
        Write-Host "  Too much or less file: $($CurrentRow.MD5Sum)"
        $tooMuchFile += $_.FilePath
    }   
    $summaryDatabase += $CurrentRow
}

#Write-Host "---------------"
#Write-Host "Show Collection" -ForegroundColor Cyan
#$summaryDatabase

Write-Host "---------------"
Write-Host "Problems on following paths:" -ForegroundColor Cyan
$tooMuchFile

Write-Host "---------------"
Write-Host "Export summaryDatabase..." -ForegroundColor Green
$summaryDatabase | Export-Csv -Path summaryDatabase.csv -Delimiter ";"