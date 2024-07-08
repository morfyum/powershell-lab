# TEST ON VM: PCI\VEN_1B36&DEV_0100&SUBSYSTEM_...

$driverDirectory = "C:\Users\mars\Downloads\extracted-drivers\"
$infFiles = Get-ChildItem -Path $driverDirectory -Recurse -Filter *.inf
$testInfPath = "C:\Users\mars\Downloads\extracted-drivers\spice-guest-tools-latest\drivers\qxl\2k8R2\amd64\qxl.inf"

function CheckDeviceIDInFile {
    param (
        [string]$FilePath,
        [string]$VendorID,
        [string]$DeviceID
    )
    $fileContent = Get-Content -Path $FilePath
    $pattern = "VEN_$VendorID&DEV_$DeviceID"
    Write-Host "|<- $FilePath" -ForegroundColor Yellow
    Write-Host "|-> [$pattern]" -ForegroundColor Yellow
    foreach ($line in $FileContent) {
        if ($line -match $pattern) {
            Write-Host "$line" -ForegroundColor Green
            return $true
        }
    }
    return $false
}

function InstallInf {
    param (
        [Parameter(Mandatory=$false)]
        [string] $FilePath
    )

    foreach ($infFile in $infFiles) {
        Write-Host "Install: $($infFile.FullName)"
        pnputil /add-driver $infFile.FullName /install
    }
}


foreach ($infFile in $infFiles) {
    Write-Host "*** $($infFile.FullName)" -ForegroundColor Red
    CheckDeviceIDInFile -FilePath $($infFile.FullName) -VendorID "1B36" -DeviceID "0100"
    #pnputil.exe /add-driver $infFile.FullName /install
}