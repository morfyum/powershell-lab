# Morfyum File Manager
$version = "v0.1.0"
function Show-VerticalPanelContent {
    param (
        [string]$Path,
        [int]$PanelX,       # Panel kezdő X koordinátája (oszlop)
        [int]$PanelY,       # Panel kezdő Y koordinátája (sor)
        [int]$PanelWidth,   # Panel szélessége
        [int]$PanelHeight,  # Panel magassága
        [bool]$IsActive,
        [int]$SelectedLineIndex
    )
    
    #$items = @(Get-ChildItem -Path $Path -ErrorAction SilentlyContinue | Sort-Object -Property PSIsContainer, Name)
    $items = @(Get-ChildItem -Path $Path -ErrorAction SilentlyContinue)

    # Keret rajzolása a panel körül
    for ($y = 0; $y -lt $PanelHeight; $y++) {
        [Console]::SetCursorPosition($PanelX, $PanelY + $y)
        #Write-Host (" " * $PanelWidth) # Sor törlése
    }

    # Panel header
    [Console]::SetCursorPosition($PanelX, $PanelY)
    $headerColor = if ($IsActive) { "Black" } else { "DarkGray" }
    $headerText = " " + $Path.PadRight($PanelWidth - 2)
    Write-Host "$headerText" -ForegroundColor $headerColor -BackgroundColor Cyan

    # Tartalom rajzolása
    for ($i = 0; $i -lt $PanelHeight; $i++) { # -1 a fejléc miatt
        [Console]::SetCursorPosition($PanelX, $PanelY + 1 + $i) # +1, mert a fejléc az első sor
        Write-Host (" " * $PanelWidth) # Sor törlése

        if ($i -lt $items.Count) {
            $item = $items[$i]
            $itemName = $item.Name
            
            $displayColor = "White"
            if ($item.PSIsContainer) {
                $displayColor = "Green" # Mappa zöld
                $itemName = "$itemName/"
            }

            # Csonkítás, ha az elem neve túl hosszú a panel szélességéhez
            if ($itemName.Length -gt ($PanelWidth - 2)) { # -2 a szegély miatt
                $itemName = $itemName.Substring(0, $PanelWidth - 5) + "..."
            }

            [Console]::SetCursorPosition($PanelX + 1, $PanelY + 1 + $i) # +1 az X-nél a keret miatt
            if ($IsActive -and $i -eq $SelectedLineIndex) {
                Write-Host "$itemName" -BackgroundColor Cyan -ForegroundColor Black
            } else {
                Write-Host "$itemName" -ForegroundColor $displayColor
            }
        }
    }
}

$panel1Path = $HOME
$panel2Path = $HOME
$activePanel = "Panel1"
$selectedItemIndex1 = 0
$selectedItemIndex2 = 0

# Get Console size
$consoleWidth = [Console]::WindowWidth
$consoleHeight = [Console]::WindowHeight -4 # -5 for do not hide header

# Set Panel Size and Position
$panelWidth = [Math]::Floor($consoleWidth / 2) # 50:50
$panelHeight = $consoleHeight #- 3              # Utolsó 2-3 sort fenntartjuk az üzeneteknek

$panel1X = 0
$panel1Y = 0

$panel2X = $panelWidth # Second panel start after firsts
$panel2Y = 0

