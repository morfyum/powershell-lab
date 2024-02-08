﻿# IMPORT MODULES / COMPONENTS
. .\UI.ps1
. .\core-utils.ps1

# SELF CONFIGURATION AND VARIABLES 
$selfLocation = (Get-Location).Path
$selfConfig = Get-Content -Path "$selfLocation\shell-config.json" | Out-String | ConvertFrom-Json
$selfWidth = $host.UI.RawUI.WindowSize.Width
$selfHeight = $host.UI.RawUI.WindowSize.Height
$host.UI.RawUI.WindowTitle = "$($selfConfig.appName)"
$host.UI.RawUI.foregroundColor = $($selfConfig.fontColor)
$currentDate = Get-Date -Format "yyyy-MM-dd"
$lastCommand = ""
$width = 100  #100

$menuLength = $($selfConfig.menu).Length


# EXTERNAL
$biosVersion = (Get-WmiObject win32_bios).Version
$biosVersionValue = $biosVersion -replace '\D', ''

$windowsProduct = (Get-WmiObject -class Win32_OperatingSystem).Caption
$windowsBuildNumber = (Get-WmiObject -class Win32_OperatingSystem).BuildNumber

#$IPv4Address = (Get-NetIPConfiguration).IPv4Address.IPAddress
#$ethernetMacAddress = (Get-NetAdapter -Name "Ethernet").MacAddress

function selfDebug {
    # pass
}
#<#
function Show-Menu {
    #Clear-Host # REPLACED for improve performance! + ~0.02-0,06 ms
    [Console]::Clear()
    generateRow -Width $width -StartChar $headerStart$FillChar -EndChar $headerEnd -FillChar $fillChar
    generateRow -Width $width -StartChar $pipeChar -EndChar $pipeChar -FillChar " " -Content "Q  : Quit | $lastCommand" -Padding
    generateRow -Width $width -StartChar $footerStart -EndChar $footerEnd -FillChar $fillChar
    
    Write-Output "Menu length: [ $menuLength ]"
    $menuIndex = 0
    $maxNameLength = 24
    $contentFiller = " "
    $contentArray = @()

    generateRow -Width $width -StartChar $headerStart$FillChar -EndChar $headerEnd -FillChar $fillChar

    <# 0 1 2
       3 4 5
    $counter = 0
    $selfConfig.menu | ForEach-Object {
        $columns = 3
        $roundedWidth = [Math]::Ceiling($width / $columns)
        $maxRow = [int]$menuLength/$columns
        $counter++

        $worker += generateRow -Width  $roundedWidth -StartChar "" -Content "$menuIndex : $($_.name) - [$counter] MAXROW: $([int]$maxRow)" -EndChar "|" -Padding
        if ($counter%$columns -eq 0) {
            #echo "% : $($counter%$columns)"
            $Content = generateRow -Width $width -StartChar "|" -Content $worker -EndChar "|"
            $Content
            $worker = ""
        }
        $menuIndex++        
    }
    $Content = generateRow -Width $width -StartChar "|" -Content $worker -EndChar "|"
    $Content
    #>


    $counter = 0
    $selfConfig.menu | ForEach-Object {
        $columns = 3
        $roundedWidth = [Math]::Ceiling($width / $columns)
        $maxRow = [int]$menuLength/$columns
        $counter++

        $worker += generateRow -Width  $roundedWidth -StartChar "" -Content "$menuIndex : $($_.name) - [$counter] MAXROW: $([int]$maxRow)" -EndChar "|" -Padding
        if ($counter%$columns -eq 0) {
            #echo "% : $($counter%$columns)"
            $Content = generateRow -Width $width -StartChar "|" -Content $worker -EndChar "|"
            $Content
            $worker = ""
            $counter = 0
        }
        $menuIndex++        
    }
    $Content = generateRow -Width $width -StartChar "|" -Content $worker -EndChar "|"
    $Content

    generateRow -Width $width -StartChar $footerStart -EndChar $footerEnd -FillChar $fillChar
    

    generateRow -Width $width -StartChar $headerStart$FillChar -EndChar $headerEnd -FillChar $fillChar -Content $selfConfig.appName -Padding
    generateRow -Width $width -StartChar $pipeChar -EndChar $pipeChar -FillChar " " -Content "0  : Analyze-system-health   | 10  : Windows 10 Activator      | 20  :                           " -Padding
    generateRow -Width $width -StartChar $pipeChar -EndChar $pipeChar -FillChar " " -Content "1  : -                       | 11  : Windows 11 Activator      | 21  :                           " -Padding
    generateRow -Width $width -StartChar $pipeChar -EndChar $pipeChar -FillChar " " -Content "2  : -                       | 12  : -                         | 22  :                           " -Padding
    generateRow -Width $width -StartChar $pipeChar -EndChar $pipeChar -FillChar " " -Content "3  : -                       | 13  : -                         | 23  :                           " -Padding
    generateRow -Width $width -StartChar $pipeChar -EndChar $pipeChar -FillChar " " -Content "4  : Policy status           | 14  : -                         | 24  :                           " -Padding
    generateRow -Width $width -StartChar $pipeChar -EndChar $pipeChar -FillChar " " -Content "5  : -                       | 15  : -                         | 25  :                           " -Padding
    generateRow -Width $width -StartChar $pipeChar -EndChar $pipeChar -FillChar " " -Content "6  : -                       | 16  : -                         | 26  :                           " -Padding
    #Write-Host "----------------------------------------------------------------------------------------------------"
    generateRow -Width $width -StartChar $pipeChar -EndChar $pipeChar -FillChar " " -Content "7  : -                       | 17  : -                         | 27  : 12345123451234512345-012356789dddd" -Padding
    generateRow -Width $width -StartChar $pipeChar -EndChar $pipeChar -FillChar " " -Content "8  : Admin-Test              | 18  : -                         | 28  : Wifi-speed-test           " -Padding
    generateRow -Width $width -StartChar $pipeChar -EndChar $pipeChar -FillChar " " -Content "9  : Check-Bitlocker-Status  | 19  : -                         | 29  : PCI-Express-powersaving  dddd" -Padding
    generateRow -Width $width -StartChar $footerStart -EndChar $footerEnd -FillChar $fillChar

    generateRow -Width $width -StartChar $headerStart$FillChar -EndChar $headerEnd -FillChar $fillChar
    #generateRow -Width $width -StartChar $pipeChar -EndChar $pipeChar -FillChar " " -Content "[ $(Get-ExecutionPolicy) ][ 💻$(getSerialNumber) ] [$biosVersion]                                  [🛜$(getWifiPercentage)][🔋$(getBatteryPercentage)][ $($currentDate) ]"
    #generateRow -Width $width -StartChar $pipeChar -EndChar $pipeChar -FillChar " " -Content "[ $selfWidth x $selfHeight ] [$(getGPUs)]"
    generateRow -Width $width -StartChar $footerStart -EndChar $footerEnd -FillChar $fillChar
    #generateRow -EndChar " " -Content "Performance: $performanceResult1 ms | $performanceResult2 ms"
}#>


