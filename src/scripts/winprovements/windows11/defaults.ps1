# Windows 11 Default settings
# Run on All device without fear

# DefaultLayouts.xml
# DefaultLAyout C:\Users\mars\AppData\local\Microsoft\Windows\Shell


# DOESNT WORK!
#New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows" -Name "PreviewBuilds"
#Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\PreviewBuilds" -Name " AllowBuildPreview" -Type DWord -Value 0

## ✅ W11
## Show known file extensions
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "HideFileExt" -Type DWord -Value 0

## ✅ W11
## Show hidden files in explorer ## hide: 2
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "Hidden" -Type DWord -Value 1

## ✅ W11
## Change default Explorer view to "Computer" 
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "LaunchTo" -Type DWord -Value 1
## ✅ W11
## Change default Explorer view to "Quick Access"
#Remove-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "LaunchTo"

## ✅ W11
## Replace Search box with button: 0 hide, 1 button, 2 box
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Search" -Name "SearchboxTaskbarMode" -Type DWord -Value 0

## ✅ W11 : Reboot required!
## Disable sticky key - To enable: 510
Set-ItemProperty -Path "HKCU:\Control Panel\Accessibility\StickyKeys" -Name "Flags" -Type String -Value "506"

## ✅ W11 : !!! VM ONLY !!! 
# Disable Optimise Drive: defrag on hdd, trim on ssd, NOT REQUIRED ON VM!
schtasks /Change /DISABLE /TN "\Microsoft\Windows\Defrag\ScheduledDefrag"

## ✅ W11 
## Resize Recycle Bin: 512MB ## ✅ WORK!
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\BitBucket\Volume\*\" -Name "MaxCapacity" -Type DWord -Value 512



Computer\HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\AppModel\StateRepository\Cache\Application\Index\PackageAndPackageRelativeApplicationId\c0^msteamsautostarter

Computer\HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\AppModel\StateRepository\Cache\ApplicationUser\Index\UserAndApplicationUserModelId\3^MicrosoftTeams_8wekyb3d8bbwe!msteamsautostarter