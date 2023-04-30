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


Stop-Service "Spooler"
Set-Service -Name "Spooler" -StartupType Disabled

Stop-Service "DiagTrack"
Set-Service "DiagTrack" -StartupType Disabled

## Stop and Disable EventLog 
Stop-Service -Name eventlog -Force
Set-Service -Name eventlog -StartupType Disabled


XboxNetApiSvc   # xbox [ VM ]
DoSvc           # Delivery optimization [ ALL ]
PcaSvc          # Program Compatibility Assistant [ UNSAFE? ]
MapsBroker      # Downloaded maps [ VM ]
RetailDemo      # Demo mode [ VM ]
PimIndexMaintenanceSvc  # Contacts [ ALL ] [ NO-CORPORATE ]
PimIndexMaintenanceSvc_*
UserDataSvc     # [ ALL ] [ VM ] [ UNSAFE? ]
MessagingService        # [ ALL ] [ NO-OFFICE ]
VSS             # Volume Shadow Copy [ VM ] [ ALL ] [ NOBACKUP ]
WMPNetworkSvc   # Media player Data collector Service [ PRIVACY ] [ ALL ]
wersvc          # Windows Error Reporting Serice [ UNSAFE? ]
DiagTrack       # Telemetry service
dmwappushservice        # WAP push message routine 
diagnosticshub.standardcollector.service    # ?
diagsvc         # Diagnostic execution
WbioSrvc        # Biometric service: finger, face [ VM ]
wisvc           # Windows Insider service


$services = @(
    "diagnosticshub.standardcollector.service" # Manual - Microsoft (R) Diagnostics Hub Standard Collector Service
    "DiagTrack"                                # stopped - Diagnostics Tracking Service
    "dmwappushservice"                         # manual - WAP Push Message Routing Service (see known issues)
    "lfsvc"                                    # manual - Geolocation Service
    "MapsBroker"                               # auto - Downloaded Maps Manager
    "NetTcpPortSharing"                        # disabled - Net.Tcp Port Sharing Service
    "RemoteAccess"                             # disabled - Routing and Remote Access
    # "RemoteRegistry"                         # Remote Registry
    "SharedAccess"                             # Manual - Internet Connection Sharing (ICS)
    "TrkWks"                                   # auto - Distributed Link Tracking Client
    # "WbioSrvc"                               # Windows Biometric Service (required for Fingerprint reader / facial detection)
    #"WlanSvc"                                 # WLAN AutoConfig
    "WMPNetworkSvc"                            # Windows Media Player Network Sharing Service
    #"wscsvc"                                  # Windows Security Center Service
    #"WSearch"                                 # Windows Search
    "XblAuthManager"                           # manual - Xbox Live Auth Manager
    "XblGameSave"                              # manual - Xbox Live Game Save Service
    "XboxNetApiSvc"                            # manual - Xbox Live Networking Service
    "ndu"                                      # auto - Windows Network Data Usage Monitor
)

foreach ($service in $services) {
    Write-Output "Trying to disable $service"
    Get-Service -Name $service | Set-Service -StartupType Disabled
}