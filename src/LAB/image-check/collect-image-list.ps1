
$Global:serverPath = "./server"
$Global:imageListFile = "./imageList.txt"

function MakeImageList {
    param (
        [string] $Location
    )
    $imageList = @()
    (Get-ChildItem -Path $Location) | ForEach-Object {
        if ($_.Name -match '.........#[A-Z][A-Z][A-Z]') {
            Write-Host " - [$($_.Name)]"
            $imageList += $_.Name
        }
    }
    return $imageList
}

MakeImageList -Location $Global:serverPath > $Global:imageListFile


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
        }
    }
    return $hasImage 
}

CheckImageInList -ImageList $Global:imageListFile -SkuNumber "AA3456789#UUZ"
