# APPX UNINSTALLER

$json_file = "appx-list2.json"
$json = Get-Content -Path $json_file | ConvertFrom-Json

#$packages = $json.packages
$packages_length = ($json.packages).Length


Write-Host "info developer    : $($json.developer)" -ForegroundColor Gray
Write-Host "info File.Name    : $($json.File.Name)" -ForegroundColor Gray
Write-Host "info File.Version : $($json.File.Version)" -ForegroundColor Gray
Write-Host "info Length       : $packages_length" -ForegroundColor Gray
echo "-------------------------"

# JSON PATHS
$package_name = $json.packages.package_name
$package_type = $json.packages.type
$package_category = $json.packages.category
$package_description = $json.packages.description


#echo "Name        : $($package_name[$counter])"
#echo "Type        : $($package_type[$counter])"
#echo "Category    : $($package_category[$counter])"
#echo "Description : $($package_description[$counter])"



function AppxPackageManager() {
    Write-Host "*** Appx Package Manager ***" -ForegroundColor Cyan
    for ($counter=0; $counter -lt $packages_length; $counter++) {

        $package_full_name = (Get-AppxPackage -Name $package_name[$counter]).PackageFullName

        Write-Host "Name        : [ $($package_name[$counter]) ]"
        Write-Host "Full Name   : [ $package_full_name ]"
        Write-Host "Type        : [ $($package_type[$counter]) ]"
        Write-Host "Category    : [ $($package_category[$counter]) ]"
        Write-Host "Description : [ $($package_description[$counter]) ]"
        $action = Read-Host "Delete? [Y/n]"
        #echo "action: $action"
        if ($action -eq "y" -or $action -eq "Y") {
            Write-Host "Delete... [ $package_full_name ]" -ForegroundColor Red
        }
        else {
            Write-Host "Skip." -ForegroundColor Yellow
        }
    }
}

AppxPackageManager


function removeAppxPackage ($list_to_remove) {
    Write-Host "*** removeAppxPackage ***" -ForegroundColor Cyan

    #Get-AppxPackage "Microsoft.3DBuilder" | Remove-AppxPackage
}