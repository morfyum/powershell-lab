# hp-summer by Morfyum
function ValidateSerialNumber {
    param (
        [string] $InputSerialNumber
    )

    $InputSerialNumber = $InputSerialNumber -Replace '[áöé \-_.]', ''
    
    if ($InputSerialNumber.Length -eq 10) {
        $result = $InputSerialNumber
        return $result
    } else {
        #Write-Error = "Invalod Serial Number [$InputSerialNumber]"
        return $null
    }
}

function ValidateProductNumberWithoutLanguageCode {
    param (
        [string] $InputProductNumber
    )
    $InputProductNumber = $InputProductNumber -Replace '[áöé \-_.]', ''

    if ($InputProductNumber.Length -eq 11 ) {
        $InputProductNumber = $InputProductNumber.Substring(0, $InputProductNumber.Length - 4)
    }

    if ($InputProductNumber.Length -eq 7 ) {
        $result = $InputProductNumber
        return $result
    } else {
        return $null
    }
}

function New-ProductNumberOptionItem([String]$DisplayName, [String]$ProductId) {
    $MenuItem = [ProductNumberOption]::new()
    $MenuItem.DisplayName = $DisplayName
    $MenuItem.ProductId = $ProductId
    Return $MenuItem
}

function primaryWebRequest {
    param (
        [Parameter(Mandatory)]
        [string] $ApiServer,
        [Parameter(Mandatory)]
        [string] $SerialNumber,
        [string] $ProductNumber
    )
    $firstRequestHeader = @{
        "Accept" = "*/*"
        "Accept-Encoding" = "gzip, deflate, br, zstd"
        "Accept-Language" = "hu,hu-HU;q=0.9,en;q=0.8"
        "Access-Control-Request-Headers" = "authorization"
        "Access-Control-Request-Method" = "GET"
        "Cache-Control"="no-cache"
        "Origin"="https://partsurfer.hp.com"
        "Pragma"="no-cache"
        "Referer"="https://partsurfer.hp.com/"
        "Sec-Fetch-Dest"="empty"
        "Sec-Fetch-Mode"="cors"
        "Sec-Fetch-Site"="same-site"
        "User-Agent"="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36"
    }
    $requestHeader = @{
        "Accept" = "application/json, text/plain, */*"
        "Accept-Encoding" = "gzip, deflate, br"
        "Accept-Language" = "en-US,en;q=0.9"
        "Authorization" = "Basic MjAyMzEzNy1wYXJ0c3VyZmVyOlBTVVJGQCNQUk9E"
        "Host"="pro-psurf-app.glb.inc.hp.com"
        "Origin"="https://partsurfer.hp.com"
        "Referer"="https://partsurfer.hp.com/"
        "sec-ch-ua"='"Google Chrome";v="117", "Not;A=Brand";v="8", "Chromium";v="117"'
        "sec-ch-ua-mobile"="?0"
        "sec-ch-ua-platform"='"Windows"'
        "Sec-Fetch-Dest"="empty"
        "Sec-Fetch-Mode"="cors"
        "Sec-Fetch-Site"="same-site"
        "User-Agent"="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/117.0.0.0 Safari/537.36"
    }
    # ApiServer can be changed by HP: [ app.glb ] > [ dr-app ]

    # Primary Request
    start-job -Name PrimaryHPRequest -ScriptBlock { 
        param(
            $ApiServer,
            $SerialNumber,
            $firstRequestHeader,
            $requestHeader)
        try {
            $result = Invoke-WebRequest -Uri $ApiServer/partsurferapi/SerialNumber/GetSerialNumber/$SerialNumber/country/US/usertype/EXT -Method Options -Headers $firstRequestHeader
            $result = (Invoke-WebRequest -Uri $ApiServer/partsurferapi/SerialNumber/GetSerialNumber/$SerialNumber/country/US/usertype/EXT -Method Get -Headers $requestHeader).Content | ConvertFrom-Json   
        }
        catch {
            $result = $_
        }
        return $result;
    } -ArgumentList $ApiServer,$SerialNumber,$firstRequestHeader,$requestHeader | receive-job

    progress -title "Searching..." -jobName PrimaryHPRequest

    $result = Receive-Job -Id (get-job -name PrimaryHPRequest).Id

    if ($result.Body.SNRProductLists.Length -ne 0) {
        Write-Host "Multiple Products associated for above Serial Number."
        Write-Host "Please Select a Product Number."
        $Opts = @()
        foreach ($product in $result.Body.SNRProductLists) {
            $Opts += $(New-ProductNumberOptionItem -DisplayName $product.product_Desc -ProductId $product.product_Id)
        }
        $ProductNumber = (Show-Menu -MenuItems $Opts).ProductId
        if ($ProductNumber.Contains('#')) {
            $ProductNumber = $ProductNumber.Split('#')[0];
        }
    }
     # Secondary Request
     if ($ProductNumber -ne "") {
        start-job -Name SecondaryHpRequest -ScriptBlock { 
            param(
                $ApiServer,
                $SerialNumber,
                $ProductNumber,
                $firstRequestHeader,
                $requestHeader)
            try {
                $result = Invoke-WebRequest -Uri $ApiServer/partsurferapi/SerialNumber/GetSerialNumber/$SerialNumber/country/US/usertype/EXT -Method Options -Headers $firstRequestHeader
                $result = (Invoke-WebRequest -Uri $ApiServer/partsurferapi/SerialNumber/GetSerialNumber/$SerialNumber/ProductNumber/$ProductNumber/country/US/usertype/EXT -Method Get -Headers $requestHeader).Content | ConvertFrom-Json
            }
            catch {
                $result = $_
            }
            return $result;
        } -ArgumentList $ApiServer,$SerialNumber,$ProductNumber,$firstRequestHeader,$requestHeader | receive-job
        
        progress -title "Gathering data..." -jobName SecondaryHpRequest
        
        try {
            $result = Receive-Job -Id (get-job -name SecondaryHpRequest).Id
            if (($result.Body.SerialNumberBOM.unit_configuration.part_description).Length -eq 0) {
                return $HPSideErrorMessage
            }
        }
        catch {
            return $HPSideErrorMessage
        }
    }
    return $result
}

