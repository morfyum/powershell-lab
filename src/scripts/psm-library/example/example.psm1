@{
RootModule = 'example.psm1'
ModuleVersion = '2.1.0'
Author = 'Microsoft Corporation'
CompanyName = 'Microsoft Corporation'
Copyright = '(c) Microsoft Corporation. All rights reserved.'
Description = 'Great command line editing in the PowerShell console host'
PowerShellVersion = '7.2.4' #5.0
HelpInfoURI = 'https://github.com/morfyum'
}

Function Get-Something {

    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $false)]
        [string] $UserPrincipalName
    )

    Write-Output "The Get-Something function was called"
}


Function Set-Something {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $false)]
        [string] $UserPrincipalName
    )

    Write-Output "The Set-Something function was called"
}


Function New-Something {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $false)]
        [string] $UserPrincipalName
    )

    Write-Output "The New-Something function was called"
}
