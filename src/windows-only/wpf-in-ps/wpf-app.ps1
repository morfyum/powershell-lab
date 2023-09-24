[System.Reflection.Assembly]::LoadWithPartialName("PresentationFramework") | Out-Null

$selfLocation = (pwd).Path
$selfBackground = "background.jpg"
$selfLanguage = ""

function Import-Welcome {
	[xml]$xaml = Get-Content -Path $selfLocation\welcome.xaml
	$manager = New-Object System.Xml.XmlNamespaceManager -ArgumentList $xaml.NameTable
	$manager.AddNamespace("x", "http://schemas.microsoft.com/winfx/2006/xaml");
	$xamlReader = New-Object System.Xml.XmlNodeReader $xaml
	[Windows.Markup.XamlReader]::Load($xamlReader)
}
$WelcomeWindow = Import-Welcome
$WelcomeWindow.Show()


function Switch-ClearSwitch {
    # TODO
}


##################################################################
# Put here the code what you want to load before your app start. #
##################################################################
Write-Output "Starting Application..."
Write-Output "selfLocation:    [ $selfLocation ]"
$example_code = Get-CimClass

$showDate = Get-Date
$showHome = $HOME
$showExecutionPolicy = Get-ExecutionPolicy

Get-Command git -ErrorAction SilentlyContinue | Out-Null
$IsInstalledGit = $? 

Get-Command chrome -ErrorAction SilentlyContinue | Out-Null
$IsInstalledChrome = $?

Check-VSCode-IsInstalled

# Page / Overview
$ShowFileExtensionState = (Get-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "HideFileExt").HideFileExt
$HiddenFileState = (Get-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "Hidden").Hidden

# Page / About
#$showPageAboutDetail = (Get-Content -Path "$selfLocation\about-hu.txt" -Encoding UTF8) -join "`n"
$showPageAboutDetail = (Get-Content -Path "$selfLocation\about-hu.txt" -Encoding UTF8 -Raw)

Write-Output "Git:             $IsInstalledGit"
Write-Output "Chrome:          $IsInstalledChrome"
Write-Output "VSCODE:          $IsInstalledVSCode"

Write-Output "showDate:        $showDate"
Write-Output "showHome:        $showHome"

# Dummy waiter
#Start-Sleep -Seconds 1


#Start-Job -ScriptBlock ${Function:Background-Process}
    
################################################################
# Start the real application after everything else is loaded.  #
################################################################
$WelcomeWindow.Close()

function Import-Xaml {
	[xml]$xaml = Get-Content -Path $selfLocation\window.xaml
	$manager = New-Object System.Xml.XmlNamespaceManager -ArgumentList $xaml.NameTable
	$manager.AddNamespace("x", "http://schemas.microsoft.com/winfx/2006/xaml");
	$xamlReader = New-Object System.Xml.XmlNodeReader $xaml
	[Windows.Markup.XamlReader]::Load($xamlReader)
}
$Window = Import-Xaml
################################################################
# Own functionality for application.                           #
################################################################
$AppBackground = $Window.FindName("AppBackground")
$AppBackground.Source = "$selfLocation\$selfBackground"

# Page 1 / Overveiw
# Page 2 / App

$InstalledGit = $Window.FindName("InstalledGit")
$InstalledChrome = $Window.FindName("InstalledChrome")
$InstalledVSCode = $Window.FindName("InstalledVSCode")

if ($IsInstalledGit -eq $true) {
    $InstalledGit.Background = "#55FF55"
    $InstalledGit.Content = "🔧 Remove Git"
} else {
    $InstalledGit.Background = "#FF5555"
    $InstalledGit.Content = "Install Git"
}

if ($IsInstalledChrome -eq $true) {
    $InstalledChrome.Background = "#55FF55"
    $InstalledChrome.Content = "Remove Chrome"
} else {
    $InstalledChrome.Background = "#FF5555"
    $InstalledChrome.Content = "✅ Install Chrome"
}


