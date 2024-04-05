# hp-summer by Morfyum

class Config {
    [string] $invokedFile = "invokedFile.txt"
    [string] $exampleTattooFile = "exampleTattoo.tattoo"
    [string] $APIServer
    [string] $SKUListFullPath
    [string] $KITListFullPath
    [string] $imageList
    [string] $imageQueryEnabled
    [string] $fatalError = $HPSideErrorMessage

    Config() {
        $userConfigPath = ".\config.json"
        $userConfig = (Get-Content -Path $userConfigPath -Raw | ConvertFrom-Json)

        $this.SKUListFullPath = $userConfig.localSKUList
        $this.KITListFullPath = $userConfig.localKITList
        $this.imageList = $userConfig.localImageList
        $this.imageQueryEnabled = $userConfig.imageQueryEnabled

        $this.APIServer = $userConfig.HeaderParameters.APIServer
    }
}

class DataCollection {
    [string] $jsonLength = 0                # DONE
    [object] $jsonData = $null              # DONE
    [string] $ProductNumber = $null         # DONE
    [string] $tattooSerialNumber = $null    # DONE 1
    [string] $tattooProductNumber = $null   # DONE 3
    [string] $tattooProductName = $null     # DONE 5
    [string] $tattooBuildID = $null         # DONE 4
    [string] $tattooFeatureByte = $null     # DONE 2
    [string] $tattooSystemFamily = "HP"     # !
    [string] $languageCode = $null          # DONE
    [string] $imageVersion = $null          # DONE
    [string] $OS = $null                    # DONE
    [string] $platform =$null
    [string] $platformVersion = $null       # DONE
    [string] $hasImage = $null              # DONE
    [bool] $hasKIT = $null
    [array]  $ComponentNumber = $null       # DONE
    [array]  $ComponentDescription = $null  # DONE
    [array]  $ComponentSerialNo = $null     # DONE
}

$HPSideErrorMessage = "***********************************************************

  # Hibas SERIAL NUMBER es/vagy PRODUCT NUMBER megadasakor lathatod ezt!
    Amennyiben a megadott SN & PN is helyes, valoszinuleg halozati hibarol van szo.
    - Nincs aktiv interneted 
    - HP partsurfer oldal sem mukodik: https://partsurfer.hp.com/
    - API valtozas. => Amennyiben a partSurfer megy, az APIServer valtozott

  # Invalid SERIAL NUMBER and/or PRODUCT NUMBER!
    When SN & PN are valid, the problem comes from your internet connection
    - You have no active internet connection
    - HP partsurfer site are unavailable
    - API changing => When partSurfer are work, then APIServer are changed

  ## You can report issue on: https://github.com/morfyum

***********************************************************
1. Invalid SERIAL NUMBER or PRODUCT NUMBER
2. PartSurfer site not available,
3. PartSurfer API name has changed
4. Authorization key changed
5. or you have no active internet connection"

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

function primaryWebRequest {
    param (
        [Parameter(Mandatory)]
        [string] $ApiServer,
        [Parameter(Mandatory)]
        [string] $SerialNumber,
        [string] $ProductNumber
    )
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
    # Secondary Request
    if ($ProductNumber -ne "") {
        try {
            $result = (Invoke-WebRequest -Uri $ApiServer/partsurferapi/SerialNumber/GetSerialNumber/$SerialNumber/ProductNumber/$ProductNumber/country/US/usertype/EXT -Method Get -Headers $requestHeader).Content | ConvertFrom-Json
            if (($result.Body.SerialNumberBOM.unit_configuration.part_description).Length -eq 0) {
                $result = $HPSideErrorMessage
                return $result
            }
            return $result
        }
        catch {
            $result = $HPSideErrorMessage
        }
    }

    # Primary Request
    try {
        $result = (Invoke-WebRequest -Uri $ApiServer/partsurferapi/Search/GenericSearch/$SerialNumber/country/US/usertype/EXT -Method Get -Headers $requestHeader).Content | ConvertFrom-Json    
    }
    catch {
        $result = $HPSideErrorMessage
    }
    return $result
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