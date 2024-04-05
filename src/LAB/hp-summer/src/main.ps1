# IMPORT
Write-Host "Load modules..." -ForegroundColor Gray
. .\hp-summer.ps1
# LOAD RESOURCES
Write-Host "Load resources..." -ForegroundColor Gray

# VARIABLES
$config = [Config]::new()
$data = [DataCollection]::new()

# START APP
while ($true) {
    #Write-Host "Running $($data.jsonLength)" -ForegroundColor Green
    Write-Host "----------------        -----------------------------------------"
    $readSerialNumber = Read-Host "SERIAL NUMBER         "

    $readSerialNumber = ValidateSerialNumber -InputSerialNumber $readSerialNumber
    while ($null -eq $readSerialNumber) {
        $readSerialNumber = Read-Host "SERIAL NUMBER         "
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

    if ( $data.jsonLength -eq 0 ) {
        $readProductNumber = Read-Host "Product Number        "
        $readProductNumber = ValidateProductNumberWithoutLanguageCode -InputProductNumber $readProductNumber
        while ($null -eq $readProductNumber) {
            $readProductNumber = Read-Host "Product Number        "    
            $readProductNumber = ValidateProductNumberWithoutLanguageCode -InputProductNumber $readProductNumber
        }
        Write-Host "----------------        -----------------------------------------"

        # Secondary Request
        $data.jsonData = primaryWebRequest -ApiServer $config.APIServer -SerialNumber $readSerialNumber -ProductNumber $readProductNumber
        $data.jsonLength = ($data.jsonData.Body.SerialNumberBOM.unit_configuration.part_description).Length
        if ($data.jsonLength -eq 0) {
            Write-Host "$HPSideErrorMessage" -ForegroundColor Red
        }
    }

    # On Successfull Request
    if ($data.jsonLength -gt 0) {
        Write-Host "Gathering data..." -ForegroundColor Cyan

        # SerialNumber, Product Number, and Description(Product Name)
        $data.tattooSerialNumber  = $data.jsonData.Body.SerialNumberBOM.wwsnrsinput.serial_no
        $data.ProductNumber       = $data.jsonData.Body.SerialNumberBOM.wwsnrsinput.product_no
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
        Write-Host "Serial Number         : $($data.tattooSerialNumber)" -ForegroundColor Green
        Write-Host "Product Number        : $($data.tattooProductNumber) [ $($data.LanguageCode) ]" -ForegroundColor Green
        Write-Host "Product Name          : $($data.tattooProductName)" -ForegroundColor Green
        Write-Host "Build ID              : $($data.tattooBuildID)" -ForegroundColor Green
        Write-Host "Feature Byte          : $($data.tattooFeatureByte)" -ForegroundColor Green
        if ($data.hasImage -eq $true ) {
            Write-Host "Image Version         : Van [ $($data.OS) ] / $($data.imageVersion)" -ForegroundColor Green
        } elseif ($data.hasImage -eq $false) {
            Write-Host "Image Version         : Nincs [ $($data.OS) ] / $($data.imageVersion)" -ForegroundColor Red
        }
        Write-Host "Part Number  Part Serial No   Component Name"
        Write-Host "----------   --------------   ------------------------------------   "
        for ($counter=0; $counter -lt $($data.ComponentNumber).Length; $counter++) {
            
            if ($($data.ComponentSerialNo[$counter]) -match "WIN") {
                Write-Host "$($data.ComponentNumber[$counter]) | $($data.ComponentSerialNo[$counter]) | $($data.ComponentDescription[$counter])" -ForegroundColor Green
            } else {
                Write-Host "$($data.ComponentNumber[$counter]) | $($data.ComponentSerialNo[$counter]) | $($data.ComponentDescription[$counter])"
            }
        }
    }

}
