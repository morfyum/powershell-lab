# SERVICE DISABLER
# https://learn.microsoft.com/en-us/windows/iot/iot-enterprise/optimize-your-device/services

$logPath = "C:\Users\$env:USERNAME\Desktop"
$logDate = Get-Date -Format "HHmm-ddMMyyyy"
$logFileName = "log-$logDate.txt"

New-Item -Path "$logPath" -Name "$logFileName" -ItemType "file" -Value "service-disabler log`n===========================`n"

# SERVICE PROCESS NAME
$serviceName = @(
<#01#>    "Spooler"
<#02#>    "PrintNotify"
<#03#>    "PrintWorkflowUserSvc_45dd6"
<#04#>    "Fax"

<#05#>    "TermService"
<#06#>    "SessionEnv"
<#07#>    "UmRdpService"

<#08#>    "Themes"

<#09#>    "OneSyncSvc_45dd6"
<#10#>    "UserDataSvc_45dd6"
<#11#>    "UnistoreSvc_45dd6"

<#12#>    "RpcLocator"

<#13#>    "Wecsvc"
<#14#>    "diagsvc"
<#+1#>    "WerSvc"
<#+2#>    "wercplsupport"
<#+3#>    "diagnosticshub.standardcollector.service"

<#15#>    "lfsvc"

<#16#>    "vmickvpexchange"
<#17#>    "vmicguestinterface"
<#18#>    "vmicshutdown"
<#19#>    "vmicheartbeat"
<#20#>    "vmicvmsession"
<#21#>    "vmicrdv"
<#22#>    "vmictimesync"
<#23#>    "vmicvss"

<#24#>    "SEMgrSvc"
<#25#>    "SensorDataService"
<#26#>    "WbioSrvc"
<#27#>    "ScDeviceEnum"
<#28#>    "TabletInputService"
<#29#>    "FrameServer"
<#30#>    "icssvc"
<#31#>    "spectrum"
<#+1#>    "RmSvc"

<#32#>    "XboxGipSvc"
<#33#>    "XblGameSave"
)

# SERVICE DISPLAYED NAME
$serviceNick = @(
<#01#>    "Print Spooler"
<#02#>    "Printer Extensions and Notifications"
<#03#>    "PrintWorkflow_45dd6"
<#04#>    "Fax"

<#05#>    "Remote Desktop Service"
<#06#>    "Remote Desktop Configuration"
<#07#>    "Remote Desktop Service UserMode Port Redirector"

<#08#>    "Themes"

<#09#>    "Sync Host_45dd6"
<#10#>    "User Data Access_45dd6"
<#11#>    "User Data Storage_45dd6"

<#12#>    "Remote Procedure Call (RPC) Locator"

<#13#>    "Windows Event Collector"
<#14#>    "Diagnostic Execution Service"
<#+1#>    "Windows Error Reporting Service"
<#+2#>    "Problem Reports Control Panel Support"
<#+3#>    "Microsoft Diagnostics Hub Standard Collector Service"

<#15#>    "Geolocation Service"

<#16#>    "Hyper-V Data Exchange Service"
<#17#>    "Hyper-V Guest Service Interface"
<#18#>    "Hyper-V Guest Shutdown Service"
<#19#>    "Hyper-V Heartbeat Service"
<#20#>    "Hyper-V PowerShell Direct Service"
<#21#>    "Hyper-V Remote Desktop Virtualization Service"
<#22#>    "Hyper-V Time Synchronization Service"
<#23#>    "Hyper-V Volume Shadow Copy Requestor"

<#24#>    "Payments and NFC/SE Manager"
<#25#>    "Sensor Data Service"
<#26#>    "Windows Biometric Service"
<#27#>    "Smart Card Device Enumeration Service"
<#28#>    "Touch Keyboard and Handwriting Panel Service"
<#29#>    "Windows Camera Frame Server"
<#30#>    "Windows Mobile Hotspot Service"
<#31#>    "Windows Perception Service"
<#+1#>    "Radio Management service"

<#32#>    "Xbox Accessory Management Service"
<#33#>    "Xbox Live Game Save"
)

