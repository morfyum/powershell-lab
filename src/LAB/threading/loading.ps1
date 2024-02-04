#$array= @(".  ", ":  ", ":. ", ":: ", "::.", ":::")
#$array= @("|", "/", "-", "\")
#$array= @(". ", ": ", ":.", "::")
$array= @(".  ", ":  ", ":. ", ":: ", "::.", ":::", "::.", ":: ", ":. ", ":  ", ".  ", "   ")

#array=("." ".." "...")
#array=("." ":" ":." "::" ":." ":" ".")


function showLoading {
    foreach ($currentItemName in $array) {
        #Clear-Host
        [Console]::Clear()
        #Write-Output "[$currentItemName] Progress..."
        [Console]::WriteLine("[$currentItemName] Progress...")
        Start-Sleep -Seconds 1
        #Start-Sleep -Milliseconds 150
    }
}

while ($true) {
    showLoading
}

