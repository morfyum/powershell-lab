# Windows 11 Virtual Machine Cleanup
# WARNING: Remove User applications for free up space

#01# DISM CAPABILITIES
#02# WINGET PACKAGE MANAGER
#03# APPX PACKAGES
#04# DRIVERS WITH DISM
#05# Spotify? Computer\HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\IrisService\Cache


# REDUCE DISK FOOTRPINT 
# SRC: https://learn.microsoft.com/en-us/windows/iot/iot-enterprise/optimize-your-device/reduce-disk-footprint

# RDF-01: Clean up Component Store
# https://learn.microsoft.com/en-us/windows/iot/iot-enterprise/optimize-your-device/reduce-disk-footprint
# SRC: https://learn.microsoft.com/en-us/windows-hardware/manufacture/desktop/iot-ent-optimize-images?view=windows-11#clean-up-component-store
# Dism.exe /online /Cleanup-Image /StartComponentCleanup
# Dism.exe /online /Cleanup-Image /StartComponentCleanup /ResetBase

# RDF-02: Disable Hibernation
# Powercfg.exe /hibernate off



# Dism.exe /Online /NoRestart /Disable-Feature /FeatureName:Microsoft-Windows-win32calc /PackageName:@Package

# /Get-DefaultAppAssociations
# + Export & Import DefaultAppAssoc


#01# DISM CAPABILITIES
# Show: dism /Online /Get-Capabilities /format:Table
# /Remove-Capability
# dism /Online /Get-Features /Format:Table | Find "| Enabled"
# Disable: /Disable-Feature

    #Used: 22,9 | Free: 2,00
    #Used: 23,00 | Free: 1,98 -> After remove
    #Used: 22,9 | Free: 2,04 -> After reboot 
    
    # Wordpad, Wallpaper, Windows Media Player (Legacy), Math Recognizer
    # Language speech en_GB, Handwriting en_GB, Hello Face, Internet Explorer
    dism /online /Remove-Capability /CapabilityName:Microsoft.Windows.WordPad~~~~0.0.1.0
    dism /online /Remove-Capability /CapabilityName:Microsoft.Wallpapers.Extended~~~~0.0.1.0
    dism /online /Remove-Capability /CapabilityName:Media.WindowsMediaPlayer~~~~0.0.12.0 /NoRestart
    dism /online /Remove-Capability /CapabilityName:MathRecognizer~~~~0.0.1.0 /NoRestart
    dism /online /Remove-Capability /CapabilityName:Language.Speech~~~en-GB~0.0.1.0
    dism /online /Remove-Capability /CapabilityName:Language.Handwriting~~~en-GB~0.0.1.0 /NoRestart
    dism /online /Remove-Capability /CapabilityName:Hello.Face.20134~~~~0.0.1.0 /NoRestart
    dism /online /Remove-Capability /CapabilityName:Browser.InternetExplorer~~~~0.0.11.0 /NoRestart


#02# WINGET PACKAGE MANAGER
# Show: winget list

    # Microsoft OneDrive
    winget uninstall Microsoft.OneDrive
    MicrosoftCorporationII.QuickAssist_8wekyb3d8bbwe


#03# APPX PACKAGES
# Show: Get-AppxPackage | Select-Object Name

# Used: 22,9 | Free: 2,03 
# Used: 22,6 | Free: 2,29 -> After remove 
# INFO: https://learn-microsoft-com.translate.goog/en-us/windows/application-management/system-apps-windows-client-os?_x_tr_sl=en&_x_tr_tl=hu&_x_tr_hl=hu&_x_tr_pto=sc7
# (Get-AppxProvisionedPackage -Online).PackageName
$package_full_name = (Get-AppxPackage -Name $package_name).PackageFullName
Remove-AppxProvisionedPackage -Online -PackageName $package_full_name

# Ok to remove
Microsoft.BingWeather
Microsoft.BingNews
Microsoft.Getstarted
Microsoft.WindowsFeedbackHub
Microsoft.GetHelp
Microsoft.LanguageExperiencePacken-GB   # ? VM
Microsoft.MicrosoftSolitaireCollection