# DESCRIPTION WHEN NOT RECOMMENDED TO DISABLE
$serviceUse = @(
<#01#>    "If you disable Printer Services, you cant use printers"
<#02#>    "If you disable Printer Services, you cant use printers"
<#03#>    "If you disable Printer Service, you cant use printers"
<#04#>    "If you disable Fax Services, you cant use Fax"

<#05#>    "If you disable TermService, you cant use: Remote Desktop functions: TeamViewrt, VNC, Steam-Remote-Play, ...etc"
<#06#>    "If you disable SessionEnv, you cant use: Remote Desktop functions: TeamViewr, VNC, Steam-Remote-Play, ...etc"
<#07#>    "Can cause a problem in: Remote Desktop, Port Redirection for Printers, ...etc"

<#08#>    "Unknown: Themes"

<#09#>    "Mail and other applications dependent on this functionality will not work properly when this service is not running."
<#10#>    "If you not using Windows online services: Calendar, accounts, mail, ...etc."
<#11#>    "If you not using Windows online services: Calendar, accounts, mail, ...etc."

<#12#>    "If you not using Windows 2003 or earlier version of Windows It won't be a problem."

<#13#>    "If you doesn't need windows logs, and Troubleshooting tools"
<#14#>    "If you doesn't need windows logs, and Troubleshooting tools"
<#+1#>    "If you doesn't need windows logs, and Troubleshooting tools"
<#+2#>    "If you doesn't need windows logs, and Troubleshooting tools"
<#+3#>    "If you doesn't need windows logs, and Troubleshooting tools"

<#15#>    "If you doesn't need geolocation for applications: Windows Map"

<#16#>    "If you doesn't use Hyper-V, Virtual Machines"
<#17#>    "If you doesn't use Hyper-V, Virtual Machines"
<#18#>    "If you doesn't use Hyper-V, Virtual Machines"
<#19#>    "If you doesn't use Hyper-V, Virtual Machines"
<#20#>    "If you doesn't use Hyper-V, Virtual Machines"
<#21#>    "If you doesn't use Hyper-V, Virtual Machines"
<#22#>    "If you doesn't use Hyper-V, Virtual Machines"
<#23#>    "If you doesn't use Hyper-V, Virtual Machines"

<#24#>    "If you not use NFC services"
<#25#>    "If you not using Device Sensors: gyroscope"
<#26#>    "If you not using Windows Biometric devices: fingerprint"
<#27#>    "If you not use Smart Card devices"
<#28#>    "If you not using Touch keyboard, or handwriting service"
<#29#>    "If you not using Web Camera"
<#30#>    "If you using your device as Hotspot"
<#31#>    "If you not using holographic devices"
<#+1#>    "If you not using Radio services"

<#32#>    "If you not using Xbox services: game pass, live, ...etc"
<#33#>    "If you not using Xbox services: game pass, live, ...etc"
)

# PROPOSAL TO DISABLE OR NOT
$serviceProposal = @(
<#01#>    "Recommended - if not using printer"
<#02#>    "Recommended - if not using printer"
<#03#>    "Recommended - if not using printer"
<#04#>    "Recommended - if not using fax"

<#05#>    "Recommended - if not using Remote Desktop functions"
<#06#>    "Recommended - if not using Remote Desktop functions"
<#07#>    "Unkonwn - maybe OK,"

<#08#>    "Unknown - Themes"

<#09#>    "Unknown - if not using Windows: Calendar, OneDrive, Mail, or similar online service"
<#10#>    "Unknown - if not using Windows: Calendar, OneDrive, Mail, or similar online service"
<#11#>    "Unknown - if not using Windows: Calendar, OneDrive, Mail, or similar online service"

<#12#>    "Recommended - If not using earlier version of windows 2003"

<#13#>    "Recommended - If not using Windows Logs, and Troubleshooting tools"
<#14#>    "Recommended - If not using Windows Logs, and Troubleshooting tools"
<#+1#>    "Recommended - If not using Windows Logs, and Troubleshooting tools"
<#+2#>    "Recommended - If not using Windows Logs, and Troubleshooting tools"
<#+3#>    "Recommended - If not using Windows Logs, and Troubleshooting tools"

<#15#>    "Recommended - If you not using Windows Maps, or geolocation needed applications"

<#16#>    "Recommended - If not using Hyper-V"
<#17#>    "Recommended - If not using Hyper-V"
<#18#>    "Recommended - If not using Hyper-V"
<#19#>    "Recommended - If not using Hyper-V"
<#20#>    "Recommended - If not using Hyper-V"
<#21#>    "Recommended - If not using Hyper-V"
<#22#>    "Recommended - If not using Hyper-V"
<#23#>    "Recommended - If not using Hyper-V"

<#24#>    "Recommended - If not using NFC payment service."
<#25#>    "Recommended - If not using Windows on Moblie/Tablet."
<#26#>    "Recommended - If not using Biometric services."
<#27#>    "Recommended - If not using Smart Cards."
<#28#>    "Recommended - If not using Touch Keyboard and/or Handwriting devices."
<#29#>    "Recommended - If not using Camera."
<#30#>    "Recommended - If you not using your system as Hotspot."
<#31#>    "Recommended - If you not using holographics future s*t."
<#+1#>    "Recommended - If not using mobile radio services"

<#32#>    "If you not using Xbox services: game pass, live, ...etc"
<#33#>    "If you not using Xbox services: game pass, live, ...etc"
)

