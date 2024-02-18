$selfLocation = (Get-Location).Path
$numberOfMersennePrimes = [decimal]::MaxValue
$exponent = 2
$counter = 0
$possiblePrimes = @()
$mersennePrimes = @()
$counter = [decimal]2
$maxValue = [decimal]::MaxValue

function IsPrime([decimal]$number) {
    #Write-Host "IsPrime...$number?" -ForegroundColor Yellow
    if ($number -le 1) {
        return $false
    }
    for ([decimal]$i = 2; $i -le [math]::Sqrt($number); $i++) {
        if ($number % $i -eq 0) {
            return $false
        }
    }
    #Write-Host "Prime: $($number)" -ForegroundColor Green
    return $true
}

<#function IsMersennePrime($exponent) {
    $exponent = [bigint]$exponent
    Write-Host "Exp: $exponent" -ForegroundColor Yellow
    $mersenneNumber = [bigint]::Pow(2, $exponent) - 1
    Write-Host "mer: $mersenneNumber" -ForegroundColor Yellow
    if (IsPrime($mersenneNumber)) {
        Write-Host "OK: $mersenneNumber" -ForegroundColor Yellow
        return $mersenneNumber
    } else {
        Write-Host "NULL: $mersenneNumber" -ForegroundColor Yellow
        return $null
    }
}#>

function IsMersennePrime($exponent) {
    $exponent = [bigint]$exponent
    $mersenneNumber = [bigint]::Pow(2, [bigint]$exponent) - 1
    return (IsPrime($mersenneNumber))
}

function CheckMainProcess {
    if (Get-Process -Id $MainProcessPID -ErrorAction SilentlyContinue) {
        return
    } else {
        Exit
    }
}

function RunWhileMainProcessAlive {
    $MainProcessPID = Get-Content "$selfLocation\proc\MainProcessPID"

    while ($counter -lt $maxValue) {
        [decimal]$nextValue = [Math]::Min($counter + 10000000, $maxValue)
        for ([decimal]$i = $counter; $i -le $nextValue; $i++) {
            if (IsPrime($i)) {
                $possiblePrimes += $i
                Write-Output "prime: $i"
                CheckMainProcess
                #if (IsMersennePrime($i)){
                #    Write-Host "Mersenne Found: $i" -ForegroundColor Red
                #}
            }
        }
        $counter = $nextValue + 1
    }
    $possiblePrimes
}

RunWhileMainProcessAlive -MainProcessPID $MainProcessPID