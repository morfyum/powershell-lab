$fillChar = [char]9472      # ─
$headerStart = [char]0x250C   # ┌
$headerEnd = [char]0x2510   # ┐
$pipeChar = [char]0x2502    # │
#$pipeChar = "|"    # |
$footerStart = [char]0x2514 # └
$footerEnd = [char]0x2518   # ┘

function Get-ShortenedString {
    param (
        [string]$InputString,
        [int]$MaxLength
    )

    if ($InputString.Length -gt $MaxLength) {
        return $InputString.Substring(0, $MaxLength)
    } else {
        return $InputString
    }
}

function generateRow {
    param (
        [int] $Width,
        [string] $StartChar = "",
        [string] $EndChar = "",
        [string] $FillChar = " ",
        [string] $Index,
        [string] $Content,
        [switch] $Padding
    )

    if ($Index.Length -lt 2 -and $Index.Length -ne 0) {
        $Index = "$index "
    }
    $Content = $Index+$Content

    if ($Padding -eq $true) {
        $Content = " $Content "
    }

    #if ($Content.Length -gt $Width+)

    if ($Content.Length -gt $Width-($StartChar.Length+$EndChar.Length)) {
        #Write-Host "CUT: " ($Width-(2*($StartChar.Length+$EndChar.Length))) 
        $Content = Get-ShortenedString -InputString $Content -MaxLength ($Width-(2*($StartChar.Length+$EndChar.Length)))
    }

    #$contentWidth = [int]$Content.Length
    #Write-Host "CONTENT-W:      $($contentWidth) + $($startChar.Length) + $($EndChar.Length) (start/end-chars)"
    #$fillRequired = [int]$Width - ($contentWidth+$($startChar.Length)+$($EndChar.Length))
    #Write-Host "FILL REQUIRED:  $fillRequired"
    #$summary = $fillRequired + $contentWidth
    #Write-Host "SUM:            $summary"


    $fillNeedValue = $Width-($StartChar.Length+$Content.Length+$EndChar.Length)
    #$cutContentValue = $Width
    
    

    <#
    if ($Content.Length -gt $fillNeedValue) {
        #Write-Output "W: $($Content.Length)"
        $threeDot = "..."
        $cutStringValue = ($Content.Length - ($fillNeedValue))
        $Content = Get-ShortenedString -InputString $Content -MaxLength $cutStringValue
        #$Content = $Content.Substring(0, $Content.Length - $cutStringLength ) + "..."
    }#>

    $startCount = 0
    for ($counter = $startCount; $counter -lt ($fillNeedValue); $counter += 1) {
        $filler = $filler+$FillChar
    }
    $row = $StartChar+$Content+$filler+$EndChar
    return $row
}

function generateContent {
    param (
        [string] $Width = $maxNameLength,
        [string] $StartChar = "|",
        [string] $EndChar = "|",
        [string] $FillChar = "_",
        [string] $Index,
        [string] $Content,
        [switch] $Padding
    )

    if ($Index -lt 10 ) {$Index+=" "}

    $Content = $Index,$Content

    if ($Padding -eq $true) {
        $Content = " $Content "
    }

    $fillNeedValue = $Width-($($Content.Length)+$StartChar.Length+$EndChar.Length)
    $startCount = 0
    #Write-Host "- $($Content.Length) + $fillNeedValue = $($Content.Length+$fillNeedValue)"
    if ($Content.Length -gt $Width) {
        $cutStringLength = ($Content.Length - $Width) + 4
        $Content = $Content.Substring(0, $Content.Length - $cutStringLength ) + "..."
    }

    for ($counter = $startCount; $counter -le $fillNeedValue; $counter += 1) {
        $filler = $filler+$FillChar
    }

    #$content = $StartChar+$Index+$Content+$filler+$EndChar
    $content = $StartChar+$Content+$filler+$EndChar
    return $content
}

function Show-OldMenu {
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
