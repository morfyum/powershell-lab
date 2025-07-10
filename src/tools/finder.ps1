function Search-FileContentAndName {
    param(
        [Parameter(Mandatory=$true)]
        [string]$Path,

        [Parameter(Mandatory=$true)]
        [string]$Keyword,

        [switch]$SearchOnlyInMatchingNames = $false,
        [string[]]$IncludeExtensions = @("*"),
        [string[]]$ExcludeExtensions = @(".pak",".dat",".wim", ".ttf", ".exe", ".dll", ".zip", ".rar", ".7z", ".jpg", ".jpeg", ".png", ".gif", ".bmp", ".mp3", ".mp4", ".avi", ".mkv", ".pdf", ".docx", ".xlsx", ".pptx", ".odt", ".ods", ".odp")
    )

    Write-Host "PowerShell finder..." -ForegroundColor Green
    Write-Host "Path:    $Path" -ForegroundColor Cyan
    Write-Host "Keyword: $Keyword" -ForegroundColor Cyan
    Write-Host "Search only in files matching the name: $($SearchOnlyInMatchingNames)" -ForegroundColor Cyan
    Write-Host "Included Extensions: $($IncludeExtensions -join ', ')" -ForegroundColor Cyan
    Write-Host "Excluded Extensions: $($ExcludeExtensions -join ', ')" -ForegroundColor Cyan
    Write-Host ""

    $foundFilesByName = @()
    $foundFilesByContent = @()

    # Fájlnevek keresése
    Write-Host "Searching for filenames with keyword '$Keyword'" -ForegroundColor Yellow
    Get-ChildItem -Path $Path -Recurse -File -Include $IncludeExtensions -ErrorAction SilentlyContinue| ForEach-Object {
        if ($_.Name -like "*$Keyword*") {
            $foundFilesByName += $_.FullName
            Write-Host "# Match by Name: $($_.FullName)" -ForegroundColor Green
        }
    }

    Write-Host ""
    Write-Host "Searching file contents using '$Keyword'..." -ForegroundColor Yellow

    $filesToSearch = @()

    if ($SearchOnlyInMatchingNames -and $foundFilesByName.Count -eq 0) {
        Write-Host "No file with the keyword in its name. Skipping content search." -ForegroundColor Yellow
    }
    elseif ($SearchOnlyInMatchingNames) {
        Write-Host "Search for content only in files found in the name..." -ForegroundColor Yellow
        $filesToSearch = $foundFilesByName
    }
    else {
        $filesToSearch = Get-ChildItem -Path $Path -Recurse -File -Include $IncludeExtensions -ErrorAction SilentlyContinue -| Select-Object -ExpandProperty FullName
    }

    foreach ($file in $filesToSearch) {
        # Check excluded extensions
        $fileExtension = [System.IO.Path]::GetExtension($file)
        if ($fileExtension -ne "") {
            if ($ExcludeExtensions -contains $fileExtension.ToLower()) {
                Write-Host "SKIP: $($file)" -ForegroundColor DarkGray
                continue
            }
        }

        try {
            Select-String -Path $file -Pattern $Keyword -CaseSensitive:$false -ErrorAction SilentlyContinue | ForEach-Object {
                $line = $_.Line
                $lineNumber = $_.LineNumber
                $foundFilesByContent += [PSCustomObject]@{
                    Path = $_.Path
                    LineNumber = $lineNumber
                    LineContent = $line
                }
                Write-Host "File: $($_.Path) (Line: $lineNumber): $line" -ForegroundColor Green
            }
        }
        catch {
            Write-Warning "An error occurred while reading file: $($file). Error: $($_.Exception.Message)"
        }
    }

    Write-Host "--- Summary ---" -ForegroundColor Green
    Write-Host "# Files matched in name ($($foundFilesByName.Count) pcs):" -ForegroundColor Green
    if ($foundFilesByName.Count -gt 0) {
        $foundFilesByName | ForEach-Object { Write-Host "  $_" }
    } else {
        Write-Host "Not found"
    }

    Write-Host "# Files matched in content ($($foundFilesByContent.Count) pcs):" -ForegroundColor Green
    if ($foundFilesByContent.Count -gt 0) {
        $foundFilesByContent | Format-Table -AutoSize
    } else {
        Write-Host "Not found"
    }
    Write-Host "Search Completed" -ForegroundColor Green
}

$setPath = Read-Host "Path"
$setKeyword = Read-Host "Keyword(s)"
Search-FileContentAndName -Path $setPath -Keyword $setKeyword