# 

$setStartupTyepe = "Disabled" # Disabled, Automatic

echo "===== ====="
echo "DISABLE SERVICES"
echo "===== ====="


# PRINTING SERVICE

Write-Host "`n Disable Printer Services?" -ForegroundColor Cyan

Get-Service Spooler
echo "`nDESCRIPTION:`n----------`nThis service spools print jobs and handles interaction with the printer.  If you turn off this service, you won’t be able to print or see your printers."
echo ""
$confirmation = Read-Host "Disable: y | Skip: n | Y/n"
echo ""

if ($confirmation -eq 'y') {
    Write-Host "Service stopped and Disabled" -ForegroundColor Green
    Stop-Service Spooler
    Set-Service Spooler -StartupType $setStartupTyepe
} else {
    Write-Host "Skip" -ForegroundColor Red
}


# REMOTE PRICEDURE CALL (RPC) ?
# RPC ENDPOINT MAPPER ?

# SYSTEM EVENT NOTIFICATION SERVICE ?

# THEMES
#echo "Disable: Themes"
#Stop-Service Themes
#Set-Service Themes -StartupType Disabled

# DOWNLOADED MAPS MANAGER

# ONESYNC SVC 
# This service synchronizes mail, contacts, calendar and various other user data.
#Stop-Service OneSyncSvc_45dd6
#Set-Service OneSyncSvc_45dd6 -StartupType Disabled

# USO SVC
# Manages Windows Updates. If stopped, your devices will not be able to download and install the latest updates.
#Get-Service UsoSvc

# WSEARCH !!!
# Provides content indexing, property caching, and search results for files, e-mail, and other content
Stop-Service WSearch
Set-Service WSearch -StartupType Disabled

# CDPSVC !!!
# This service is used for Connected Devices Platform scenarios
Stop-Service CDPSvc
Set-Service CDPSvc -StartupType Disabled

# DELIVERY OPTIMIZATION ???
Get-Service DoSvc
# STORAGE SERVICE
Get-Service StorSvc
# GRPUP POLICY SERVICE
# 
Get-Service gpsvc

# LAN, FILE, ...ETC SHARE
Get-Service LanmanServer

# SYSTEM EVENT BROKER
# Coordinates execution of background work for WinRT application. If this service is stopped or disabled, then background work might not be triggered.
Get-Service SystemEventsBroker

# APPLICATION MANAGEMENT
# Processes installation, removal, and enumeration requests for software deployed through Group Policy. If the service is disabled, users will be unable to install, remove, or enumerate software deployed through Group Policy. If this service is disabled, any services that explicitly depend on it will fail to start.
Get-Service AppMgmt

# BITS
# Transfers files in the background using idle network bandwidth. If the service is disabled, then any applications that depend on BITS, such as Windows Update or MSN Explorer, will be unable to automatically download programs and other information.
Get-Service BITS

# SCREEN CAPTURE SERVICE !! (Security optional)
# Enables optional screen capture functionality for applications that call the Windows.Graphics.Capture API.
Get-Service CaptureService_45dd6

# DIAGNOSTIC SERIVCE HOST (if you don't use windows service diagnostic)
# The Diagnostic Service Host is used by the Diagnostic Policy Service to host diagnostics that need to run in a Local Service context.  If this service is stopped, any diagnostics that depend on it will no longer function.
Get-Service WdiServiceHost

# DIAGNOSTIC SYSTEM HOST (if you don't use windows diagnostic service)
# The Diagnostic System Host is used by the Diagnostic Policy Service to host diagnostics that need to run in a Local System context.  If this service is stopped, any diagnostics that depend on it will no longer function.
Get-Service WdiSystemHost

# BLOCK LEVEL BACKUP ENGINE (if you not use windows backup engine)
# The WBENGINE service is used by Windows Backup to perform backup and1 recovery operations. If this service is stopped by a user, it may cause the currently running backup or recovery operation to fail. Disabling this service may disable backup and recovery operations using Windows Backup on this computer.
Get-Service wbengine
Stop-Service wbengine
Set-Service wbengine -StartupType Disabled

# GAME RECORDING AND LIVE BROADCASTS SERVICE (security optional)
# This user service is used for Game Recordings and Live Broadcasts
Get-Service BcastDVRUserService_45dd6

