$fillChar = [char]9472      # ─
$startChar = [char]0x250C   # ┌
$headerEnd = [char]0x2510   # ┐
$pipeChar = [char]0x2502    # │
$footerStart = [char]0x2514 # └
$footerEnd = [char]0x2518   # ┘

function generateRow {
    param (
        [string] $Width = $selfWidth-1,
        [string] $StartChar = "",
        [string] $EndChar = "",
        [string] $FillChar = " ",
        [string] $Content,
        [switch] $Padding
    )

    if ($Padding -eq $true) {
        $Content = " $Content "
    }

    $fillNeed = $Width-($startChar.Length+$EndChar.Length+$Content.Length)
    $startCount = 0

    if ($Content.Length -gt $Width) {
        #Write-Output "W: $($Content.Length)"
        $cutStringLength = ($Content.Length - $Width) + 4
        $Content = $Content.Substring(0, $Content.Length - $cutStringLength ) + "..."
    }

    for ($counter = $startCount; $counter -le ($fillNeed); $counter += 1) {
        $filler = $filler+$FillChar
    }
    $row = $StartChar+$Content+$filler+$EndChar
    return $row
}