# SERVICE TYPE
$serviceType = @(
<#01#>    "Printers"
<#02#>    "Printers"
<#03#>    "Printers"
<#04#>    "Fax"

<#05#>    "Remote Desktop"
<#06#>    "Remote Desktop"
<#07#>    "Remote Desktop & Printers Port Redirector"

<#08#>    "Themes"

<#09#>    "Online Account"
<#10#>    "Online Account"
<#11#>    "Online Account"

<#12#>    "RPC"

<#13#>    "Windows Bug report system"
<#14#>    "Windows Bug report system"
<#+1#>    "Windows Bug report system"
<#+2#>    "Windows Bug report system"
<#+3#>    "Windows Bug report system"

<#15#>    "Privacy"

<#16#>    "HYPER-V Virtualization"
<#17#>    "HYPER-V Virtualization"
<#18#>    "HYPER-V Virtualization"
<#19#>    "HYPER-V Virtualization"
<#20#>    "HYPER-V Virtualization"
<#21#>    "HYPER-V Virtualization"
<#22#>    "HYPER-V Virtualization"
<#23#>    "HYPER-V Virtualization"

<#24#>    "Mobile/Tablet: Payments"
<#25#>    "Mobile/Tablet: Sensor Data"
<#26#>    "Mobile/Tablet: Biometric"
<#27#>    "Mobile/Tablet: Smart Card"
<#28#>    "Mobile/Tablet: Touch and Gestures"
<#29#>    "Mobile/Tablet: Camera"
<#30#>    "Mobile/Tablet: Mobile Hotspot"
<#31#>    "Mobile/Tablet: Perception"
<#+1#>    "Mobile/Tablet: Radio Management"

<#32#>    "Xbox Service"
<#33#>    "Xbox Service"
)

