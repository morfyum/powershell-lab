# Before start, required code execution permission in current session
# powershell -Command "Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy Unrestricted -Force"
# Start me with the following command in a .bat file
# powershell -Command "Start-Process powershell.exe -ArgumentList '.\elevate-root.ps1' -WindowStyle hidden"
# 

Write-Host "[PASS] Elevate to Administrator..." -ForegroundColor Green

$current_dir = pwd
$execute_this = ".\test_root_external_powershell.ps1"

Write-Host "Current directroy: [ $current_dir ]"
#Get-ExecutionPolicy
Start-Process powershell.exe -Verb runAs -ArgumentList "
    cd $current_dir;
    powershell.exe $execute_this;" -Wait
echo "wait for process..."
Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy Restricted -Force
#Get-ExecutionPolicy
exit