<#function Show-Menu {
    Clear-Host
"┌ $($selfConfig.appName) ─────────────────────────────────────────────────────────────────────────────────┐"
Write-Host "  Q  : Quit | $lastCommand" -ForegroundColor DarkGreen
"└──────────────────────────────────────────────────────────────────────────────────────────────────┘
| 0  : Analyze-system-health   | 10  : Windows 10 Activator      | 20  :                           |
| 1  : -                       | 11  : Windows 11 Activator      | 21  :                           |
| 2  : -                       | 12  : -                         | 22  :                           |
| 3  : -                       | 13  : -                         | 23  :                           |
| 4  : Policy status           | 14  : -                         | 24  :                           |
| 5  :                         | 15  : -                         | 25  :                           |
| 6  :                         | 16  : -                         | 26  :                           |
| 7  :                         | 17  : -                         | 27  :                           |
| 8  : Admin-Test              | 18  : -                         | 28  : Wifi-speed-test           |
| 9  : Check-Bitlocker-Status  | 19  : -                         | 29  : PCI-Express-powersaving   |"
"----------------------------------------------------------------------------------------------------"
"[ $($currentDate) ][ $(Get-ExecutionPolicy) ][ 🔋$(getBatteryPercentage) ][ 💻$(getSerialNumber) ] [ $biosVersion ] [ 🛜$(getWifiPercentage) ]"
"[ $selfWidth x $selfHeight ] [$(getGPUs)]"
#selfDebug
"----------------------------------------------------------------------------------------------------"
}#>

<#
function Show-Menu {
    Clear-Host
    Write-Host "┌──────────────────────────────────────────────────────────────────────────────────────────────────┐"
    Write-Host "  Q  : Quit | $lastCommand" -ForegroundColor DarkGreen
    Write-Host "└──────────────────────────────────────────────────────────────────────────────────────────────────┘"
    Write-Host "| 0  : Analyze-system-health   | 10  : Windows 10 Activator      | 20  :                           |"
    Write-Host "| 1  : -                       | 11  : Windows 11 Activator      | 21  :                           |"
    Write-Host "| 2  : -                       | 12  : -                         | 22  :                           |"
    Write-Host "| 3  : -                       | 13  : -                         | 23  :                           |"
    Write-Host "| 4  : Policy status           | 14  : -                         | 24  :                           |"
    Write-Host "| 5  :                         | 15  : -                         | 25  :                           |"
    Write-Host "| 6  :                         | 16  : -                         | 26  :                           |"
    Write-Host "| 7  : Wifi-speed-test         | 17  : -                         | 27  :                           |"
    Write-Host "| 8  : Admin-Test              | 18  : -                         | 28  :                           |"
    Write-Host "| 9  : Check-Bitlocker-Status  | 19  : -                         | 29  :                           |"
    Write-Host "----------------------------------------------------------------------------------------------------"
    Write-Host "[ $($selfConfig.appName) v$($selfConfig.appVersion) ][ $($currentDate) ][ $(Get-ExecutionPolicy) ] []"
    Write-Host "[ $selfWidth x $selfHeight ]"
    Write-Host "Performance: $performanceResult1 | $performanceResult2"
    #selfDebug
    Write-Host "----------------------------------------------------------------------------------------------------"
}#>

