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
$IsInstalledChrome =$?


# Page / About
$showPageAboutDetail = (Get-Content -Path "$selfLocation\about-hu.txt" -Encoding UTF8) -join "`n"

Write-Output "Git:             $IsInstalledGit"
Write-Output "Chrome:          $IsInstalledChrome"

Write-Output "showDate:        $showDate"
Write-Output "showHome:        $showHome"

# Dummy waiter
Start-Sleep -Seconds 1
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
# Page 3 / VMSettings

# PAge 4 / About
$aboutContent = $Window.FindName("AboutContent")
$aboutContent.Text = "$showPageAboutDetail"


$InstalledGit = $Window.FindName("InstalledGit")
$InstalledChrome = $Window.FindName("InstalledChrome")

if ($IsInstalledGit -eq $true) {
    $InstalledGit.Background = "#55FF55"
    $InstalledGit.Content = "🔧 Remove Git"
} else {
    $InstalledGit.Background = "#FF5555"
    $InstalledGit.Content = "Remove Git"
}

if ($IsInstalledChrome -eq $true) {
    $InstalledChrome.Background = "#55FF55"
    $InstalledChrome.Content = "Remove Chrome"
} else {
    $InstalledChrome.Background = "#FF5555"
    $InstalledChrome.Content = "✅ Install Chrome"
}


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

$Button1 = $Window.FindName('Button1')
$Button2 = $Window.FindName('Button2')
$Button3 = $Window.FindName('Button3')
$Button4 = $Window.FindName('Button4')

<#
$Button.add_Click({
    $Label.Text = "$example_code"
    $Label.Background = "#80000000"
})
#>
$Button1.add_Click({
    $Overview.Visibility = "Visible"
    $App.Visibility = "Hidden"
    $VMSettings.Visibility = "Hidden"
    $About.Visibility = "Hidden"
    $Overview.Background = "#80000000"
})

$Button2.add_Click({
    $Overview.Visibility = "Hidden"
    $App.Visibility = "Visible"
    $VMSettings.Visibility = "Hidden"
    $About.Visibility = "Hidden"
    $App.Background = "#80000000"
})

$Button3.add_Click({
    $Overview.Visibility = "Hidden"
    $App.Visibility = "Hidden"
    $VMSettings.Visibility = "Visible"
    $About.Visibility = "Hidden"
    $VMSettings.Background = "#80000000"
})

$Button4.add_Click({
    $Overview.Visibility = "Hidden"
    $App.Visibility = "Hidden"
    $VMSettings.Visibility = "Hidden"
    $About.Visibility = "Visible"
    #$About.Background = "#AADDDDDD"
})

################################################################
# Show Application Window                                      #
################################################################
$Window.ShowDialog()