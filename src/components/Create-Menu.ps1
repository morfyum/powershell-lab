# SRC / Create-Menu 2: https://community.spiceworks.com/scripts/show/4785-create-menu-2-0-arrow-key-driven-powershell-menu-for-scripts
# SRC / Create-Menu  : https://community.spiceworks.com/scripts/show/4656-powershell-create-menu-easily-add-arrow-key-driven-menu-to-scripts

Function Create-Menu () {
    #Start-Transcript "C:\_RRC\MenuLog.txt"
    Param(
        [Parameter(Mandatory = $True)][String]$MenuTitle,
        [Parameter(Mandatory = $True)][array]$MenuOptions,
        [Parameter(Mandatory = $False)][String]$Columns = "Auto", # $True
        [Parameter(Mandatory = $False)][int]$MaximumColumnWidth = 26,
        [Parameter(Mandatory = $False)][bool]$ShowCurrentSelection = $False
    )

    $MaxValue = $MenuOptions.count - 1
    $Selection = 0
    $EnterPressed = $False
    $WindowWidth = (Get-Host).UI.RawUI.MaxWindowSize.Width

    # OWN EXTRAS
    if ($WindowWidth -le 61 ) {
        $MaximumColumnWidth = $WindowWidth -3
        $Columns = 1
    }
    
    # Origin with bugfixes
    if ($Columns -eq "Auto") {    
        $Columns = [Math]::Floor($WindowWidth / ($MaximumColumnWidth)) # +2
    }

    if ([int]$Columns -gt $MenuOptions.count) {
        $Columns = $MenuOptions.count
    }

    $RowQty = ([Math]::Ceiling(($MaxValue + 1) / $Columns))        
    $MenuListing = @()

    for ($i = 0; $i -lt $Columns; $i++) {            
        $ScratchArray = @()

        for ($j = ($RowQty * $i); $j -lt ($RowQty * ($i + 1)); $j++) {
            $ScratchArray += $MenuOptions[$j]
        }

        $ColWidth = ($ScratchArray | Measure-Object -Maximum -Property length).Maximum

        if ($ColWidth -gt $MaximumColumnWidth) {
            $ColWidth = $MaximumColumnWidth -1 # -1
        }

        for ($j = 0; $j -lt $ScratchArray.count; $j++) {
            
            if (($ScratchArray[$j]).length -gt $($MaximumColumnWidth -2 )) { # - 2
                $ScratchArray[$j] = $($ScratchArray[$j]).Substring(0, $($MaximumColumnWidth - 4)) # 4
                $ScratchArray[$j] = "$($ScratchArray[$j])..."
            }
            else {
                for ($k = $ScratchArray[$j].length; $k -lt $ColWidth; $k++) {
                    $ScratchArray[$j] = "$($ScratchArray[$j])."
                }
            }
            $ScratchArray[$j] = " $($ScratchArray[$j])" # ." 
        }
        $MenuListing += $ScratchArray
    }
    
    #Clear-Host
    [Console]::Clear()

    while ($EnterPressed -eq $False) {
        
        #Write-Host "$MenuTitle"
        [Console]::WriteLine("$MenuTitle")
        
        # Show Current Selection ot Title Bar
        if ($ShowCurrentSelection -eq $True) {
            $Host.UI.RawUI.WindowTitle = "$($MenuOptions[$Selection])"
        }

        for ($i = 0; $i -lt $RowQty; $i++) {

            for ($j = 0; $j -le (($Columns - 1) * $RowQty); $j += $RowQty) {

                if ($j -eq (($Columns - 1) * $RowQty)) {
                    if (($i + $j) -eq $Selection) {
                        #Write-Host -BackgroundColor cyan -foregroundColor Black "$($MenuListing[$i+$j])"
                        #$host.ui.rawui.foregroundColor = "Green"
                        $host.UI.RawUI.BackgroundColor = "Cyan"
                        $host.UI.RawUI.foregroundColor = "Black"
                        [Console]::WriteLine("$($MenuListing[$i+$j])")
                        $host.ui.rawui.foregroundColor = "Gray"
                        $host.UI.RawUI.BackgroundColor = "Black"
                    }
                    else {
                        #Write-Host "$($MenuListing[$i+$j])"
                        [Console]::WriteLine("$($MenuListing[$i+$j])")
                    }
                }
                else {
                    if (($i + $j) -eq $Selection) {
                        #Write-Host -BackgroundColor Cyan -foregroundColor Black "$($MenuListing[$i+$j])" -NoNewline
                        $host.UI.RawUI.BackgroundColor = "Cyan"
                        $host.UI.RawUI.foregroundColor = "Black"
                        [Console]::Write("$($MenuListing[$i+$j])")
                        $host.ui.rawui.foregroundColor = "Gray"
                        $host.UI.RawUI.BackgroundColor = "Black"
                    }
                    else {
                        #Write-Host "$($MenuListing[$i+$j])" -NoNewline
                        [Console]::Write("$($MenuListing[$i+$j])")
                    }
                }
                
            }
        }

        #Uncomment the below line if you need to do live debugging of the current index selection. It will put it in green below the selection listing.
        #Write-Host -foregroundColor Green "$Selection"
        [Console]::WriteLine(" [ $Selection ]")

        $KeyInput = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown").virtualkeycode

        switch ($KeyInput) {
            13 {
                $EnterPressed = $True
                return $Selection
                #Clear-Host
                [Console]::Clear()
                #break
            }
            37 {
                #Left
                if ($Selection -ge $RowQty) {
                    $Selection -= $RowQty
                }
                else {
                    $Selection += ($Columns - 1) * $RowQty
                }
                #Clear-Host
                [Console]::Clear()
                #break
            }
            38 {
                #Up
                if ((($Selection + $RowQty) % $RowQty) -eq 0) {
                    $Selection += $RowQty - 1
                }
                else {
                    $Selection -= 1
                }
                #Clear-Host
                [Console]::Clear()
                #break
            }
            39 {
                #Right
                if ([Math]::Ceiling($Selection / $RowQty) -eq $Columns -or ($Selection / $RowQty) + 1 -eq $Columns) {
                    $Selection -= ($Columns - 1) * $RowQty
                }
                else {
                    $Selection += $RowQty
                }
                #Clear-Host
                [Console]::Clear()
                #break
            }
            40 {
                #Down
                if ((($Selection + 1) % $RowQty) -eq 0 -or $Selection -eq $MaxValue) {
                    $Selection = ([Math]::Floor(($Selection) / $RowQty)) * $RowQty       
                }
                else {
                    $Selection += 1
                }
                #Clear-Host
                [Console]::Clear()
                #break
            }
            Default {
                #Clear-Host
                [Console]::Clear()
                break
            }
        }
    }
}