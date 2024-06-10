# Best Practices for PowerShell => Focus Consistency 

## Naming Conventions

### Variables
    - First letter starts with lowercase, every other word comes Uppercase
```ps
variableName = "Something"
```

### Functions
    - Function name starts with Uppercase letter
    - 
```
function DescriptFunction
```

### PowerShell internal Database

```ps
class MyModel {
    [string] $Value1
    [string] $Value2
}

$MyModelList = @()

# REPEAT THIS SECTION OR USE A FUNCITON TO MANAGE ADD 
$myModelInfo = [MyModel]::new()
$myModelInfo.Value1 = "a"
$myModelInfo.Value2 = "b"

$MyModelList += $myModelInfo
```

```ps
class MyModel {
    [string] $Value1
    [string] $Value2
}

$MyModelList = @()

# REPEAT THIS SECTION OR USE A FUNCITON TO MANAGE ADD 
function AddToUnknownDeviceLista {
    param (
        [Parameter(mandatory=$true)]
        [int] $Value1,
        [Parameter(mandatory=$true)]
        [int] $Value2
    )
    $myModelInfo = [MyModel]::new()
    $myModelInfo.Value1 = $Value1
    $myModelInfo.Value2 = $Value2
    $global:MyModelList += $myModelInfo
 }
```


