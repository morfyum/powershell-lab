################################################################################ #######################################
# Wifi speed test Proof of Concept v0.1
# TODO: Get random file from $source instead of specific file!
# WARN: Maybe do not create hash-check when use Random file becasue can overload remote source!
################################################################################ #######################################

$filename = "asd.mp4"
$source = "C:\Users\mars\Desktop\$filename"
$source_hash = "CAB08B36195EDB1A1231D2D09FA450E0"

$destination = "C:\Users\mars\Downloads\"
$destination_hash = "Not yet"

Write-Host "Copy from: [ $source ]" -ForegroundColor DarkGray
Write-Host "Hash:      [ $source_hash ]" -ForegroundColor DarkGray
Write-Host "Copy to:   [ $destination ]" -ForegroundColor DarkGray


function Copy-WithExplorerUI([string]$source, [string]$destination) {

    $objShell = New-Object -ComObject "Shell.Application"
    $objFolder = $objShell.NameSpace($destination) 
    # $objFolder.CopyHere($source, 16) #16 : Yes to all
    $objFolder.CopyHere($source)
}

# date replaced with Get-Date => Replace with (Get-Date).Date ? 
$time_start = (Get-Date).DateTime
Copy-WithExplorerUI $source $destination
$time_end = (Get-Date).DateTime

if ($? -eq $true ){
    Write-Host "✅ Copy done. -> Check hash..." -ForegroundColor Green
    $destination_hash = (Get-FileHash -Algorithm md5 $destination\$filename).Hash 
    Write-Host "Hash:      [ $destination_hash ] ✒️" -ForegroundColor DarkGray
    if ($source_hash -ne $destination_hash) {
        Write-Host "🔥 Different hashes, Corrupted copy!" -ForegroundColor Red
    } else {
        Write-Host "✅ PASS Hashes match!" -ForegroundColor Green
    }
} else {
    Write-Host "🔥 Copy interrupted and failed!" -ForegroundColor Red
}

$time_in_seconds = (NEW-TIMESPAN -Start $time_start –End $time_end).TotalSeconds

Write-Host "⏱️ Copy time [ $time_in_seconds ] seconds" -ForegroundColor DarkGray

$file_size = (Get-Item -Path $destination\$filename).Length/1MB

[int]$megabyte_per_sec = $file_size/$time_in_seconds 
$megabit_per_sec = $megabyte_per_sec/8

Write-Host "📈 Average MB/s: $megabyte_per_sec" -ForegroundColor Cyan
Write-Host "📈 Average mbps: $megabit_per_sec" -ForegroundColor Cyan

# todo
function Test-WindowsTerminal { test-path env:WT_SESSION }

pause