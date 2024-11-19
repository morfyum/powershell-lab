. ./nonsense-automation.ps1

#FocusWindow -WindowNameOrID "Kamera"

#SendInput -String "{UP}"


<#
AltTab
Start-Sleep -Seconds 1
SendInput -String "Minden rendben lesz, csak ékezeteket nem kezel."
Start-Sleep -Seconds 1
CtrlA
Start-Sleep -Seconds 1
CtrlC
Start-Sleep -Seconds 1
CursorMove -PositionX 1285 -PositionY 400 -Click
#CursorClickLeft
Start-Sleep -Seconds 1
SendInput -String "Ctrl+A"
SendInput -String "Ctrl+V"
Start-Sleep -Seconds 1
SendInput -String "Enter"
CtrlV
#>

# Read lines from file and do something
<#
$fileLines = Get-Content -Path .\lines.txt -Encoding UTF8
FocusWindow -WindowNameOrID "10856"

$fileLines | ForEach-Object {
    SendInput -String "TAB"
    SendInput -String $_
    Start-Sleep -Milliseconds 250
    Enter
}
#>

AltTabTab
