# REMOVE APPX PACKAGES

<# Can't remove
    - Microsoft.Advertising.Xaml_10.1808.3.0_x64__8wekyb3d8bbwe 
    > because package(s) microsoft. windowscommunicationsapps currently depends on the framework.
    - Microsoft.Windows.NarratorQuickStart_10.0.19041.1023_neut ral_neutral_8wekyb3d8bbwe
    > because Part of Windows, impossible
    - Microsoft.Windows.ParentalControls_1000.19041.1023.0_neutral_neutral_cw5n1h2txyewy
    > because part of Windows, impossible
#>


## deprecate

# not found but adware 
Get-AppxPackage "5A894077.McAfeeSecurity" | Remove-AppPackage
Get-AppxPackage "Disney.37853FC22B2CE" | Remove-AppPackage
Get-AppxPackage "Microsoft.GamingApp" | Remove-AppPackage
Get-AppxPackage "Facebook.InstagramBeta" | Remove-AppPackage
Get-AppxPackage "AdobeSystemsIncorporated.AdobeCreativeCloudExpress" | Remove-AppPackage
Get-AppxPackage "AmazonVideo.PrimeVideo" | Remove-AppPackage
Get-AppxPackage "BytedancePte.Ltd.TikTok" | Remove-AppPackage

# TODO what is this?
# Get-AppxPackage "" | Remove-AppxPackage


<# not found on VM
Get-AppxPackage "Microsoft.WindowsPhone" | Remove-AppxPackage
Get-AppxPackage "Microsoft.3DBuilder" | Remove-AppxPackage
Get-AppxPackage "Microsoft.AppConnector" | Remove-AppxPackage
Get-AppxPackage "Microsoft.ConnectivityStore" | Remove-AppxPackage
Get-AppxPackage "Microsoft.BingFinance" | Remove-AppxPackage
Get-AppxPackage "Microsoft.BingNews" | Remove-AppxPackage
Get-AppxPackage "Microsoft.BingSports" | Remove-AppxPackage
Get-AppxPackage "Microsoft.AppConnector" | Remove-AppxPackage
Get-AppxPackage "Microsoft.ConnectivityStore" | Remove-AppxPackage
Get-AppxPackage "Microsoft.Office.Sway" | Remove-AppxPackage
Get-AppxPackage "Microsoft.Messaging" | Remove-AppxPackage
Get-AppxPackage "Microsoft.CommsPhone" | Remove-AppxPackage
Get-AppxPackage "9E2F88E3.Twitter" | Remove-AppxPackage
Get-AppxPackage "king.com.CandyCrushSodaSaga" | Remove-AppxPackage
#>


## VM 21H2
Get-AppxPackage "Microsoft.Microsoft3DViewer" | Remove-AppxPackage
Get-AppxPackage "Microsoft.MicrosoftSolitaireCollection" | Remove-AppxPackage
Get-AppxPackage "Microsoft.MicrosoftStickyNotes" | Remove-AppxPackage
Get-AppxPackage "Microsoft.Office.OneNote" | Remove-AppxPackage
Get-AppxPackage "Microsoft.People" | Remove-AppxPackage
Get-AppxPackage "Microsoft.SkypeApp" | Remove-AppxPackage
Get-AppxPackage "Microsoft.WindowsMaps" | Remove-AppxPackage
Get-AppxPackage "Microsoft.YourPhone" | Remove-AppxPackage

## Reqiured windowscomminuicatons before advertising
Get-AppxPackage "microsoft.windowscommunicationsapps" | Remove-AppxPackage
Get-AppxPackage "Microsoft.Advertising.Xaml" | Remove-AppxPackage

<# SKIP FOR OTHER ACTIONS 
Get-AppxPackage "Microsoft.XboxApp" | Remove-AppxPackage
Get-AppxPackage "Microsoft.XboxGameCallableUI" | Remove-AppxPackage  # Cant Remove! 
Get-AppxPackage "Microsoft.XboxGameOverlay" | Remove-AppxPackage
Get-AppxPackage "Microsoft.Xbox.TCUI" | Remove-AppxPackage
Get-AppxPackage "Microsoft.XboxSpeechToTextOverlay" | Remove-AppxPackage
Get-AppxPackage "Microsoft.XboxIdentityProvider" | Remove-AppxPackage
Get-AppxPackage "Microsoft.XboxGamingOverlay" | Remove-AppxPackage
#>

Get-AppxPackage -Name "*xbox*" | Remove-AppxPackage

Get-AppxPackage "Microsoft.Getstarted" | Remove-AppxPackage
Get-AppxPackage "Microsoft.GetHelp" | Remove-AppxPackage
Get-AppxPackage "Microsoft.BingWeather" | Remove-AppxPackage
Get-AppxPackage "Microsoft.MicrosoftOfficeHub" | Remove-AppxPackage
Get-AppxPackage "Microsoft.WindowsFeedbackHub" | Remove-AppxPackage
Get-AppxPackage "Microsoft.Wallet" | Remove-AppxPackage
Get-AppxPackage "Microsoft.MixedReality.Portal" | Remove-AppxPackage
Get-AppxPackage "Microsoft.Windows.NarratorQuickStart" | Remove-AppxPackage
Get-AppxPackage "Microsoft.Windows.ParentalControls" | Remove-AppxPackage
Get-AppxPackage "Microsoft.MSPaint" | Remove-AppxPackage

#Get-AppxPackage "Microsoft.ScreenSketch" | Remove-AppxPackage
<# Microsoft.
    Microsoft.ECApp   # system
    Microsoft.AsyncTextService   # system
?    Microsoft.Windows.CapturePicker
?    Microsoft.Windows.Apprep.ChxApp
?    Microsoft.Advertising.Xaml   # system

    c5e2524a-ea46-4f67-841f-6a9465d9d515
    E2A4F912-2574-4A75-9BB0-0D023378592B
    F46D4000-FD22-4DB4-AC8E-4E1DDDE828FE
    1527c705-839a-4832-9118-54d4Bd6a0c89
    Microsoft.549981C3F5F10 # ??? nem tom mi volt, de letörlődött.
#>

## NOT REQUIRED ON VM
Get-AppxPackage "Microsoft.WindowsCamera" | Remove-AppxPackage
Get-AppxPackage "Microsoft.WindowsSoundRecorder" | Remove-AppxPackage
Get-AppxPackage "Microsoft.ZuneMusic" | Remove-AppxPackage
Get-AppxPackage "Microsoft.ZuneVideo" | Remove-AppxPackage

