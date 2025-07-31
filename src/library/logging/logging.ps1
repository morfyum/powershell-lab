# LOGGING v0.1

class LogModel {
    [string]$Id
    [string]$Date
    [string]$Level
    [string]$File
    [string]$Message
}

class LogDetails {
    <# Define the class. Try constructors, properties, or methods. #>
}

function Logging {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $False)]
        [string] $logDateTime = (Get-Date -Format "yyyy-MM-dd HH:mm:ss K"),
        [Parameter(Mandatory = $False)]
        [string] $logEntity = $MyInvocation.PSCommandPath,
        [Parameter(Mandatory = $True, HelpMessage = "INFO/WARNING/ERROR/CRITICAL")]
        [ValidateSet("INFO", "WARNING", "ERROR", "CRITICAL")]
        [string] $logLevel,
        [Parameter(Mandatory = $True)]
        [string] $logMessage,
        [Parameter(Mandatory = $True)]
        [string] $logDestination,
        [Parameter(Mandatory = $False)]
        [switch] $ShowColors,
        [Parameter(Mandatory = $False)]
        [switch] $SetFilenameOnly,
        [Parameter(Mandatory = $False)]
        [switch] $Less
    )
    $logEntry = [LogModel]::new()

    if ($SetFilenameOnly.IsPresent) {
        $logEntity = (Split-Path -Path $logEntity -Leaf)
    }

    $logEntry.Id = (New-Guid).ToString()
    $logEntry.Date = $logDateTime
    $logEntry.Level = $logLevel
    $logEntry.File = $logEntity
    $logEntry.Message = $logMessage

    # Set Log message
    $extraSpace = 8 - $($logEntry.Level).Length
    $spaces = ""
    for ($i = 0; $i -lt $extraSpace; $i++) {
        $spaces += " "
    }

    $logMessage = "$($logEntry.Date) - $($logEntry.Level)$spaces $($logEntry.File) : $($logEntry.Message)"
    # Set logging into a file
    $logEntry | Export-Csv -Path $logDestination -NoTypeInformation -Encoding utf8 -Append

    if ($Less.IsPresent) {
         $logEntity = (Split-Path -Path $logEntry.File -Leaf)
        $logMessage = "$($logEntry.Level)$spaces $logEntity : $($logEntry.Message)"
    }

    if ($ShowColors.IsPresent) {
        if ($logLevel -eq "INFO"){Write-Host "$logMessage"}
        if ($logLevel -eq "WARNING"){Write-Host "$logMessage" -ForegroundColor Yellow}
        if ($logLevel -eq "ERROR"){Write-Host "$logMessage" -ForegroundColor Red}
        if ($logLevel -eq "CRITICAL"){Write-Host "$logMessage" -ForegroundColor Magenta}
    } else {
        return $logMessage
    }
    
}
# SIG # Begin signature block
# MIIIpQYJKoZIhvcNAQcCoIIIljCCCJICAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUZOeSRlXT3zQWJzmJ+AmMVzSP
# r4SgggU5MIIFNTCCAx2gAwIBAgIQXIypyGOOp4hNP8ztHTLlZDANBgkqhkiG9w0B
# AQsFADAhMR8wHQYDVQQDDBZNb3JmeXVtIFBvd2VyU2hlbGwgTEFCMB4XDTI1MDcw
# MTE3MjIzOVoXDTM1MDcwMTE3MzIzN1owITEfMB0GA1UEAwwWTW9yZnl1bSBQb3dl
# clNoZWxsIExBQjCCAiIwDQYJKoZIhvcNAQEBBQADggIPADCCAgoCggIBAKK13E0D
# JOowjNnraOVH8rNfMvV6yld+9RKSF6Jq0cO2Q3SKti3P+9szgb7vq2No6PSJuD3R
# vrdl3Gds5JDPQq6754QGTwjELY+6T4zKy8/Jdx+KyIp5POlm9a/V9ZTv8zoh3pUB
# YZF85D0/wS2AJnIx3Bn4tJzwyDf34b4Ed9H9MbXyPbxCwISt8NG8pJbwMQH+bAwR
# A2WxQ0jCrw/16jaUxtO53hxBosSagUPbB3rN0OUENRimECHW5UoRzFCdOudPtVSA
# PWBun/FR/9bbz3KMQqCwajqxS6lAZIju6HLDuG0/sN6i+eAd4aNrFZXSeqPA1D15
# mICAc5i/4fbr3S44Mkj9GHMp6co+sevA8WUodvQEq8dk8Gr/khTRg/8FD/VBg8/j
# /V8ta9iuPtS0rwterFplTgVJeGlEju2ZL5OZpOYG2MlnlCfGpFbnKO3yf6qrjE+5
# JVmeqX8fZ1oQfa9Kv2YelkCDsXogGMMQn0mK2FCVZOKAEk05P4jFHeYtuXC8E+h9
# A56QhXZOSxIiKdvYFbLkdTep4lajZd7+pkBzFrLffXUG/2EFlkGGBjDje3DXQzBU
# q1s80oK4n0ciEY8HjuPjDTwT0oMdmp3X8bO0lcy6vdGNbM2ongZf2iCdCucA7ajf
# sg7DhV45KA73chNdpjMQuTApPZ311zesZR0pAgMBAAGjaTBnMA4GA1UdDwEB/wQE
# AwIHgDAhBgNVHREEGjAYghZNb3JmeXVtIFBvd2VyU2hlbGwgTEFCMBMGA1UdJQQM
# MAoGCCsGAQUFBwMDMB0GA1UdDgQWBBTd8PAvzPv1bN9ozqEXM8AbX7HLZDANBgkq
# hkiG9w0BAQsFAAOCAgEAcE/NRXFrIZ71EyPL6pjK4uglB+Teivl9uncYd8L2GRby
# rRrf/3IutJbNesjkWY2D55pB1lgeSfST/SJubpxaVP0dnXOzAwIkUy+fjqUI/cDC
# jc0+nx2VuMu8Z2Kly6eZQq4/X5evIlyj5C8WmIbsYZ4BOaLmePmh+jtPE9O0j1aj
# j1rdu7lYvAUN1BCBY2lZWeyXi17C97pRCHTEATG0WlBorp280f1lWfZ4TYw3a695
# iUKi1LsjLdiX5W/Z2C4Mnupk4dUie1bXgRa7qZ3UTPgrnVhyTsgUfAXGWyzX6Fnz
# UN6762BLsvb3hZsZ7l/XYmP3245Tgt/ERfbx7NjBp9xnrVg8mPW3lAqo1/0Wm/pe
# JQjyw1CXhz7Mm3aOzOEUmA92/t4L/2P+/qTE9f0sm0ob6GkqUSmQ76mRdLijH0qZ
# Y/qatF5GdWqYuDgQ2xNus5xvCTrBmumQ6q1UKZMOM+BHWgCNb0PU0N1TWNcSCJeS
# XpItWb3wN7xIbH4MPQ79WYoHaMTOXPN8Uh3WEW6tmCIbf7+ziRo2DogPy563b2p9
# nO/O0LsAKeW71ouB52CUbgYzy7vJKXH+dTISnDSpwJ4ho/biRzdFqFuzLtFl3PpJ
# Xu39PUCc5Zlzu4gxpXG0pWWyF0FPyqPqhI7ffUdirW7d1CE2P+KboJsKh8noPesx
# ggLWMIIC0gIBATA1MCExHzAdBgNVBAMMFk1vcmZ5dW0gUG93ZXJTaGVsbCBMQUIC
# EFyMqchjjqeITT/M7R0y5WQwCQYFKw4DAhoFAKB4MBgGCisGAQQBgjcCAQwxCjAI
# oAKAAKECgAAwGQYJKoZIhvcNAQkDMQwGCisGAQQBgjcCAQQwHAYKKwYBBAGCNwIB
# CzEOMAwGCisGAQQBgjcCARUwIwYJKoZIhvcNAQkEMRYEFAjhrvc83tRgyMmAFZBo
# jfkYyjd3MA0GCSqGSIb3DQEBAQUABIICADRaG7Q/3MALl2OfTWUyaOnhd3+xvwv7
# JeyOSYIQQNGeH3FzRSR8ra5gYwcYY4AjFP3PzCQXxUX4ZMk1W0xKibmDqyOWgJmQ
# 9AchgJpDONKLH/PYGNiXXh0JQtE3fT6WSrPZG2DovbgSo07wsAoNVwKh0I5VdBVB
# bv/XiQluAmNI+58oqvUPxKSdhZaf9v5GQ8hMxx73ij7rP7IG0xluj/2ohQVxDgjU
# RACn+7vH/RULCtbacCyAQeHjl5MDe5mNjwA+WzHKNoxwHZCtwRhxdeuu6Hv7xfHC
# xA+vhlJgr7BFeDPgIlAne/GTKuwdqLogA5vje3RsxHC4aS1HdGrNQaBTB2DNmgil
# xITF8Kc3pui2P7nKGSIvjVJWP1GNxGPFAYA6nEhLs0V9aQBxmDKx4Bi8VBQcIZkO
# mQXAP414zfs0x4Lhvy3cYOi7pNQpGu3jhVbgadJVCj6m5QkfZ9sdawU/Q61bgBlW
# mxJGF1V++gMN4Ftb4QdpqCza1Yz3msw9QaCLF+m67rH4H73YbMYeZlPaTQoFnDoI
# xvHA1UhPxvZETjs3AgdNmqh2upvcJdZ8UcSwGOtMHEGxkmx3NAsnu7qHHzjTJzRQ
# ee7xTvBfBBm6QDH34aI8Z0D66g02MYHwlpPOixTUfHn7Akb4Rbpiu96gO6VfTgPZ
# epAayQbyZQbH
# SIG # End signature block
