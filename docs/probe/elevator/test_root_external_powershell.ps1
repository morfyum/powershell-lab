Write-Host "test Adm1nistrator in Powershell" -ForegroundColor Gray
$current_dir = pwd
$current_policy = Get-ExecutionPolicy

Write-Host "Current dir: [ $current_dir ] Policy: [ $current_policy ]"

# $test_this_path = 
# C:\Program Files\WindowsApps\
# C:\Windows\System32\config
Get-Acl 'C:\Windows\System32\config' | Out-Null

if ($? -eq $true ) {
    Write-Host "[PASS] Adm1nistrator in Powershell" -ForegroundColor Green
} else {
    Write-Host "[FAIL] Cant escalate" -ForegroundColor Red
}

pause
exit