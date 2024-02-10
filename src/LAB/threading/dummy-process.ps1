
$selfLocation = (Get-Location).Path
$selfPID = $PID 

Write-Host "Dummy Process"
$selfPID
$selfLocation
$IPv4Address = (Get-NetIPConfiguration).IPv4Address.IPAddress
#"Sleep"
#Start-Sleep -Seconds 5
#"$IPv4Address" > "$selfLocation\proc\$selfPID"
$IPv4Address | Out-File -FilePath "$selfLocation\proc\$selfPID"

#"Write done. > Exit"
Exit