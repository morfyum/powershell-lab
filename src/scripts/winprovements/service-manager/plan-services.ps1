# SERVICES
## 🏴 FLAGS RECOMMENDATIONS FOR FOLLOWING AREA OF USE 🏴 
## [ VM ] [ ALL ] [ NO-CORPORATE ] [ NOBACKUP ] [ PRIVACY ] [ SECURITY ]

# tasks is an other thing?
## Get-ScheduledTask ??

# SERVICES 
# Get-Service |select starttype, status, name, displayName

## Stop and disable Diagnostics Tracking Service
## Get-Service -Name "*spoo*" |select Name, Starttype

## Count Services before! 


# UNIQ NAMED SERVICES REQUIRES SEPCIAL DISABLING
# OneSyncSvc > OneSyncSvc_394cc OneSyncSvc_45dd6
# - OneSyncSvc  : cant stop 
# - UserDataSvc *
# - UnistoreSvc *
# - PrintWorkflowUserSvc _*
# - CDPUserSvc * _394cc

# DPS - Not Disabled, maybe can help to debug VMs while testing service disabler
# 

## Windows Audio Service: AudioEndpointBuilder
# Restart is solve sound issues. Disable is remove sound

Stop-Service "Spooler"
Set-Service -Name "Spooler" -StartupType Disabled

Stop-Service "DiagTrack"
Set-Service "DiagTrack" -StartupType Disabled

## Stop and Disable EventLog 
Stop-Service -Name eventlog -Force
Set-Service -Name eventlog -StartupType Disabled

foreach ($service in $services) {
    Write-Output "Trying to disable $service"
    Get-Service -Name $service | Set-Service -StartupType Disabled
}

###
## KÉRDÉSE SZOLGÁLTATÁSOK:

AppReadiness
    - Első indításkor használja
    - performance?
ALG
    - security?
WiaRpc
    - ?
wbengine
    - Kell-e ha a backup tiltva van?