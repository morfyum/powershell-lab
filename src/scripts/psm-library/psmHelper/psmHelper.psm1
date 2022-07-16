
Function Psm-Helper {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $false)]
        [string] $psm_helper
    )

    #Write-Output "PSM HELPER miafasz"
    #Write-Output "Param1:", $Param1
}

param(
    [Parameter(Mandatory=$True, Position=0, ValueFromPipeline=$false)]
    [System.String]
    $Param1,

    [Parameter(Mandatory=$True, Position=1, ValueFromPipeline=$false)]
    [System.String]
    $Param2
)
<##>

#Write-Host "Param1:", $Param1
#Write-Host "Param2:", $Param2