function Check-VSCode-IsInstalled {
    Get-Package "*Microsoft Visual Studio Code*" -ErrorAction SilentlyContinue | Out-Null
    $IsInstalledVSCode = $?
    if ($IsInstalledVSCode -eq $true) {
        $InstalledVSCode.Background = "#55FF55"
        $InstalledVSCode.Content = "Remove VSCode"
    } else {
        $InstalledVSCode.Background = "#FF5555"
        $InstalledVSCode.Content = "✅ Install VSCode"
    }
}


$InstalledVSCode.add_Click({
    if ($IsInstalledVSCode -eq $true) {
        $InstalledVSCode.Background = "#55FF55"
        $InstalledVSCode.Content = "Remove VSCode"
        winget uninstall vscode --disable-interactivity
        Check-VSCode-IsInstalled
    } else {
        winget install vscode --disable-interactivity
        Check-VSCode-IsInstalled
        $InstalledVSCode.Background = "#FF5555"
        $InstalledVSCode.Content = "✅ Install VSCODE"

    }
})


# Page 3 / VMSettings

# PAge 4 / About
$aboutContent = $Window.FindName("AboutContent")
$aboutContent.Text = "$showPageAboutDetail"




$FooterContent1 = $Window.FindName("FooterContent1")
$FooterContent1.Text = "[ $showDate ]"
$FooterContent2 = $Window.FindName("FooterContent2")
$FooterContent2.Text = "[ Home:","[ $showHome ]"


$TextBlock_ShowExecutionPolicy = $Window.FindName("ShowExecutionPolicy")
$TextBlock_ShowExecutionPolicy.Content = $showExecutionPolicy


$Overview = $Window.FindName("Overview")
$App = $Window.FindName("App")
$VMSettings = $Window.FindName("VMSettings")
$About = $Window.FindName("About")
$LayoutTest = $Window.FindName("LayoutTest")

$Button1 = $Window.FindName('Button1')
$Button2 = $Window.FindName('Button2')
$Button3 = $Window.FindName('Button3')
$Button4 = $Window.FindName('Button4')
$Button5 = $Window.FindName('Button5')


#Overview / [ ShowHiddenFiles ] $HiddenFileState
$BtnSwitchShowHiddenFiles = $Window.FindName('SwitchShowHiddenFiles')
$SwitchAreaShowHiddenFiles = $Window.FindName('SwitchAreaShowHiddenFiles')

if ($HiddenFileState -eq 1 ) {
    # ENABLED
    $BtnSwitchShowHiddenFiles.HorizontalAlignment="Right"
    $BtnSwitchShowHiddenFiles.Background = "#164549"
    $SwitchAreaShowHiddenFiles.Background="#2B9199"
    $SwitchAreaShowHiddenFiles.BorderBrush="#2B9199"
} else {
    # DISABLED
    $BtnSwitchShowHiddenFiles.HorizontalAlignment="Left"
    $BtnSwitchShowHiddenFiles.Background = "#2B9199"
    $SwitchAreaShowHiddenFiles.Background="#DDDDDD"
    $SwitchAreaShowHiddenFiles.BorderBrush="#DDDDDD"
}

$BtnSwitchShowHiddenFiles.Add_MouseLeftButtonDown({
    if ($BtnSwitchShowHiddenFiles.HorizontalAlignment -eq "Left") {
        # Enable
        Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "Hidden" -Type DWord -Value 1
        $HiddenFileState = 1
        $BtnSwitchShowHiddenFiles.HorizontalAlignment="Right"
        $BtnSwitchShowHiddenFiles.Background = "#164549"
        $SwitchAreaShowHiddenFiles.Background="#2B9199"
        $SwitchAreaShowHiddenFiles.BorderBrush="#2B9199"
    } else {
        # Disable
        Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "Hidden" -Type DWord -Value 0
        $HiddenFileState = 0
        $BtnSwitchShowHiddenFiles.HorizontalAlignment="Left"
        $BtnSwitchShowHiddenFiles.Background = "#2B9199"
        $SwitchAreaShowHiddenFiles.Background="#DDDDDD"
        $SwitchAreaShowHiddenFiles.BorderBrush="#DDDDDD"
    }
})


