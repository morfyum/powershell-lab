# IMPORT
Write-Host "Load modules..." -ForegroundColor Gray
Import-Module ".\PSMenu\0.2.0\PSMenu.psm1"
. .\models.ps1
. .\hp-summer.ps1
# LOAD RESOURCES
Write-Host "Load resources..." -ForegroundColor Gray

# VARIABLES
$config = [Config]::new()
$data = [DataCollection]::new()

# START APP
while ($true) {
    #Write-Host "Running $($data.jsonLength)" -ForegroundColor Green
    Write-Host "----------------`t-----------------------------------------"
    $readSerialNumber = Read-Host "SERIAL NUMBER`t"

    $readSerialNumber = ValidateSerialNumber -InputSerialNumber $readSerialNumber
    while ($null -eq $readSerialNumber) {
        $readSerialNumber = Read-Host "SERIAL NUMBER`t"
        $readSerialNumber = ValidateSerialNumber -InputSerialNumber $readSerialNumber
    }

    # Unecessary Request
    if ($data.tattooSerialNumber -eq $readSerialNumber) {
        Write-Host "Unecessary Request" -ForegroundColor Yellow
        $temp = $data.jsonData 
        $data = [DataCollection]::new()
        $data.jsonData = $temp
    } else {
        $data = [DataCollection]::new()
        $data.jsonData = primaryWebRequest -ApiServer $config.APIServer -SerialNumber $readSerialNumber
    }

    #$data.jsonLength = ($data.jsonData.Body.SerialNumberBOM.unit_configuration).length
    $data.jsonLength = ($data.jsonData.Body.SerialNumberBOM.unit_configuration.part_description).Length

    Clear-Host

    if ( $data.jsonLength -eq 0 ) {
        $readProductNumber = Read-Host "Product Number`t"
        $readProductNumber = ValidateProductNumberWithoutLanguageCode -InputProductNumber $readProductNumber
        while ($null -eq $readProductNumber) {
            $readProductNumber = Read-Host "Product Number`t"    
            $readProductNumber = ValidateProductNumberWithoutLanguageCode -InputProductNumber $readProductNumber
        }
        Write-Host "----------------`t-----------------------------------------"

        # Secondary Request
        $data.jsonData = primaryWebRequest -ApiServer $config.APIServer -SerialNumber $readSerialNumber -ProductNumber $readProductNumber
        $data.jsonLength = ($data.jsonData.Body.SerialNumberBOM.unit_configuration.part_description).Length
        if ($data.jsonLength -eq 0) {
            Write-Host "$HPSideErrorMessage" -ForegroundColor Red
        }
    }

    # On Successfull Request
    if ($data.jsonLength -gt 0) {
        # SerialNumber, Product Number, and Description(Product Name)
        $data.tattooSerialNumber  = $data.jsonData.Body.SerialNumberBOM.wwsnrsinput.serial_no
        $data.ProductNumber = $data.jsonData.Body.SerialNumberBOM.wwsnrsinput.product_no
        $data.tattooProductName   = $data.jsonData.Body.SerialNumberBOM.wwsnrsinput.user_name

        # Build other information from jsonData
        searchInJson

        $data.tattooProductNumber = $data.ProductNumber+"#"+$data.LanguageCode

        if ($config.imageQueryEnabled -eq "yes") {
            # ARRAY: 0, 1
            $dateAndImage = checkImage -FilePath $config.imageList -ProductNumber $data.tattooProductNumber
            $data.hasImage = $dateAndImage[1]
        } else {
            $data.hasImage = "Disabled"
        }

        # SHOW DATA IS AN INDEPENDENT SECTION! 
        Write-Host "Serial Number`t: $($data.tattooSerialNumber)" -ForegroundColor Green
        Write-Host "Product Number`t: $($data.tattooProductNumber) [ $($data.LanguageCode) ]" -ForegroundColor Green
        Write-Host "Product Name`t: $($data.tattooProductName)" -ForegroundColor Green
        Write-Host "Build ID`t: $($data.tattooBuildID)" -ForegroundColor Green
        Write-Host "Feature Byte`t: $($data.tattooFeatureByte)" -ForegroundColor Green
        if ($data.OS -eq "") {
            Write-Host "`nFactory System`t: FreeDOS" -ForegroundColor Red
        } else {
            Write-Host "`nFactory System`t: $($data.OS)" -ForegroundColor Green
            if ($data.hasImage -eq $true) {
                Write-Host "Image Version`t: Van [ $($data.OS) ] / $($data.imageVersion)" -ForegroundColor Blue
            } elseif ($data.hasImage -eq $false) {
                Write-Host "Image Version`t: Nincs [ $($data.OS) ] / $($data.imageVersion)" -ForegroundColor Red
            }
        }
        Write-Host "`nPart Number`tPart Serial No`t`tComponent Name"
        Write-Host "----------`t--------------`t`t------------------------------------"
        for ($counter=0; $counter -lt $($data.ComponentNumber).Length; $counter++) {
            if ($($data.ComponentSerialNo[$counter]) -match "WIN") {
                Write-Host "$($data.ComponentNumber[$counter])`t| $($data.ComponentSerialNo[$counter])`t| $($data.ComponentDescription[$counter])" -ForegroundColor Green
            } else {
                Write-Host "$($data.ComponentNumber[$counter])`t| $($data.ComponentSerialNo[$counter])`t| $($data.ComponentDescription[$counter])"
            }
        }
    }

}