# Maybe restert if wrong network??? // Manual, not running
Get-Service lltdsvc

# MICROSOFT DIAGNOSTICS HUB
# Diagnostics Hub Standard Collector Service. When running, this service collects real time ETW events and processes them.
#Get-Service diagnosticshub.standardcollector.service
#Stop-Service diagnosticshub.standardcollector.service
#Set-Service diagnosticshub.standardcollector.service -StartupType Disabled

# MICROSOFT iSCSi TARGET SERVICE
Get-Service MSiSCSI

# MICROSOFT SOFTWARE SHADOW COPY PROVIDER
# Manages software-based volume shadow copies taken by the Volume Shadow Copy service. If this service is stopped, software-based volume shadow copies cannot be managed. If this service is disabled, any services that explicitly depend on it will fail to start.
Get-Service swprv

#echo "Disable: Fax service"
#Stop-Service Fax
#Set-Service Fax -StartupType Disabled

# MICROSOFT STORE INSTALL SERVICE (optional - if not using Microsoft Store, and Microsoft Store apps ) // RUNNING!!! 
# Provides infrastructure support for the Microsoft Store.  This service is started on demand and if disabled then installations will not function properly.
echo "Disable: InstallService"
Stop-Service InstallService
Set-Service InstallService -StartupType Disabled

# PERFORMANCE LOGS AND ALERTS COLLECTS 
# Performance Logs and Alerts Collects performance data from local or remote computers based on preconfigured schedule parameters, then writes the data to a log or triggers an alert. If this service is stopped, performance information will not be collected. If this service is disabled, any services that explicitly depend on it will fail to start.
echo "Disable: pla service"
Stop-Service pla
Set-Service pla -StartupType Disabled

#echo "Disable: PrintNotify service"
# This service opens custom printer dialog boxes and handles notifications from a remote print server or a printer. If you turn off this service, you won’t be able to see printer extensions or notifications.
#Stop-Service PrintNotify
#Set-Service PrintNotify -StartupType Disabled

# Provides support for Print Workflow applications. If you turn off this service, you may not be able to print successfully.
#echo "Disable: ProntWorkflow service"
#Stop-Service PrintWorkflowUserSvc_45dd6
#Set-Service PrintWorkflowUserSvc_45dd6 -StartupType Disabled

# PROBLEM REPORTS CONTROL PANEL SUPPORT
# This service provides support for viewing, sending and deletion of system-level problem reports for the Problem Reports control panel.
#echo "Disable: system-level problem reports"
#Stop-Service wercplsupport
#Set-Service wercplsupport -StartupType Disabled

# RADIO MANAGEMENT SERVICE // RUNNING
# Radio Management and Airplane Mode Service 
#echo "Disable: "
#Stop-Service RmSvc
#Set-Service RmSvc -StartupType Disabled

# RECOMMENDED TROUBLESHOOTING SERVICE PROPERTIES
# Enables automatic mitigation for known problems by applying recommended troubleshooting. If stopped, your device will not get recommended troubleshooting for problems on your device.
Get-Service TroubleshootingSvc


# REMOTE ACCESS AUTO CONNECTION MANAGEMENT PROPERTIES
# Creates a connection to a remote network whenever a program references a remote DNS or NetBIOS name or address.
Get-Service RasAuto


# REMOTE DESKTOP CONFIGURATION PROPERTIES (security - if not using remote desktop)
# 
#Get-Service SessionEnv


# REMOTE DESKTOP SERVICE (security - if not using remote desktop on this client)
#echo "Disable: TermService"
#Stop-Service TermService
#Set-Service TermService -StartupType Disabled

# REMOTE DESKTOP SERVICE USERMOD PORT REDIRECTOR
# Allows the redirection of Printers/Drives/Ports for RDP connections
#echo "Disable: UmRdpService"
#Stop-Service UmRdpService
#Set-Service UmRdpService -StartupType Disabled

#echo "NICKNAME: REMOTE PROCEDURE CALL (RPC) LOCAL PROPERTIES"
#echo "DESCRIPTION: In Windows 2003 and earlier versions of Windows, the Remote Procedure Call (RPC) Locator service manages the RPC name service database. In Windows Vista and later versions of Windows, this service does not provide any functionality and is present for application compatibility."
#echo "Disable: RpcLocator"
#Stop-Service RpcLocator
#Set-Service RpcLocator -StartupType Disabled

