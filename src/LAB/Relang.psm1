function Set-Relang() {
    $biostxt = $tattoo_file

    $newLangCodeInput = Read-Host "NEW LANGUAGE CODE"
    while (($newLangCodeInput) -notmatch "^[A-Z]{3}$") {
        Write-Host "Required 3 letter A-z: ABZ" -Foregroundcolor Red
        $newLangCodeInput = Read-Host "NEW LANGUAGE CODE"
    }
    $newLangCode = ($newLangCodeInput).ToUpper()

    if (Test-Path $biostxt) {
        $biosFile = Get-Content $biostxt
    } else {
        Write-Host "ERROR: Missing bios.txt" -Foregroundcolor Red
    }

    # LINE + REGEX FAMILY 
    $languageRelatedLines = @(
        "Sku Number",
        "Build ID"
    )
    $languageRelatedRegex = @(
        "(?<=#)[A-Za-z]{3}",
        "(?<=#.)[A-Za-z]{3}"
    )

    for ($fileIndex = 0; $fileIndex -lt $biosFile.Count; $fileIndex++) {
        $line = $biosFile[$fileIndex]
        for ($arrIndex = 0; $arrIndex -lt $languageRelatedLines.Count; $arrIndex++) {
            if ($languageRelatedLines[$arrIndex] -eq $line ) {
                Write-Host $line -Foregroundcolor Green
                $nextLine = $biosFile[$fileIndex+1] 
                Write-Host "$nextLine <- Old Line" -Foregroundcolor Red
                $nextLineUpdated = $nextLine -replace $languageRelatedRegex[$arrIndex], $newLangCode
                Write-Host "$nextLineUpdated <- New Line" -Foregroundcolor Green
                $biosFile[$fileIndex+1] = $nextLineUpdated
            }
        }
    }
    $biosFile | Set-Content -Path $biostxt
}
#Set-Relang