function MainLoop {
    while ($true) {
        # "Enter" file selection
        $currentPathRef = if ($activePanel -eq "Panel1") { [ref]$panel1Path } else { [ref]$panel2Path }
        $currentIndexRef = if ($activePanel -eq "Panel1") { [ref]$selectedItemIndex1 } else { [ref]$selectedItemIndex2 }
        $currentItems = @(Get-ChildItem -Path $currentPathRef.Value -ErrorAction SilentlyContinue)
        $selectedItem = $currentItems[$currentIndexRef.Value]
        # "UpArrow" & "DownArrow" navigation 
        $currentPath = if ($activePanel -eq "Panel1") { $panel1Path } else { $panel2Path }
        $currentIndexRef = if ($activePanel -eq "Panel1") { [ref]$selectedItemIndex1 } else { [ref]$selectedItemIndex2 }
        $items = @(Get-ChildItem -Path $currentPath -ErrorAction SilentlyContinue)
        [Console]::Clear()

        # Draw Panel 1
        Show-VerticalPanelContent -Path $panel1Path -PanelX $panel1X -PanelY $panel1Y -PanelWidth $panelWidth -PanelHeight $panelHeight -IsActive ($activePanel -eq "Panel1") -SelectedLineIndex $selectedItemIndex1
        # Draw Panel 2
        Show-VerticalPanelContent -Path $panel2Path -PanelX $panel2X -PanelY $panel2Y -PanelWidth $panelWidth -PanelHeight $panelHeight -IsActive ($activePanel -eq "Panel2") -SelectedLineIndex $selectedItemIndex2

        # Bottom menu bar
        [Console]::SetCursorPosition(0, $consoleHeight - 2)
        #Write-Host (" " * $consoleWidth) # Sor törlése
        $fileType = $((Get-ItemProperty $selectedItem.FullName -ErrorAction SilentlyContinue).Attributes)
        $lastWriteTime = $((Get-ItemProperty $selectedItem.FullName -ErrorAction SilentlyContinue).LastWriteTime)
        Write-Host "===========================================================  ================================================="
        Write-Host "Navigation: Up/Down | 📁 Change Directory: ENTER | Back: BACKSPACE | Panel Change: TAB | Extract: X | Exit: Q    "
        Write-Host "Edit file: F2 | Move: M | Copy : C | Sync: S | Delete: D"
        Write-Host "Selected: [$selectedItem] $fileType $lastWriteTime | Index: [$($currentIndexRef.Value)] | H: [$PanelHeight] | $version"
        Write-Host "===========================================================  ================================================="
        $key = [Console]::ReadKey($true) # $true: Hide pushed keys
        
        switch ($key.Key) {
            "Tab" {
                if ($activePanel -eq "Panel1") {
                    $activePanel = "Panel2"
                } else {
                    $activePanel = "Panel1"
                }
            }
            "UpArrow" {
                if ($currentIndexRef.Value -gt 0) {
                    $currentIndexRef.Value--
                } elseif ($currentIndexRef.Value -eq 0) {
                    $currentIndexRef.Value = $items.Length-1
                }
            }
            "DownArrow" {
                # Max index ellenőrzése, és panel magasság ellenőrzése is
                if ($currentIndexRef.Value -lt ($items.Count - 1) -and $currentIndexRef.Value -lt ($panelHeight - 2)) { # -2 mert fejléc és üres sor
                    $currentIndexRef.Value++
                } elseif ($currentIndexRef.Value -eq $items.Length-1) {
                    $currentIndexRef.Value = 0
                }
            }
            "Enter" {                
                if ($currentItems.Count -gt $currentIndexRef.Value) {
                    if ($selectedItem.PSIsContainer) { # Ha mappa
                        $currentPathRef.Value = $selectedItem.FullName
                        $currentIndexRef.Value = 0 # Vissza az elejére az új mappában
                    }
                }
            }
            "Backspace" {
                $parentPath = (Split-Path -Path $currentPathRef.Value -Parent)
                if ($parentPath) { # Ha van feljebb (nem a gyökérkönyvtár)
                    $currentPathRef.Value = $parentPath
                    $currentIndexRef.Value = 0 # Vissza az elejére az új mappában
                }
            }
            "F2"{
                # Edit File
                Write-Host "Open File: [$currentPath\$selectedItem]"
                Pause
                openInDefaultEditor -Editor code -FilePath $currentPath\$selectedItem
            }
            "X" {
                # Exrract Archive
                Write-Host "EXPAND: $($currentItems[$currentIndexRef.Value])"
                #TODO if archive or .exe => Exract 
                Expand-Archive -Path $selectedItem.FullName -DestinationPath $currentPath
            }
            "M"{
                # Move Item
                Write-Host "Move item: P1: $panel1Path P2: $panel2Path"
                if ($activePanel -eq "Panel1") { 
                    [ref]$panel1Path
                    Move-Item -Path "$panel1Path\$selectedItem" -Destination "$panel2Path\$selectedItem"
                } else {
                    [ref]$panel2Path
                    Move-Item -Path "$panel2Path\$selectedItem" -Destination "$panel1Path\$selectedItem"
                }
            }
            "C" {
                # Copy Item
                Write-Host "Copy Item: P1: $panel1Path P2: $panel2Path"
                if ($activePanel -eq "Panel1") { 
                    Copy-Item -Path "$panel1Path\$selectedItem" -Destination "$panel2Path\$selectedItem" -Recurse -ErrorAction SilentlyContinue
                } else {
                    Copy-Item -Path "$panel2Path\$selectedItem" -Destination "$panel1Path\$selectedItem" -Recurse -ErrorAction SilentlyContinue
                }
            }
            "S" {
                # Sync
                if ($activePanel -eq "Panel1") { 
                    $panel2Path = $panel1Path 
                } else {
                    $panel1Path = $panel2Path 
                }
            }
            "D" {
                # Delete Item
                if ($activePanel -eq "Panel1") { 
                    [ref]$panel1Path
                    Write-Host "Do you really want to delete the following file?" -ForegroundColor Red
                    Write-Host "[$panel1Path\$selectedItem]" -ForegroundColor Red
                    $approveRemove = Read-Host "Enter 'DELETE' to delete"
                    if ($approveRemove -eq "DELETE") {
                        Remove-Item -Path "$panel1Path\$selectedItem" -Recurse
                    } else {
                        Write-Host "Abort"
                    }
                } else {
                    [ref]$panel2Path
                    Write-Host "Do you really want to delete the following file?" -ForegroundColor Red
                    Write-Host "[$panel2Path\$selectedItem]" -ForegroundColor Red
                    $approveRemove = Read-Host "Enter 'DELETE' to delete"
                    if ($approveRemove -eq "DELETE") {
                        Remove-Item -Path "$panel2Path\$selectedItem" -Recurse
                    } else {
                        Write-Host "Abort"
                    }
                }
            }
            "Q" {
                [Console]::ResetColor()
                [Console]::Clear()
                Write-Host "🤝 Goodbye!"
                Exit
            }
        }
    }
}

function openInDefaultEditor {
    param (
        [string]$Editor,
        [Parameter(Mandatory=$true)]
        [string]$FilePath
    )
    if (-not (Test-Path -Path $FilePath -PathType Leaf)) {
        Write-Warning "A megadott fájl nem található: $FilePath"
        return
    }
    try {
        Start-Process -FilePath $Editor -ArgumentList $FilePath -NoNewWindow
    } catch {
        Write-Error "Hiba történt a Jegyzettömb megnyitásakor: $($_.Exception.Message)"
    }
}

MainLoop