function progress {
    param (
        $title,
        $jobName
    )
    $spinner = @("-----","\\\\\","|||||","/////")
    $oldPos = $host.UI.RawUI.CursorPosition
    do { 
        $spin = 0
        do {
            [Console]::CursorLeft = 0; [Console]::CursorTop = $oldPos.Y
            write-host $spinner[$spin] " $title " $spinner[$spin] -fore Cyan
            start-sleep -m 100; $spin++
        }
        while ($spin -ne 4)
    }
    while ((get-job -name $jobName).State -eq "Running")
    $host.UI.RawUI.CursorPosition = $oldPos
}

function searchInJson {
    $jsonDataPartNumber  = $data.jsonData.Body.SerialNumberBOM.unit_configuration.part_number
    $jsonDataPartDescription = $data.jsonData.Body.SerialNumberBOM.unit_configuration.part_description
    $jsonDataPartSerialNo = $data.jsonData.Body.SerialNumberBOM.unit_configuration.part_serialno

    for ($counter=0; $counter -lt $data.jsonLength; $counter++) {
        #echo "Round: $counter"
        #Write-Host " ", $jsonDataPartNumber[$counter]
        #Write-Host " ", $jsonDataPartDescription[$counter]

        if ($jsonDataPartNumber[$counter].Length -eq 10 -and $jsonDataPartNumber[$counter] -ne "MANUF_DATE" -and $jsonDataPartNumber[$counter] -notmatch "UUID_HALF"){
            $data.ComponentNumber += $jsonDataPartNumber[$counter]
            $data.ComponentDescription += $jsonDataPartDescription[$counter]
            $data.ComponentSerialNo += $jsonDataPartSerialNo[$counter]
        }

        if ($jsonDataPartNumber[$counter] -eq "IMAGE_VERSION") {
            $data.imageVersion = $jsonDataPartSerialNo[$counter]
            $data.OS = $($data.imageVersion).Substring(0,5)
        }

        if ($jsonDataPartNumber[$counter] -eq "IMG_BUILDID") {
            $data.tattooBuildID = $jsonDataPartDescription[$counter]
        }

        if ($jsonDataPartNumber[$counter] -eq "IMG_DESC1") {
            $data.tattooFeatureByte = $data.tattooFeatureByte + $jsonDataPartDescription[$counter]
        }
        if ($jsonDataPartNumber[$counter] -eq "IMG_DESC2") {
            $data.tattooFeatureByte = $data.tattooFeatureByte + $jsonDataPartDescription[$counter]
        }
        if ($jsonDataPartNumber[$counter] -eq "IMG_DESC3") {
            $data.tattooFeatureByte = $data.tattooFeatureByte + $jsonDataPartDescription[$counter]
        }
    }

    # Write-Host "Clean Values..." -ForegroundColor Green
    $data.tattooBuildID = $($data.tattooBuildID).replace('BID=','')
    $data.tattooFeatureByte = $($data.tattooFeatureByte).replace(' ','')
    $data.LanguageCode = $data.tattooBuildID -replace '.*(.{3})','$1'
}

function checkImage {
    param (
        [Parameter(Mandatory)]
        [string] $FilePath,
        [Parameter(Mandatory)]
        [string] $ProductNumber
    )
    $dateAndImage = @()
    $imageName = $ProductNumber+=".rdr"

    if ((Test-Path -Path $FilePath) -eq $false) {
        $dateAndImage += "Missing file: $FilePath"
        $dateAndImage += "Missing file: $FilePath"
        return $dateAndImage
    } else {
        $imageList = Get-Content -Path $FilePath
    }

    $dateAndImage += $($imageList[0])
    $dateAndImage += $false

    foreach ($line in $imageList ){
        if ($line -eq $imageName ) {
            $dateAndImage[1] = $true
        }
    }
    if ($dateAndImage.Length -eq 2) {
        return $dateAndImage
    }
    return $null
}