# Overview / [ HideFileExt ] $ShowFileExtensionState
$BtnSwitchHideFileExt = $Window.FindName('SwitchHideFileExt')
$SwitchAreaHideFileExt = $Window.FindName('SwitchAreaHideFileExt')

if ($ShowFileExtensionState -eq 0 ) {
    # ENABLED
    $BtnSwitchHideFileExt.HorizontalAlignment="Right"
    $BtnSwitchHideFileExt.Background = "#164549"
    $SwitchAreaHideFileExt.Background="#2B9199"
    $SwitchAreaHideFileExt.BorderBrush="#2B9199"
} else {
    # DISABLED
    $BtnSwitchHideFileExt.HorizontalAlignment="Left"
    $BtnSwitchHideFileExt.Background = "#2B9199"
    $SwitchAreaHideFileExt.Background="#DDDDDD"
    $SwitchAreaHideFileExt.BorderBrush="#DDDDDD"
}

$BtnSwitchHideFileExt.Add_MouseLeftButtonDown({

    if ($BtnSwitchHideFileExt.HorizontalAlignment -eq "Left") {
        # Enable
        Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "HideFileExt" -Type DWord -Value 0
        $ShowFileExtensionState = 0
        $BtnSwitchHideFileExt.HorizontalAlignment="Right"
        $BtnSwitchHideFileExt.Background = "#164549"
        $SwitchAreaHideFileExt.Background="#2B9199"
        $SwitchAreaHideFileExt.BorderBrush="#2B9199"
    } else {
        # Disable
        Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "HideFileExt" -Type DWord -Value 1
        $ShowFileExtensionState = 1
        $BtnSwitchHideFileExt.HorizontalAlignment="Left"
        $BtnSwitchHideFileExt.Background = "#2B9199"
        $SwitchAreaHideFileExt.Background="#DDDDDD"
        $SwitchAreaHideFileExt.BorderBrush="#DDDDDD"
    }
})



$Button1.add_Click({
    $Overview.Visibility = "Visible"
    $App.Visibility = "Hidden"
    $VMSettings.Visibility = "Hidden"
    $About.Visibility = "Hidden"
    $LayoutTest.Visibility = "Hidden"
    $Overview.Background = "#80000000"
})

$Button2.add_Click({
    $Overview.Visibility = "Hidden"
    $App.Visibility = "Visible"
    $VMSettings.Visibility = "Hidden"
    $About.Visibility = "Hidden"
    $LayoutTest.Visibility = "Hidden"
    $App.Background = "#80000000"
})

$Button3.add_Click({
    $Overview.Visibility = "Hidden"
    $App.Visibility = "Hidden"
    $VMSettings.Visibility = "Visible"
    $About.Visibility = "Hidden"
    $LayoutTest.Visibility = "Hidden"
    $VMSettings.Background = "#80000000"
})

$Button4.add_Click({
    $Overview.Visibility = "Hidden"
    $App.Visibility = "Hidden"
    $VMSettings.Visibility = "Hidden"
    $About.Visibility = "Visible"
    $LayoutTest.Visibility = "Hidden"
    #$About.Background = "#AADDDDDD"
})

$Button5.add_Click({
    $Overview.Visibility = "Hidden"
    $App.Visibility = "Hidden"
    $VMSettings.Visibility = "Hidden"
    $About.Visibility = "Hidden"
    $LayoutTest.Visibility = "Visible"
    #$About.Background = "#AADDDDDD"
})



################################################################
# Show Application Window                                      #
################################################################
$Window.ShowDialog()