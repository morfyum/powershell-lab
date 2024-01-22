<# BIOS UPDATE UTILITY FOR FLEX DIAG-REPAIR PROCESS IMPROVEMENT
Developed by        : Morfyum - github.com/morfyum
Show exe info       : (Get-Item .\sp143413.exe ) | Format-List

#$csvData = Import-Csv -Path $test_csv_file_path -Delimiter ";"
#$csvData | Format-Table
#$($csvData).Description
#>

class DeviceInfo {
    [string] $SerialNumber
    [string] $BIOSVersion
    [string] $SSID
}

class BIOSFileInfo {
    [string] $BIOSVersion
    [string] $SSID
    [string] $MD5Sum
}

class CSVInfo {
    [string] $SSID
    [string] $BIOSVersion
    [string] $FilePath
    [string] $LastUpdate
    [string] $Platform
}


function GetBIOSFileProductVersion {
    param (
        [Parameter(mandatory=$true)]
        [string] $Path
    )
    if (Test-Path $Path) {
        $BIOSVersion = (Get-Item $Path).VersionInfo.ProductVersion
        Return $BIOSVersion    
    }  else {
        $error_message = "Error: Path Does not exists => GetBIOSFileProductVersion()" 
        Write-Host $error_message -ForegroundColor Red
        Return $error_message
    }
}

function GetBIOSFileSSID {
    param (
        [Parameter(mandatory=$true)]
        [string] $Path
    )

    if (Test-Path $Path) {
        $BIOSSSID = (Get-Item $Path ).VersionInfo.FileDescription | Select-String -Pattern 'SSID\s+(\d{4})' -AllMatches | ForEach-Object { $_.Matches.Groups[1].Value }
        return $BIOSSSID
    }  else {
        $error_message = "Error: Path Does not exists => GetBIOSFileSSID()"
        Write-Host $error_message -ForegroundColor Red
        Return $error_message
    }
}


function FindInCSVBySSID {
    param (
        [Parameter(mandatory=$true)]
        [string] $SSID
    )

    $csvData | ForEach-Object {

        if ($($_.SSID) -eq $test_SSID_variable) {
            Write-Host "Match! $($_.SSID)"

        }
        #Write-Host "index       :", $($_.Index)
        #Write-Host "BIOSVersion :", $($_.SSID) 
        #Write-Host "Path        :", $($_.biv_folder)
        #Write-Host "Last update :", $($_.biv_lastupd)
        #Write-Host "Description :", $($_.biv_description)
    }#>
}

######################################################
#################### Application  ####################
######################################################

# Moved into independent file. 
# This contain only Functions and classess

######################################################
#################### TEST Outputs ####################
######################################################

function testClassValues {
    param (
        [string]$TestName,
        #[Parameter(mandatory=$true)]
        [string]$classValue,
        #[Parameter(mandatory=$true)]
        [string]$expectedValue
    )

    class TestResults {
        [string] $TestName
        [string] $FunctionReturn
        #[string] $expectedValue = $expectedValue
        [string] $Result
    }

    $TestResults = [TestResults]::new()

    $nameLength = $TestName.Length
    $print_TestName = $TestName
    $maxLength = 25
    
    # Handle Test Params
    if ($TestName -eq "") { $TestName = "NoName"}
    
    for ($currentLength=$nameLength; $currentLength -lt $maxLength; $currentLength=$currentLength+1) {
        $print_TestName = $print_TestName+" "
    }

    $TestResults.TestName = $print_TestName
    $TestResults.FunctionReturn = $classValue

    if ($classValue -eq $expectedValue) {
        $TestResults.Result = "[ OK ]"
        Write-Host "[ OK ] : Test/$print_TestName -> [$classValue]" -ForegroundColor Green
        #Return $TestResults
    } else {
        ($TestResults).Result = "[FAIL]"
        Write-Host "[FAIL] : Test/$print_TestName -> [$classValue]" -ForegroundColor Red
        #Return $TestResults
    }
}