# ??? DE NEM HANGZIK JÓL!!! UTÁNANÉZNI!!!
echo "NICKNAME: Secondary Logon Properties (Local Computer)"
echo "DESCRIPTION: Enables starting processes under alternate credentials. If this service is stopped, this type of logon access will be unavailable. If this service is disabled, any services that explicitly depend on it will fail to start."
Get-Service seclogon
Stop-Service seclogon
Set-Service seclogon -StartupType Disabled

#echo "NICKNAME: User Data Access_45dd6 Properties // MICROSOFT CALENDAR"
#echo "DESCRIPTION: Provides apps access to structured user data, including contact info, calendars, messages, and other content. If you stop or disable this service, apps that use this data might not work correctly."
#Get-Service UserDataSvc_45dd6
#Stop-Service UserDataSvc_45dd6
#Set-Service UserDataSvc_45dd6 -StartupType Disabled

#echo "NICKNAME: User Data Storage_45dd6 Properties // MICROSOFT CALENDAR!!!"
#echo "DESCRIPTION: Handles storage of structured user data, including contact info, calendars, messages, and other content. If you stop or disable this service, apps that use this data might not work correctly."
#Get-Service UnistoreSvc_45dd6
#Stop-Service UnistoreSvc_45dd6
#Set-Service UnistoreSvc_45dd6 -StartupType Disabled

#echo "NICKNAME: Windows Event Collector Properties (Local Machine)"
#echo "DESCRIPTION: This service manages persistent subscriptions to events from remote sources that support WS-Management protocol. This includes Windows Vista event logs, hardware and IPMI-enabled event sources. The service stores forwarded events in a local Event Log. If this service is stopped or disabled event subscriptions cannot be created and forwarded events cannot be accepted."
#Get-Service Wecsvc
#Stop-Service Wecsvc
#Set-Service Wecsvc -StartupType Disabled

#Get-Service diagsvc
#echo "DESCRIPTION: Executes diagnostic actions for troubleshooting support"
#Stop-Service diagsvc
#Set-Service diagsvc -StartupType Disabled

Get-Service embeddedmode

# SECURITY? 
echo "Publishes this computer and resources attached to this computer so they can be discovered over the network.  If this service is stopped, network resources will no longer be published and they will not be discovered by other computers on the network."
Get-Service FDResPub

# SECURITY - GEOLOCATION
#echo "DESCRIPTION: This service monitors the current location of the system and manages geofences (a geographical location with associated events).  If you turn off this service, applications will be unable to use or receive notifications for geolocation or geofences."
#Get-Service lfsvc

# SECURITY - REMOTE CONTROL ?
Get-Service hidserv
echo "DESCRIPTION: Activates and maintains the use of hot buttons on keyboards, remote controls, and other multimedia devices. It is recommended that you keep this service running."

# HYPER-V DISABLE!!! ? 

# Network Connection Broker Properties
# Brokers connections that allow Windows Store Apps to receive notifications from the internet.
Get-Service NcbService

echo "NICKNAME: "
echo "DESCRIPTION: Routes messages based on rules to appropriate clients."
Get-Service SmsRouter
Stop-Service SmsRouter
Set-Service SmsRouter -StartupType Disabled

#echo "NICKNAME: Payment and NFC/SE Manager Properties"
#echo "DESCRIPTION: Manages payments and Near Field Communication (NFC) based secure elements."
#Get-Service SEMgrSvc
#Stop-Service SEMgrSvc
#Set-Service SEMgrSvc -StartupType Disabled

echo "NICKNAME: "
echo "DESCRIPTION: Manages the telephony state on the device"
Get-Service PhoneSvc
Stop-Service PhoneSvc
Set-Service PhoneSvc -StartupType Disabled

#echo "NICKNAME: "
#echo "DESCRIPTION:`n----------`nManages the telephony state on the device"
#Get-Service SensorDataService
#Stop-Service SensorDataService
#Set-Service SensorDataService -StartupType Disabled

