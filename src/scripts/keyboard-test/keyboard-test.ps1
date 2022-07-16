

function checkKeyboardLayout {
    # CURRENT KEYBOARD LAYOUT:
    # SOURCE: https://docs.microsoft.com/en-us/powershell/module/international/get-winuserlanguagelist?view=windowsserver2022-ps

    # Work on windows only!
    #(Get-WinUserLanguageList)[0].autonym

    # LCID: keyboard Layout ID
    (Get-Culture).keyboardLayoutID

     Get-Culture
     (Get-Culture).Name
}
checkKeyboardLayout


#$press_key = Read-Host "Please press key"


$keymap_base_keys
$keymap__hu_HU = @("q", "w", "e", "r")

$keymap_selected_table = @("q", "w", "e", "r")
$keymap_success_table = @("False", "False", "False", "False")


$keymap_dictionary


#for element in $keymap__hu_HU

function readKey {
    # source: https://hostingultraso.com/help/windows/read-key-user-input-windows-powershell
    $asd = 0
    while ($asd -le 11) {
        echo "Pressed: "
        echo "================="
        Write-Host "Checkist: [" $keymap_selected_table[0] ":" $keymap_success_table[0] "]"
        echo "================="
        #$hash["q"]
        $hash

        $key

        $key = [Console]::ReadKey($true)
        echo $key
        Write-Host "PRESSED:" $key.Key -ForegroundColor Cyan

        echo "-------------------"
        #clear


    }

}
readKey

function readHostKeyChecker {

     #for element in $choosen_keymap {

        $press_key = Read-Host "Please press key"
        Write-Host "  - [ $press_key ]"

    #}


}
#readHostKeyChecker

function pressLoop {
    $number_of_keys = 0
    echo "Press Loop"
    while ($number_of_keys -le 3 ) {

    $pressed_key = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    #$pressed_key

    ($pressed_key).Character
    }
}

#pressLoop


function pressOneKey {

    Write-Host "Press: A" -ForegroundColor Gray

    $pressed_key = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")

    Write-Host "PRESSED KEY:", $pressed_key -ForegroundColor Yellow
    ($pressed_key).VirtualKeyCode
    ($pressed_key).Character
    ($pressed_key).ControlKeyState
    ($pressed_key).KeyDown

}


function pressedKeyInfo {
    do
    {
        # wait for a key to be available:
        if ([Console]::KeyAvailable)
        {
            # read the key, and consume it so it won't
            # be echoed to the console:
            $keyInfo = [Console]::ReadKey($true)
            # exit loop
            break
        }

        # write a dot and wait a second
        Write-Host '.' -NoNewline
        Start-Sleep -Seconds 1

    } while ($true)

    # emit a new line
    Write-Host

    # show the received key info object:
    $keyInfo
}

#pressedKeyInfo
