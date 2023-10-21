[System.Reflection.Assembly]::LoadWithPartialName("PresentationFramework") | Out-Null

$selfLocation = (Get-Location).Path
$selfBackground = "background.jpg"
$selfLanguage = "en"


$selfServicesLocation = "$selfLocation\functions\services\services.json"

try {
    Test-Path $selfServicesLocation
}
catch {
    Write-Debug "[FAIL] Missing component: $selfServicesLocation"
    Exit 1
}


# TODO: Multi-language implementation
switch ($selfLanguage) {
    en { $selfLanguage = "en" }
    hu { $selfLanguage = "hu" }
    Default {$selfLanguage = "en"}
}

# Instead of Import-Module. ## using module doesnt work.
. $selfLocation\functions\test.ps1
Get-ChildItem -Path Function:\TestFunction

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

function Check-VSCode-IsInstalled {
    Get-Package "*Microsoft Visual Studio Code*" -ErrorAction SilentlyContinue | Out-Null
    $IsInstalledVSCode = $?
    return $IsInstalledVSCode
}

##################################################################
# Put here the code what you want to load before your app start. #
##################################################################
Write-Output "Starting Application..."
Write-Output "selfLocation:    [ $selfLocation ]"
#$example_code = Get-CimClass

$showDate = Get-Date
$showHome = $HOME
$showExecutionPolicy = Get-ExecutionPolicy

Get-Command git -ErrorAction SilentlyContinue | Out-Null
$IsInstalledGit = $? 

Get-Command chrome -ErrorAction SilentlyContinue | Out-Null
$IsInstalledChrome = $?

Check-VSCode-IsInstalled
$IsInstalledVSCode = $?

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

### ### #### Page 2 / App ### ### ####

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