#Get-Service WbioSrvc # SMART CARD
#echo "DESCRIPTION:`n----------`nManages access to smart cards read by this computer. If this service is stopped, this computer will be unable to read smart cards. If this service is disabled, any services that explicitly depend on it will fail to start."
#Stop-Service WbioSrvc
#Set-Service WbioSrvc -StartupType Disabled

#Get-Service ScDeviceEnum # SMART CARD
#echo "DESCRIPTION:`n----------`nCreates software device nodes for all smart card readers accessible to a given session. If this service is disabled, WinRT APIs will not be able to enumerate smart card readers."
#Stop-Service ScDeviceEnum
#Set-Service ScDeviceEnum -StartupType Disabled

#Get-Service TabletInputService
#echo "DESCRIPTION:`n----------`nEnables Touch Keyboard and Handwriting Panel pen and ink functionality"
#Stop-Service TabletInputService
#Set-Service TabletInputService -StartupType Disabled

Get-Service WarpJITSvc
echo "DESCRIPTION:`n----------`nProvides a JIT out of process service for WARP when running with ACG enabled."
Stop-Service WarpJITSvc
Set-Service WarpJITSvc -StartupType Disabled

Get-Service WebClient


# CAMERA
#Get-Service FrameServer
#echo "DESCRIPTION:`n----------`nEnables multiple clients to access video frames from camera devices."
#Stop-Service FrameServer
#Set-Service FrameServer -StartupType Disabled


# WIN ERROR REPORTING SERVICE
#Get-Service WerSvc
#echo "DESCRIPTION:`n----------`nAllows errors to be reported when programs stop working or responding and allows existing solutions to be delivered. Also allows logs to be generated for diagnostic and repair services. If this service is stopped, error reporting might not work correctly and results of diagnostic services and repairs might not be displayed."
#Stop-Service WerSvc
#Set-Service WerSvc -StartupType Disabled

# WINDOWS MOBILE HOTSPOT SERVICE
#Get-Service icssvc
#echo "DESCRIPTION:`n----------`n"
#Stop-Service icssvc
#Set-Service icssvc -StartupType Disabled

# HOLOGRAPHIC SZARSÁG? 
#Get-Service spectrum
#echo "DESCRIPTION:`n----------`nEnables spatial perception, spatial input, and holographic rendering."
#Stop-Service spectrum
#Set-Service spectrum -StartupType Disabled

# WINDOWS UPDATE ? 
echo "NICKNAME: Windows Update Medic Service Properties"
echo "DESCRIPTION: Enables remediation and protection of Windows Update components."
Get-Service WaaSMedicSvc
Stop-Service WaaSMedicSvc
Set-Service WaaSMedicSvc -StartupType Disabled

# WIN UPDATE? 
# PUSH TO INSTALL SERVICE
Get-Service PushToInstall
echo "DESCRIPTION:`n----------`nProvides infrastructure support for the Microsoft Store.  This service is started automatically and if disabled then remote installations will not function properly."
Stop-Service PushToInstall
Set-Service PushToInstall -StartupType Disabled

# WINDOWS UPDATE
Get-Service wuauserv
echo "DESCRIPTION:`n----------`nEnables the detection, download, and installation of updates for Windows and other programs. If this service is disabled, users of this computer will not be able to use Windows Update or its automatic updating feature, and programs will not be able to use the Windows Update Agent (WUA) API."
Stop-Service wuauserv
Set-Service wuauserv -StartupType Disabled

# XBOX ACCESSORY MANAGEMENT SERVICE
#Get-Service XboxGipSvc
#echo "DESCRIPTION:`n----------`nThis service manages connected Xbox Accessories."
#Stop-Service XboxGipSvc
#Set-Service XboxGipSvc -StartupType Disabled

# XBOX LIVE GAME SAVE PROPERTIES
#Get-Service XblGameSave
#echo "DESCRIPTION:`n----------`nThis service syncs save data for Xbox Live save enabled games.  If this service is stopped, game save data will not upload to or download from Xbox Live."
#Stop-Service XblGameSave
#Set-Service XblGameSave -StartupType Disabled

# LAST
#Get-Service 
#echo "DESCRIPTION:`n----------`n"
#Stop-Service 
#Set-Service  -StartupType Disabled