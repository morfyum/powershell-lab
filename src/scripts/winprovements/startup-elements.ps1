# Manage Startup Applications

$startup_elements = (Get-CimInstance Win32_StartupCommand | Select-Object Name, Location).Name
$startup_elements_location = (Get-CimInstance Win32_StartupCommand | Select-Object Name, Location).Location
$startup_counter = 0

foreach ($element in $startup_elements) {
    Write-Host "*** [" $startup_elements[$startup_counter], "] on [", $startup_elements_location[$startup_counter],"] ***" -ForegroundColor Green

    $user_input = Read-Host "  - Do you want to Disable? [y/N]" -MaskInput
    $user_input.ToLower() | Out-Null
    if ($user_input -eq "y" ) {
        #pass
    } else {
        #pass
    }

    # Startup Exceptions: Security Health
    if ($startup_elements[$startup_counter] -eq "SecurityHealth") {
        Write-Host "  - Skip Startup Exception:" $startup_elements[$startup_counter] -ForegroundColor Yellow
    } else {
        reg add $startup_elements_location[$startup_counter] /v $startup_elements[$startup_counter] /t REG_DWORD /d 0 /f | Out-Null
    }

    if ( $? -eq $true) {
        Write-Host "  - Success" -ForegroundColor Green
    } elseif ($? -eq $false) {
        Write-Host "  - Failed" -ForegroundColor Red
        exit 1
    }

    $startup_counter = $startup_counter + 1
}