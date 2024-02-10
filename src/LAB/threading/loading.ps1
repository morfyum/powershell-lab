#$array= @(".  ", ":  ", ":. ", ":: ", "::.", ":::")
#$array= @("|", "/", "-", "\")
#$array= @(". ", ": ", ":.", "::")
$array= @(".  ", ":  ", ":. ", ":: ", "::.", ":::", "::.", ":: ", ":. ", ":  ", ".  ", "   ")

#array=("." ".." "...")
#array=("." ":" ":." "::" ":." ":" ".")


function showLoading {
    $array= @(".  ", ":  ", ":. ", ":: ", "::.", ":::", "::.", ":: ", ":. ", ":  ", ".  ", "   ")
    foreach ($currentItemName in $array) {
        #Clear-Host
        [Console]::Clear()
        #Write-Output "[$currentItemName] Progress..."
        [Console]::WriteLine("[$currentItemName] $($PID) Progress...")
        Start-Sleep -Seconds 1
        #Start-Sleep -Milliseconds 150
    }
}

while ($true) {
    showLoading
}

