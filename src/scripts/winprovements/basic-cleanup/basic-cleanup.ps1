# Basic Cleanup first plan // cleaup-potion
# SRC: https://privacy.sexy/


#### [ STORAGE ]
## Basic Cleanup, remove temp files
####

# Features
dism /Online /Disable-Feature /FeatureName:"DirectPlay" /NoRestart
dism /Online /Disable-Feature /FeatureName:"LegacyComponents" /NoRestart
dism /Online /Disable-Feature /FeatureName:"MediaPlayback" /NoRestart
dism /Online /Disable-Feature /FeatureName:"ScanManagementConsole" /NoRestart
dism /Online /Disable-Feature /FeatureName:"FaxServicesClientPackage" /NoRestart
dism /Online /Disable-Feature /FeatureName:"WindowsMediaPlayer" /NoRestart /Remove
dism /Online /Disable-Feature /FeatureName:"SearchEngine-Client-Package" /NoRestart
dism /Online /Disable-Feature /FeatureName:"TelnetClient" /NoRestart
dism /Online /Disable-Feature /FeatureName:"WCF-TCP-PortSharing45" /NoRestart
dism /Online /Disable-Feature /FeatureName:"SmbDirect" /NoRestart
dism /Online /Disable-Feature /FeatureName:"TFTP" /NoRestart
dism /Online /Disable-Feature /FeatureName:"Microsoft-Hyper-V-All" /NoRestart
dism /Online /Disable-Feature /FeatureName:"Microsoft-Hyper-V-Management-Clients" /NoRestart
dism /Online /Disable-Feature /FeatureName:"Microsoft-Hyper-V-Tools-All" /NoRestart
dism /Online /Disable-Feature /FeatureName:"Microsoft-Hyper-V-Management-PowerShell" /NoRestart
dism /Online /Disable-Feature /FeatureName:"Printing-Foundation-Features" /NoRestart
dism /Online /Disable-Feature /FeatureName:"WorkFolders-Client" /NoRestart
dism /Online /Disable-Feature /FeatureName:"Printing-Foundation-InternetPrinting-Client" /NoRestart
dism /Online /Disable-Feature /FeatureName:"LPDPrintService" /NoRestart
dism /Online /Disable-Feature /FeatureName:"Printing-Foundation-LPRPortMonitor" /NoRestart
dism /Online /Disable-Feature /FeatureName:"Printing-XPSServices-Features" /NoRestart
dism /Online /Disable-Feature /FeatureName:"Xps-Foundation-Xps-Viewer" /NoRestart

dism /Online /Disable-Feature /FeatureName:"Internet-Explorer-Optional-x64" /NoRestart
dism /Online /Disable-Feature /FeatureName:"Internet-Explorer-Optional-x84" /NoRestart
dism /Online /Disable-Feature /FeatureName:"Internet-Explorer-Optional-amd64" /NoRestart

# Capabilities
Get-WindowsCapability -Online -Name 'Rsat.FailoverCluster.Management.Tools*' | Remove-WindowsCapability -Online
Get-WindowsCapability -Online -Name 'Rsat.Dns.Tools*' | Remove-WindowsCapability -Online
Get-WindowsCapability -Online -Name 'Rsat.DHCP.Tools*' | Remove-WindowsCapability -Online
Get-WindowsCapability -Online -Name 'Rsat.BitLocker.Recovery.Tools*' | Remove-WindowsCapability -Online
Get-WindowsCapability -Online -Name 'Print.EnterpriseCloudPrint*' | Remove-WindowsCapability -Online
Get-WindowsCapability -Online -Name 'WMI-SNMP-Provider.Client*' | Remove-WindowsCapability -Online
Get-WindowsCapability -Online -Name 'SNMP.Client*' | Remove-WindowsCapability -Online
Get-WindowsCapability -Online -Name 'RIP.Listener*' | Remove-WindowsCapability -Online
Get-WindowsCapability -Online -Name 'RasCMAK.Client*' | Remove-WindowsCapability -Online
Get-WindowsCapability -Online -Name 'XPS.Viewer*' | Remove-WindowsCapability -Online
Get-WindowsCapability -Online -Name 'Accessibility.Braille*' | Remove-WindowsCapability -Online
Get-WindowsCapability -Online -Name 'Analog.Holographic.Desktop*' | Remove-WindowsCapability -Online
Get-WindowsCapability -Online -Name 'Print.Fax.Scan*' | Remove-WindowsCapability -Online
Get-WindowsCapability -Online -Name 'App.StepsRecorder*' | Remove-WindowsCapability -Online
Get-WindowsCapability -Online -Name 'App.Support.QuickAssist*' | Remove-WindowsCapability -Online"
Get-WindowsCapability -Online -Name 'Print.Management.Console*' | Remove-WindowsCapability -Online"
Get-WindowsCapability -Online -Name 'Browser.InternetExplorer*' | Remove-WindowsCapability -Online



