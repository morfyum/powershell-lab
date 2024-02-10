. .\src\UI.ps1

function lengthTest {
    param (
        [string] $String,
        [int] $ExceptedValue
    )
    if ($String.Length -eq $ExceptedValue ) { Write-Host "PASS.......... $ExceptedValue" -ForegroundColor Green } 
    else { Write-Host "FAIL.......... $($String.Length) Not equal $ExceptedValue" -ForegroundColor Red}
}

#<#
Write-Host "TEST: Get-ShortenedString -InputString -MaxLength" -ForegroundColor Yellow
$isTen = Get-ShortenedString -InputString "0123456789aaaaa" -MaxLength 10
$isFive = Get-ShortenedString -InputString "0123456789aaaaa" -MaxLength 5
$isTwelve = Get-ShortenedString -InputString "0123456789123333" -MaxLength 12
lengthTest $isTen 10
lengthTest $isFive 5
lengthTest $isTwelve 12
#>
Write-Host "TEST: generateRow -Width -StartChar -EndChar -FillChar -Content -Padding" -ForegroundColor Yellow
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

$len = generateRow -Width 727 -StartChar $footerStart -EndChar $footerEnd -FillChar $fillChar
lengthTest $len 727

$len = generateRow -Width 628 -StartChar $footerStart -EndChar $footerEnd -FillChar $fillChar
lengthTest $len 628

$len = generateRow -Width 1000 -StartChar $footerStart -EndChar $footerEnd -FillChar $fillChar
lengthTest $len 1000

$len = generateRow -Width 10 -StartChar $footerStart -EndChar $footerEnd -FillChar $fillChar
lengthTest $len 10