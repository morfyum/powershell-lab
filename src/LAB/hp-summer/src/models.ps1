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

class ProductNumberOption {
  [String]$DisplayName
  [String]$ProductId

  [String]ToString() {
      Return $This.DisplayName
  }
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