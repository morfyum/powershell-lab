
$serverPath = "./server"
$imageListFile = "./imageList.txt"

function findOnShare {
    param (
        [string] $SharePath,
        [string] $SkuNumber
    )
    $hasImage = $false
    Get-ChildItem $SharePath | ForEach-Object {
        if("123456789#ABZ" -eq $_){
            $hasImage = $true
            return $hasImage
        }
    }
    return $hasImage
}

function MakeImageList {
    param (
        [string] $Location
    )
    $currentDate = Get-Date -Format "dd/MM/yyyy HH:mm:ss"
    Write-Host "Last Update: $lastModified"
    $imageList = @()
    $imageList += $currentDate
    (Get-ChildItem -Path $Location) | ForEach-Object {
        if ($_.Name -match '.........#[A-Z][A-Z][A-Z]') {
            Write-Host "Add to list: $($_.Name)"
            $imageList += $_.Name
        }
    }
    return $imageList
}

MakeImageList -Location $serverPath > $imageListFile


function CheckImageInList {
    param (
        [string] $ImageList,
        [string] $SkuNumber
    )
    $hasImage = $false
    Get-Content $ImageList | ForEach-Object {
        #Write-Host "$SkuNumber ? $_"
        if ($_ -eq $SkuNumber) {
            $hasImage = $true
            return $hasImage
        }
    }
    return $hasImage
}

CheckImageInList -ImageList $imageListFile -SkuNumber "AA3456789#UUZ"