echo "Clear volume backups (shadow copies)"
vssadmin delete shadows /all /quiet

echo "Clear thumbnail cache"
del /f /s /q /a %LocalAppData%\Microsoft\Windows\Explorer\*.db

echo "Clear Windows temp files"
del /f /q %localappdata%\Temp\*
rd /s /q "%WINDIR%\Temp"
rd /s /q "%TEMP%"

echo "Clear Event Logs in Event Viewer"
## CAN BE UNSAFE
## REF: https://social.technet.microsoft.com/Forums/en-US/f6788f7d-7d04-41f1-a64e-3af9f700e4bd/failed-to-clear-log-microsoftwindowsliveidoperational-access-is-denied?forum=win10itprogeneral
wevtutil sl Microsoft-Windows-LiveId/Operational /ca:O:BAG:SYD:(A;;0x1;;;SY)(A;;0x5;;;BA)(A;;0x1;;;LA)
for /f "tokens=*" %%i in ('wevtutil.exe el') DO (
    echo Deleting event log: "%%i"
    wevtutil.exe cl %1 "%%i"
)

echo "Clean Windows Defender scan history"
del "%ProgramData%\Microsoft\Windows Defender\Scans\History\" /s /f /q

echo "Clear Optional Component Manager and COM+ components logs"
del /f /q %SystemRoot%\comsetup.log

echo "Clear Distributed Transaction Coordinator logs"
del /f /q %SystemRoot%\DtcInstall.log

echo "Clear Windows Deployment Upgrade Process Logs"
del /f /q %SystemRoot%\setupact.log
del /f /q %SystemRoot%\setuperr.log

echo "Clear Windows Setup Logs"
del /f /q %SystemRoot%\setupapi.log
del /f /q %SystemRoot%\Panther\*
del /f /q %SystemRoot%\inf\setupapi.app.log
del /f /q %SystemRoot%\inf\setupapi.dev.log
del /f /q %SystemRoot%\inf\setupapi.offline.log

echo "Clear user web cache database"
del /f /q %localappdata%\Microsoft\Windows\WebCache\*.*

echo "Clear system temp folder when no one is logged in"
# Unsafe?
del /f /q %SystemRoot%\ServiceProfiles\LocalService\AppData\Local\Temp\*.*

echo "Clear DISM (Deployment Image Servicing and Management) Logs"
del /f /q  %SystemRoot%\Logs\CBS\CBS.log
del /f /q  %SystemRoot%\Logs\DISM\DISM.log

echo "Clear WUAgent (Windows Update History) logs"
setlocal EnableDelayedExpansion 
    SET /A wuau_service_running=0
    SC queryex "wuauserv"|Find "STATE"|Find /v "RUNNING">Nul||(
        SET /A wuau_service_running=1
        net stop wuauserv
    )
    del /q /s /f "%SystemRoot%\SoftwareDistribution"
    IF !wuau_service_running! == 1 (
        net start wuauserv
    )
endlocal

echo "Clear Server-initiated Healing Events Logs"
del /f /q "%SystemRoot%\Logs\SIH\*"

echo "Common Language Runtime Logs"
del /f /q "%LocalAppData%\Microsoft\CLR_v4.0\UsageTraces\*"
del /f /q "%LocalAppData%\Microsoft\CLR_v4.0_32\UsageTraces\*"

echo "Disk Cleanup tool (Cleanmgr.exe) Logs"
del /f /q "%SystemRoot%\System32\LogFiles\setupcln\*"

echo "Clear Windows update and SFC scan logs"
del /f /q %SystemRoot%\Temp\CBS\*

