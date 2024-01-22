$AutoGridSwitches = $Window.FindName("AutoGridSwitches")

function ClearSwitchTemplate {
    [CmdletBinding()]
    param(
        [Parameter(Position=0,mandatory=$true)]
        [int]$IsEnabled
    )

    if ($IsEnabled -eq 0 ) {
        # DISABLED STATE
        $BtnOrientation = "Left"
        $BtnColor = "#2B9199"
        $BackgroundColor = "#DDDDDD"
    } elseif ($IsEnabled -eq 1 ) {
        <# ENABLED STATE #>
        $BtnOrientation = "Right"
        $BtnColor = "#164549"
        $BackgroundColor = "#2B9199"
    } else {
        $Message = "Require: 0 or 1 -> Exit"
        Write-Host "$Message" -ForegroundColor Red
        Exit 1
    }
    
    #$AutoGridSwitches = $Window.FindName("AutoGridSwitches")
    
    $BorderNameSwitchBtn = $jsonServiceList.service.Name[$objIndex]+"_SwitchBtn"
    $BorderNameSwitchArea = $jsonServiceList.service.Name[$objIndex]+"_SwitchArea"
    
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
    $textBlock.Text = $jsonServiceList.service.Name[$objIndex]+"_SwitchBtn"  #### OBJ ####
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
    $border1.Name = "$BorderNameSwitchArea"  #### OBJ ####
    $border1.Width = 60
    $border1.Height = 30
    $border1.CornerRadius = New-Object Windows.CornerRadius(7)
    $border1.BorderBrush = "$BackgroundColor"  # Left: #DDDDDD | Right: #2B9199
    $border1.Background = "$BackgroundColor"  # Left: #DDDDDD | Right: #2B9199
    $border1.BorderThickness = New-Object Windows.Thickness(15)

    $border2 = New-Object Windows.Controls.Border
    $border2.Name = $jsonServiceList.service.Name[$objIndex]+"_SwitchBtn" #### OBJ #### Btn
    $border2.Width = 24
    $border2.Height = 24
    $border2.Margin = New-Object Windows.Thickness(4)
    $border2.CornerRadius = New-Object Windows.CornerRadius(15)
    $border2.BorderBrush = "$BackgroundColor" # Left: #2B9199 | Right: 164549
    $border2.BorderThickness = New-Object Windows.Thickness(0)
    $border2.Background = "$BtnColor"  # Left: #2B9199 | Right: 164549
    $border2.HorizontalAlignment = [Windows.HorizontalAlignment]::$BtnOrientation  # Left/Right

    $switchGrid.Children.Add($border1)
    $switchGrid.Children.Add($border2)

    $mainGrid.Children.Add($switchGrid)

    # Finally add $mainGrid child-tree to main $Window
    # Work, because elements show in applicaiton.
    $AutoGridSwitches.Children.Add($mainGrid)
    
    # INNENTŐL KAMPÓ DE LEHET HOGY FENT VAN A HIBA,
    # HOGYAN KELL KIHÁNYNI EGY ILYEN FA TARTALMÁT?

    # Functionality Doesnt work because Elements has no Name parameters.
    $BtnSwitch = $Window.FindName($BorderNameSwitchBtn)
    $BtnArea = $Window.FindName($BorderNameSwitchArea)
    Write-Host "$BtnSwitch" -ForegroundColor Red

    ErrorHandler("BorderNameSwitchBtn: [$BorderNameSwitchBtn], BorderNameSwitchArea:[$BorderNameSwitchArea] BtnSwitch: [$BtnSwitch]")
    #$Window | Get-Member -MemberType Properties

    Exit 1
    
    $BtnSwitch.FindName($BorderNameSwitchBtn).Add_MouseLeftButtonDown({
        if ($BtnSwitch.HorizontalAlignment -eq "Left") {
            # Enable
            $BtnSwitch.HorizontalAlignment="Right"
            $BtnSwitch.Background = "#164549"
            $BtnArea.Background="#2B9199"
            $BtnArea.BorderBrush="#2B9199"
        } else {
            # Disable
            $BtnSwitch.HorizontalAlignment="Left"
            $BtnSwitch.Background = "#2B9199"
            $BtnArea.Background="#DDDDDD"
            $BtnArea.BorderBrush="#DDDDDD"
        }
    })

}

function BtnSwitchMachine {
    

    
}