# SERVICE DESCRIPTION
$serviceDesc= @(
<#01#>    "This service spools print jobs and handles interaction with the printer.  If you turn off this service, you won’t be able to print or see your printers."
<#02#>    "This service spools print jobs and handles interaction with the printer.  If you turn off this service, you won’t be able to print or see your printers."
<#03#>    "Provides support for Print Workflow applications. If you turn off this service, you may not be able to print successfully."
<#04#>    "Enables you to send and receive faxes, utilizing fax resources available on this computer or on the network."

<#05#>    "Allows users to connect interactively to a remote computer, Remote Desktop and Remote Desktop Session Host Server depend on this service. To prevent remote use of this computer, clear the checkbox on the Remote tab of the System poperties control panel item."
<#06#>    "Remote Desktop Configuration service (RDCS) is responsible for all Remote Desktop Services and Remote Desktop related configuration and session maintenance activities that require SYSTEM contex. These include per-session temporary folders, RD themes, and RD certificates."
<#07#>    "Allows the redirection of Printers/Drives/Ports for RDP connections"

<#08#>    "Provides user experience theme management."

<#09#>    "This service synchronizes mail, contacts, calendar and various other user data. Mail and other applications dependent on this functionality will not work properly when this service is not running."
<#10#>    "Provides apps access to structured user data, including contact info, calendars, messages, and other content. If you stop or disable this service, apps that use this data might not work correctly."
<#11#>    "Handles storage of structured user data, including contact info, calendars, messages, and other content. If you stop or disable this service, apps that use this data might not work correctly."

<#12#>    "In Windows 2003 and earlier versions of Windows, the Remote Procedure Call (RPC) Locator service manages the RPC name service database. In Windows Vista and later versions of Windows, this service does not provide any functionality and is present for application compatibility."

<#13#>    "This service manages persistent subscriptions to events from remote sources that support WS-Management protocol. This includes Windows Vista event logs, hardware and IPMI-enabled event sources. The service stores forwarded events in a local Event Log. If this service is stopped or disabled event subscriptions cannot be created and forwarded events cannot be accepted."
<#14#>    "Executes diagnostic actions for troubleshooting support"
<#+1#>    "Allows errors to be reported when programs stop working or responding and allows existing solutions to be delivered. Also allows logs to be generated for diagnostic and repair services. If this service is stopped, error reporting might not work correctly and results of diagnostic services and repairs might not be displayed."
<#+2#>    "This service provides support for viewing, sending and deletion of system-level problem reports for the Problem Reports control panel."
<#+3#>    "Diagnostics Hub Standard Collector Service. When running, this service collects real time ETW events and processes them."

<#15#>    "This service monitors the current location of the system and manages geofences (a geographical location with associated events).  If you turn off this service, applications will be unable to use or receive notifications for geolocation or geofences."

<#16#>    "Provides a mechanism to exchange data between the virtual machine and the operating system running on the physical computer."
<#17#>    "Provides an interface for the Hyper-V host to interact with specific services running inside the virtual machine."
<#18#>    "Provides a mechanism to shut down the operating system of this virtual machine from the management interfaces on the physical computer."
<#19#>    "Monitors the state of this virtual machine by reporting a heartbeat at regular intervals. This service helps you identify running virtual machines that have stopped responding."
<#20#>    "Provides a mechanism to manage virtual machine with PowerShell via VM session without a virtual network"
<#21#>    "Provides a platform for communication between the virtual machine and the operating system running on the physical computer."
<#22#>    "Synchronizes the system time of this virtual machine with the system time of the physical computer."
<#23#>    "Coordinates the communications that are required to use Volume Shadow Copy Service to back up applications and data on this virtual machine from the operating system on the physical computer."

<#24#>    "Manages payments and Near Field Communication (NFC) based secure elements."
<#25#>    "Delivers data from a variety of sensors"
<#26#>    "The Windows biometric service gives client applications the ability to capture, compare, manipulate, and store biometric data without gaining direct access to any biometric hardware or samples. The service is hosted in a privileged SVCHOST process."
<#27#>    "Creates software device nodes for all smart card readers accessible to a given session. If this service is disabled, WinRT APIs will not be able to enumerate smart card readers."
<#28#>    "Enables Touch Keyboard and Handwriting Panel pen and ink functionality"
<#29#>    "Enables multiple clients to access video frames from camera devices."
<#30#>    "Provides the ability to share a cellular data connection with another device."
<#31#>    "Enables spatial perception, spatial input, and holographic rendering."
<#+1#>    "Radio Management and Airplane Mode Service"

<#32#>    "This service manages connected Xbox Accessories."
<#33#>    "This service sync save data for Xbox Live save enabled games. If this service is stopped, game save data will not uploaded to or download from Xbox Live."
)

$i=0
clear
while ($i -lt $serviceName.Length) {
    
    #clear
    echo "========================================================"
    Write-Host "PART: $($i+1)/$($serviceName.Length)"
    Write-Host "SERVICE TYPE: $($serviceType[$i])" -ForegroundColor Yellow
    Write-Host "PROPOSAL: $($serviceProposal[$i])" -ForegroundColor Yellow
    Write-Host "Disable >> $($serviceNick[$i]) << Service?" -ForegroundColor Cyan
    Write-Host "$($serviceUse[$i])" -ForegroundColor Red
    echo "========================================================"

    Get-Service $serviceName[$i]
    #Get-Service $serviceName[$i] | select -property Status,Name,Starttype,DisplayName

    echo "`nDESCRIPTION:`n----------`n$($serviceDesc[$i])"
    echo ""
    $confirmation = Read-Host "Disable: y | Skip: n | [Y/n]"

    if ($confirmation -eq 'y') {
        #Stop-Service $serviceName[$i]
        Write-Host "Service Stopped" -ForegroundColor Green
       
        echo "SET STARTUP TYPE: Disabled" >> $logPath\$logFileName
        Get-Service $serviceName[$i] | select -property Status,Name,Starttype,DisplayName >> $logPath\$logFileName

        #Set-Service $serviceName[$i] -StartupType $setStartupTyepe
        Write-Host "Service Disabled" -ForegroundColor Green
    } else {
        Write-Host "Skip`n" -ForegroundColor Red
    }

    $i++
}