function showHelp {
"********************************************************************************
Help : helpp
    SYNPOS: Show This menu

Quit : Q, q, 00
    SYNPOS: Close Application  
*********************************************************************************
"
Pause
}

function isWTSession {
    if ($env:WT_SESSION) {
        return $true
    } else {
        return $false
    }
}

function getGPUs {
    $gpus = @()
    ((Get-WmiObject Win32_VideoController).Name) | ForEach-Object {
        if ($_ -eq "Microsoft Basic Display Adapter") {
            #Write-Host "MISSING DRIVER: $_" -ForegroundColor Red
            $gpus += $_
        }
        if ($_ -eq "Red Hat QXL controller") {
            #Write-Host "VM: $_" -ForegroundColor Green
            $gpus += "VM: $_"
        }
        else {
            #Write-Host "OK: $_" -ForegroundColor Green
            $gpus += "OK: $_"
        }
    }
    return $gpus
}

function getSerialNumber {
    $serialNumber = (Get-WmiObject win32_bios).SerialNumber
    if ($serialNumber -eq $null) {
        $serialNumber = "VM"
    }
    return $serialNumber
}

function getWifiPercentage {
    # TODO - > netsh slow => Performance-test for Get-NetAdapter -Name "Wi-Fi"
    $wifiPercentage = (netsh wlan show interfaces) -Match '^\s+Signal' -Replace '^\s+Signal\s+:\s+',''
    if ($wifiPercentage -eq $false) {
        $wifiPercentage = "N/A"
    }
    $wifiPercentage = "$wifiPercentage"
    return $wifiPercentage
}

function getBatteryPercentage {
    $batteryPercentage = (Get-WmiObject -Class win32_Battery).estimatedChargeRemaining
    if ($batteryPercentage -eq $null) {
        $batteryPercentage = "N/A"
    } else {
        $batteryPercentage = "$batteryPercentage%"
    }
    return $batteryPercentage
}

function SetCurrentUserExecutionPolicy {
    param (
        [Parameter(mandatory=$true)]
        [string] $ExecutionPolicy
    )
    Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy $ExecutionPolicy
    return Get-ExecutionPolicy
}

$performanceResult1 = (Measure-Command {Show-Menu}).Milliseconds

do {
    $performanceResult2 = (Measure-Command {Show-Menu}).Milliseconds
    Show-Menu
    $shellInput = Read-Host "Input"
    while ($shellInput -eq "") {
        Show-Menu
        $shellInput = Read-Host "Input"
    }
    $lastCommand = $shellInput
    switch ($shellInput) {
        0  {$lastCommand = $lastCommand+': 🔥 TODO -> Not implemented'}
        1  {$lastCommand = $lastCommand+': TEST '}
        2  {$lastCommand = $lastCommand+": You chose option #2"}
        3  {$lastCommand = $lastCommand+': You chose option #3'}
        4  {$lastCommand = $lastCommand+": Policy status: [$(Get-ExecutionPolicy)]"}
        5  {$lastCommand = $lastCommand+": - "}
        6  {$lastCommand = $lastCommand+": - "}
        7  {$lastCommand = $lastCommand+": 🔥 TODO -> Not implemented"}
        8  {$lastCommand = $lastCommand+': Check-Bitlocker-Status'; windowsAdminRequest -RequestFor "C:\Users\mars\Desktop\git\powershell-lab\src\LAB\todo-elevate_ps1-and-wurcraft\tests\test_no_root_external_powershell.ps1" }
        9  {$lastCommand = $lastCommand+': Check-Bitlocker-Status'; windowsAdminRequest -RequestFor "$selfLocation\extensions\get-bitlocker-status\get-bitlocker-status.ps1" }
        10 {$lastCommand = $lastCommand+': 🔥 TODO -> Not implemented'}
        11 {$lastCommand = $lastCommand+': 🔥 TODO -> Not implemented'}
        '00' { Write-Host "Exit, Goodbye"; Exit 0}
        'help' {$lastCommand = $lastCommand+': Help'; showHelp }
    }
} until ($shellInput -eq 'q')
Write-Host "Exit, Goodbye! "