# Break Functionality:
Microsoft.YourPhone
Microsoft.WindowsCamera
Microsoft.GamingApp             # todo / xbox
Microsoft.XboxGamingOverlay     # todo / xbox
Microsoft.XboxGameCallableUI    # todo / xbox
Microsoft.549981C3F5F10         # Cortana

# Remove Apps
MicrosoftTeams                 # todo / teams BECAUSE startup app 
Microsoft.Todos
Microsoft.WindowsMaps
Microsoft.People
Clipchamp.Clipchamp             # Video-editor
Microsoft.MicrosoftStickyNotes
Microsoft.MicrosoftOfficeHub


#04# OTHER DISM FEATURES
## Drivers: C:\Windows\System32\
# Path              Before      After
# -----------       --------    -----
# \drivers\         115 MB      115MB
# \DriverStore\     378 MB      201MB
# C:\Windows\INF\   46,6 MB     41,2MB


    # DRIVER CAPABILITIES
    # dism /online /Remove-Capability /CapabilityName: /Norestart
    Microsoft.Windows.Wifi.Client.Realtek.Rtwlane~~~~0.0.1.0
    Microsoft.Windows.Wifi.Client.Realtek.Rtwlane13~~~~0.0.1.0
    Microsoft.Windows.Wifi.Client.Realtek.Rtwlane01~~~~0.0.1.0
    Microsoft.Windows.Wifi.Client.Realtek.Rtl85n64~~~~0.0.1.0
    Microsoft.Windows.Wifi.Client.Realtek.Rtl819xp~~~~0.0.1.0
    Microsoft.Windows.Wifi.Client.Realtek.Rtl8192se~~~~0.0.1.0
    Microsoft.Windows.Wifi.Client.Realtek.Rtl8187se~~~~0.0.1.0
    Microsoft.Windows.Wifi.Client.Ralink.Netr28x~~~~0.0.1.0
    Microsoft.Windows.Wifi.Client.Qualcomm.Qcamain10x64~~~~0.0.1.0
    Microsoft.Windows.Wifi.Client.Qualcomm.Athwnx~~~~0.0.1.0
    Microsoft.Windows.Wifi.Client.Qualcomm.Athw8x~~~~0.0.1.0
    Microsoft.Windows.Wifi.Client.Marvel.Mrvlpcie8897~~~~0.0.1.0
    Microsoft.Windows.Wifi.Client.Intel.Netwtw10~~~~0.0.1.0
    Microsoft.Windows.Wifi.Client.Intel.Netwtw08~~~~0.0.1.0
    Microsoft.Windows.Wifi.Client.Intel.Netwtw06~~~~0.0.1.0
    Microsoft.Windows.Wifi.Client.Intel.Netwtw04~~~~0.0.1.0
    Microsoft.Windows.Wifi.Client.Intel.Netwtw02~~~~0.0.1.0
    Microsoft.Windows.Wifi.Client.Intel.Netwsw00~~~~0.0.1.0
    Microsoft.Windows.Wifi.Client.Intel.Netwns64~~~~0.0.1.0
    Microsoft.Windows.Wifi.Client.Intel.Netwew01~~~~0.0.1.0
    Microsoft.Windows.Wifi.Client.Intel.Netwew00~~~~0.0.1.0
    Microsoft.Windows.Wifi.Client.Intel.Netwbw02~~~~0.0.1.0
    Microsoft.Windows.Wifi.Client.Broadcom.Bcmwl63a~~~~0.0.1.0
    Microsoft.Windows.Wifi.Client.Broadcom.Bcmwl63al~~~~0.0.1.0
    Microsoft.Windows.Wifi.Client.Broadcom.Bcmpciedhd63~~~~0.0.1.0
    # ethernet
    #Microsoft.Windows.Ethernet.Client.Vmware.Vmxnet3~~~~0.0.1.0    # VM?
    Microsoft.Windows.Ethernet.Client.Realtek.Rtcx21x64~~~~0.0.1.0
    Microsoft.Windows.Ethernet.Client.Intel.E2f68~~~~0.0.1.0
    Microsoft.Windows.Ethernet.Client.Intel.E1i68x64~~~~0.0.1.0