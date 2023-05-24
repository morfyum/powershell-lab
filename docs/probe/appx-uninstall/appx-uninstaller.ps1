# APPX CLEANUP 

#$json = Get-Content -Path ".\appx-list.json" | Out-String | ConvertFrom-Json
#$json_length = $json.AppXPackages.Count
#echo "Len: $json_length"


$json = Get-Content -Path ".\appx-list2.json" | ConvertFrom-Json
$appx_packages_count = ($json.AppXPackages | Get-Member -MemberType NoteProperty).Length
Write-Host "Az AppXPackages részben található elemek száma: $appx_packages_count" -ForegroundColor red


Write-Host $json.AppXPackages.Key


$appx_packages = @(
    'Zero',
    'One',
    'Two',
    'Three'
)

$appx_packages_length = ($appx_packages).Length

Write-Host "Length: $appx_packages_length" -ForegroundColor Green
#Write-Host $appx_packages[0]

for ($counter=0; $counter -lt $appx_packages_length; $counter++ ) {
    Write-Host "$($appx_packages[$counter])"
}

echo "------"
