<# List 
EXAMPLE PATHS:
    C:\Windows\Microsoft.NET\Framework\v4.0.30319\System.dll
    C:\Users\mars\Desktop\TestDLL.dll
#>
$a = "C:\Windows\Microsoft.NET\Framework\v4.0.30319\System.dll"
$b = "C:\Users\mars\Desktop\TestDLL.dll"
$c = "C:\Windows\Microsoft.NET\Framework\v4.0.30319\WPF\PresentationFramework.dll"

function analyzeDLL {
    param (
        [string] $DLLPath
    )
    $assembly = [System.Reflection.Assembly]::LoadFrom("$DLLPath")
    $types = $assembly.GetTypes()
    
    foreach ($type in $types) {
        $type.FullName
        #$type.GetMethods() | Select "ReflectedType"
    }
}

Write-Host "*** METHODS ***" -ForegroundColor Green
analyzeDLL -DLLPath $b | ForEach-Object {
    Write-Host "- $_"
}

function callMethod {
    param (
        [string] $DLLPath,
        [string] $DLLMethod
    )
    Add-Type -Path "$DLLPath"

    $newObject = New-Object $DLLMethod
    $result = $newObject.TestMethod()

    Write-Output $result
}

Write-Host "*** Call Method ***" -ForegroundColor Green
callMethod -DLLPath $a -DLLMethod "TestDLL.HelloWorld"