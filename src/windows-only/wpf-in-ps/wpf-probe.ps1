[System.Reflection.Assembly]::LoadWithPartialName("PresentationFramework") | Out-Null

$selfLocation = (pwd).Path

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


$Page1 = $Window.FindName("Page1")
$Page2 = $Window.FindName("Page2")
$Page3 = $Window.FindName("Page3")
$Page4 = $Window.FindName("Page4")

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
    $Page1.Visibility = "Visible"
    $Page2.Visibility = "Hidden"
    $Page3.Visibility = "Hidden"
    $Page4.Visibility = "Hidden"
    $Page1.Background = "#80000000"
})

$Button2.add_Click({
    $Page1.Visibility = "Hidden"
    $Page2.Visibility = "Visible"
    $Page3.Visibility = "Hidden"
    $Page4.Visibility = "Hidden"
    $Page2.Background = "#80000000"
})

$Button3.add_Click({
    $Page1.Visibility = "Hidden"
    $Page2.Visibility = "Hidden"
    $Page3.Visibility = "Visible"
    $Page4.Visibility = "Hidden"
    $Page3.Background = "#80000000"
})

$Button4.add_Click({
    $Page1.Visibility = "Hidden"
    $Page2.Visibility = "Hidden"
    $Page3.Visibility = "Hidden"
    $Page4.Visibility = "Visible"
    $Page4.Background = "#AADDDDDD"
})

################################################################
# Show Application Window                                      #
################################################################
$Window.ShowDialog()