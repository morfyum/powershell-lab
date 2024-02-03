$array= @(".  ", ":  ", ":. ", ":: ", "::.", ":::")
#$array= @("|", "/", "-", "\")
#$array= @(". ", ": ", ":.", "::")

#array=("." ".." "...")
#array=("." ":" ":." "::" ":." ":" ".")


function showLoading {
    foreach ($currentItemName in $array) {
        Clear-Host
        Write-Output "[$currentItemName] Progress..."
        #Write-Verbose "[$currentItemName] Progress..."
        Start-Sleep -Seconds 1
    }    
}

while ($true) {
    showLoading
}

