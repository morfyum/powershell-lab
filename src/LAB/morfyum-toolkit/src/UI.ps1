$fillChar = [char]9472      # ─
$headerStart = [char]0x250C   # ┌
$headerEnd = [char]0x2510   # ┐
$pipeChar = [char]0x2502    # │
#$pipeChar = "|"    # │
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
        [string] $Content,
        [switch] $Padding
    )

    if ($Padding -eq $true) {
        $Content = " $Content "
    }

    #if ($Content.Length -gt $Width+)

    if ($Content.Length -gt $Width-($StartChar.Length+$EndChar.Length)) {
        #Write-Host "CUT: " ($Width-(2*($StartChar.Length+$EndChar.Length))) 
        $Content = Get-ShortenedString -InputString $Content -MaxLength ($Width-(2*($StartChar.Length+$EndChar.Length)))
    }

    $contentWidth = [int]$Content.Length
    #Write-Host "CONTENT-W:      $($contentWidth) + $($startChar.Length) + $($EndChar.Length) (start/end-chars)"
    $fillRequired = [int]$Width - ($contentWidth+$($startChar.Length)+$($EndChar.Length))
    #Write-Host "FILL REQUIRED:  $fillRequired"
    $summary = $fillRequired + $contentWidth
    #Write-Host "SUM:            $summary"


    $fillNeedValue = $Width-($StartChar.Length+$Content.Length+$EndChar.Length)
    $cutContentValue = $Width
    
    

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

function lengthTest {
    param (
        [string] $String,
        [int] $ExceptedValue
    )
    if ($String.Length -eq $ExceptedValue ) { Write-Host "PASS.......... $ExceptedValue" -ForegroundColor Green } 
    else { Write-Host "FAIL.......... $($String.Length) Not equal $ExceptedValue" -ForegroundColor Red}
}

#<#
$isTen = Get-ShortenedString -InputString "0123456789aaaaa" -MaxLength 10
$isFive = Get-ShortenedString -InputString "0123456789aaaaa" -MaxLength 5
$isTwelve = Get-ShortenedString -InputString "0123456789123333" -MaxLength 12
lengthTest $isTen 10
lengthTest $isFive 5
lengthTest $isTwelve 12
#>

#(generateRow -Width 100 -StartChar $headerStart$FillChar -EndChar $headerEnd -FillChar $fillChar -Content "MARCI VAGYOK" -Padding)
$len = (generateRow -Width 100 -StartChar $headerStart$FillChar -EndChar $headerEnd -FillChar $fillChar -Content "MARCI VAGYOK" -Padding)
lengthTest $len 100

#generateRow -Width 100 -StartChar $pipeChar -EndChar $pipeChar -FillChar " " -Content "6  : -                       | 16  : -                         | 26  :                           " -Padding
$len = generateRow -Width 100 -StartChar $pipeChar -EndChar $pipeChar -FillChar " " -Content "6  : -                       | 16  : -                         | 26  :                           " -Padding
lengthTest $len 100

$len =  generateRow -Width 100 -StartChar $pipeChar -EndChar $pipeChar -FillChar " " -Content "7  : -                       | 17  : -                         | 27  : 12345123451234512345-012356789dddd" -Padding
lengthTest $len 100

$len = generateRow -Width 100 -StartChar $pipeChar -EndChar $pipeChar -FillChar " " -Content "8  : Admin-Test              | 18  : -                         | 28  : Wifi-speed-test           " -Padding
lengthTest $len 100

$len = generateRow -Width 100 -StartChar $pipeChar -EndChar $pipeChar -FillChar " " -Content "9  : Check-Bitlocker-Status  | 19  : -                         | 29  : PCI-Express-powersaving  dddd" -Padding
lengthTest $len 100

$len = generateRow -Width 100 -StartChar $footerStart -EndChar $footerEnd -FillChar $fillChar
lengthTest $len 100