echo "Clear Windows Update Medic Service logs"
takeown /f %SystemRoot%\Logs\waasmedic /r /d y
icacls %SystemRoot%\Logs\waasmedic /grant administrators:F /t
rd /s /q %SystemRoot%\Logs\waasmedic

echo "Clear previous Windows installations"
if exist "%SystemDrive%\Windows.old" (
    takeown /f "%SystemDrive%\Windows.old" /a /r /d y
    icacls "%SystemDrive%\Windows.old" /grant administrators:F /t
    rd /s /q "%SystemDrive%\Windows.old"
    echo Deleted previous installation from "%SystemDrive%\Windows.old\"
)  else (
    echo No previous Windows installation has been found
)

#### [ PRIVACY ]
## Removing Traces of Use
####

echo "Clear Windows Run MRU & typedpaths"
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\RunMRU" /va /f
reg delete "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\TypedPaths" /va /f

echo "Clear recently accessed files"
del /f /q "%APPDATA%\Microsoft\Windows\Recent\AutomaticDestinations\*"

echo "Clear user pins"
del /f /q "%APPDATA%\Microsoft\Windows\Recent\CustomDestinations\*"

echo "Clear thumbnail cache"
# STORAGE?
del /f /s /q /a %LocalAppData%\Microsoft\Windows\Explorer\*.db

echo "Clear main telemetry file"
if exist "%ProgramData%\Microsoft\Diagnosis\ETLLogs\AutoLogger\AutoLogger-Diagtrack-Listener.etl" (
    takeown /f "%ProgramData%\Microsoft\Diagnosis\ETLLogs\AutoLogger\AutoLogger-Diagtrack-Listener.etl" /r /d y
    icacls "%ProgramData%\Microsoft\Diagnosis\ETLLogs\AutoLogger\AutoLogger-Diagtrack-Listener.etl" /grant administrators:F /t
    echo "" > "%ProgramData%\Microsoft\Diagnosis\ETLLogs\AutoLogger\AutoLogger-Diagtrack-Listener.etl"
    echo Clear successful: "%ProgramData%\Microsoft\Diagnosis\ETLLogs\AutoLogger\AutoLogger-Diagtrack-Listener.etl"
) else (
    echo "Main telemetry file does not exist. Good!"
)

echo "Clear (Reset) Network Data Usage"
setlocal EnableDelayedExpansion 
    SET /A dps_service_running=0
    SC queryex "DPS"|Find "STATE"|Find /v "RUNNING">Nul||(
        SET /A dps_service_running=1
        net stop DPS
    )
    del /F /S /Q /A "%windir%\System32\sru*"
    IF !dps_service_running! == 1 (
        net start DPS
    )
endlocal


echo "Clear Pending File Rename Operations logs"
del /f /q %SystemRoot%\PFRO.log

echo "Clear Windows System Assessment Tool logs"
del /f /q %SystemRoot%\Performance\WinSAT\winsat.log

echo "Clear Password change events"
del /f /q %SystemRoot%\debug\PASSWD.LOG

echo "Network Setup Service Events Logs"
del /f /q "%SystemRoot%\Logs\NetSetup\*"

echo "Clear Cryptographic Services Traces"
del /f /q %SystemRoot%\System32\catroot2\dberr.txt
del /f /q %SystemRoot%\System32\catroot2.log
del /f /q %SystemRoot%\System32\catroot2.jrs
del /f /q %SystemRoot%\System32\catroot2.edb
del /f /q %SystemRoot%\System32\catroot2.chk


echo "Windows Update Events Logs"
# Storage? 
del /f /q "%SystemRoot%\Logs\SIH\*"

echo "Windows Update Logs"
del /f /q "%SystemRoot%\Traces\WindowsUpdate\*"

echo "Delete controversial default0 user"
# What is this?
net user defaultuser0 /delete 2>nul

echo "Enable Reset Base in Dism Component Store ???"
# WHAT THE HELL IS THIS?
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\SideBySide\Configuration" /v "DisableResetbase" /t "REG_DWORD" /d "0" /f

echo "Clear Windows Product Key from Registry"
## WHY?
cscript.exe //nologo "%SystemRoot%\system32\slmgr.vbs" /cpky

echo "Remove Default Apps Associations"
# WHY? 
dism /online /Remove-DefaultAppAssociations