if ($IsInstalledVSCode -eq $true) {
    $InstalledVSCode.Background = "#55FF55"
    $InstalledVSCode.Content = "Remove VSCode"
} else {
    $InstalledVSCode.Background = "#FF5555"
    $InstalledVSCode.Content = "✅ Install VSCode"
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


### ### #### Page 3 / VMSettings ### ### ####

### ### #### Page 4 / About ### ### ####
$aboutContent = $Window.FindName("AboutContent")
$aboutContent.Text = "$showPageAboutDetail"


### ### #### Footer ### ### ####
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
$AutoRender = $Window.FindName("AutoRender")

$Button1 = $Window.FindName('Button1')
$Button2 = $Window.FindName('Button2')
$Button3 = $Window.FindName('Button3')
$Button4 = $Window.FindName('Button4')
$Button5 = $Window.FindName('Button5')
$Button6 = $Window.FindName('Button6')

#### AUTOMATA BUTTONS ####
$AutoGridButtons = $Window.FindName("AutoGridButtons")
$testArray = 0..11
foreach ($item in $testArray) {
    $AutoButton = New-Object Windows.Controls.Button
    $AutoButton.Content = $item
    $AutoButton.width = "170"
    $AutoButton.Margin = "2.5"
    $AutoButton.Padding = "5"
    $AutoGridButtons.Children.Add($AutoButton)
}

#### AUTOMATA SWITCHES ####

$jsonServiceList = Get-Content -Raw $selfServicesLocation | ConvertFrom-Json

Write-Host "JSON: $jsonServiceList"
Write-Host "OK: ", $jsonServiceList.service.Name[0] -ForegroundColor Green



# JSON adatok
$jsonData = @"
[
    { "Name": "Element1", "Text": "1 Show file extensions" },
    { "Name": "Element2", "Text": "2 Another text" },
    { "Name": "Element3", "Text": "3 Yet another text" },
    { "Name": "Element4", "Text": "4 Show file extensions" },
    { "Name": "Element5", "Text": "5 Another text" },
    { "Name": "Element6", "Text": "6 Yet another text" },
    { "Name": "Element7", "Text": "7 Show file extensions" },
    { "Name": "Element8", "Text": "8 Another text" },
    { "Name": "Element9", "Text": "9 Yet another text" },
    { "Name": "Element10", "Text": "10 Show file extensions" },
    { "Name": "Element11", "Text": "11 Another text" },
    { "Name": "Element12", "Text": "12 Yet another text" },
    { "Name": "Element13", "Text": "13 th another text service" }
]
"@

# Átalakítjuk a JSON-t PowerShell objektumokká
#$objects = $jsonData | ConvertFrom-Json
$objects = $jsonServiceList

# A JSON adatokon iterálva létrehozzuk a Grid elemeket
$AutoGridSwitches = $Window.FindName("AutoGridSwitches")
foreach ($obj in $objects) {
    Write-Host "NAME: ", $obj.service.name, "Text:", $obj.service.description
    
    $mainGrid = New-Object Windows.Controls.Grid
    $mainGrid.MinWidth = 300 # 170
    $mainGrid.Margin = New-Object Windows.Thickness(0, 0, 20, 0)
    #$mainGrid.Background = [Windows.Media.Brushes]::Red

    #$mainGrid.RowDefinitions.Add((New-Object Windows.Controls.RowDefinition))
    $mainGrid.ColumnDefinitions.Add((New-Object Windows.Controls.ColumnDefinition))
    $mainGrid.ColumnDefinitions.Add((New-Object Windows.Controls.ColumnDefinition))
     
    $TextGrid = New-Object Windows.Controls.Grid
    #$TextGrid.SetValue([Windows.Controls.Grid]::RowProperty, 0)
    $TextGrid.SetValue([Windows.Controls.Grid]::ColumnProperty, 0)
    $TextGrid.HorizontalAlignment = [Windows.HorizontalAlignment]::Left
    
    $textBlock = New-Object Windows.Controls.TextBox
    $textBlock.Text = $obj.Text
    $textBlock.Background = [Windows.Media.Brushes]::Transparent
    $textBlock.Foreground = "#FFFFFF"
    $textBlock.Height = 30
    $textBlock.MinWidth = 240
    $textBlock.Margin = New-Object Windows.Thickness(2.5)
    $textBlock.Padding = New-Object Windows.Thickness(5)

    $TextGrid.Children.Add($textBlock)

    $mainGrid.Children.Add($TextGrid)

    $switchGrid = New-Object Windows.Controls.Grid
    $switchGrid.Width = 60
    $switchGrid.Margin = New-Object Windows.Thickness(2.5)
    $switchGrid.SetValue([Windows.Controls.Grid]::ColumnProperty, 1)
    $switchGrid.HorizontalAlignment = [Windows.HorizontalAlignment]::Right

    $border1 = New-Object Windows.Controls.Border
    $border1.Name = $obj.Name+"_SwitchArea"
    $border1.Width = 60
    $border1.Height = 30
    $border1.CornerRadius = New-Object Windows.CornerRadius(7)
    $border1.BorderBrush = "#DDDDDD"
    $border1.Background = "#DDDDDD"
    $border1.BorderThickness = New-Object Windows.Thickness(15)
    
    $border2 = New-Object Windows.Controls.Border
    $border2.Name = "${obj.Name}_SwitchBtn"
    $border2.Width = 24
    $border2.Height = 24
    $border2.Margin = New-Object Windows.Thickness(4)
    $border2.CornerRadius = New-Object Windows.CornerRadius(15)
    $border2.BorderBrush = "#2B9199"
    $border2.BorderThickness = New-Object Windows.Thickness(0)
    $border2.Background = "#2B9199"
    $border2.HorizontalAlignment = [Windows.HorizontalAlignment]::Left

    $switchGrid.Children.Add($border1)
    $switchGrid.Children.Add($border2)

    $mainGrid.Children.Add($switchGrid)

    $AutoGridSwitches.Children.Add($mainGrid)
}


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
        $HiddenFileState = 1
        Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "Hidden" -Type DWord -Value $HiddenFileState
        $BtnSwitchShowHiddenFiles.HorizontalAlignment="Right"
        $BtnSwitchShowHiddenFiles.Background = "#164549"
        $SwitchAreaShowHiddenFiles.Background="#2B9199"
        $SwitchAreaShowHiddenFiles.BorderBrush="#2B9199"
    } else {
        # Disable
        $HiddenFileState = 0
        Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "Hidden" -Type DWord -Value $HiddenFileState
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
        $ShowFileExtensionState = 0
        Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "HideFileExt" -Type DWord -Value $ShowFileExtensionState
        $BtnSwitchHideFileExt.HorizontalAlignment="Right"
        $BtnSwitchHideFileExt.Background = "#164549"
        $SwitchAreaHideFileExt.Background="#2B9199"
        $SwitchAreaHideFileExt.BorderBrush="#2B9199"
    } else {
        # Disable
        $ShowFileExtensionState = 1
        Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "HideFileExt" -Type DWord -Value $ShowFileExtensionState
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
    $AutoRender.Visibility = "Hidden"
})

$Button2.add_Click({
    $Overview.Visibility = "Hidden"
    $App.Visibility = "Visible"
    $VMSettings.Visibility = "Hidden"
    $About.Visibility = "Hidden"
    $LayoutTest.Visibility = "Hidden"
    $AutoRender.Visibility = "Hidden"
})

$Button3.add_Click({
    $Overview.Visibility = "Hidden"
    $App.Visibility = "Hidden"
    $VMSettings.Visibility = "Visible"
    $About.Visibility = "Hidden"
    $LayoutTest.Visibility = "Hidden"
    $AutoRender.Visibility = "Hidden"
})

$Button4.add_Click({
    $Overview.Visibility = "Hidden"
    $App.Visibility = "Hidden"
    $VMSettings.Visibility = "Hidden"
    $About.Visibility = "Visible"
    $LayoutTest.Visibility = "Hidden"
    $AutoRender.Visibility = "Hidden"
})

$Button5.add_Click({
    $Overview.Visibility = "Hidden"
    $App.Visibility = "Hidden"
    $VMSettings.Visibility = "Hidden"
    $About.Visibility = "Hidden"
    $LayoutTest.Visibility = "Visible"
    $AutoRender.Visibility = "Hidden"
})

$Button6.add_Click({
    $Overview.Visibility = "Hidden"
    $App.Visibility = "Hidden"
    $VMSettings.Visibility = "Hidden"
    $About.Visibility = "Hidden"
    $LayoutTest.Visibility = "Hidden"
    $AutoRender.Visibility = "Visible"
})

################################################################
# Show Application Window                                      #
################################################################
$Window.ShowDialog()