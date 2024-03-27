function Test-MenuSeparator([Parameter(Mandatory)] $MenuItem) {
    $Separator = Get-MenuSeparator

    # Separator is a singleton and we compare it by reference
    Return [Object]::ReferenceEquals($Separator, $MenuItem)
}