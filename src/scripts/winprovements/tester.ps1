# String Length Calculator


function Tester() {
    Param(
        [Parameter(Mandatory = $true)] [string] $stringName,
        [Parameter(Mandatory = $true)] [int] $lengthLimit
    )

    #$lengthLimit = $Host.UI.RawUI.WindowSize.Width /2

    #Write-Host "Name:", $stringName
    #Write-Host "Limit:", $lengthLimit

    #$terminal_width = $Host.UI.RawUI.WindowSize.Width
    #Write-Host "Width: $terminal_width"

    $separator_string = "."
    $relative_separator = ""
    $string_name_length = ($stringName).Length

    if ($string_name_length -gt $lengthLimit) {
    
        #Write-Host "String is longer than limit: $string_name" -ForegroundColor Red
        $stringName = ($stringName).Substring(0, $lengthLimit-3)
        $string_name_length = ($stringName).Length
    
    }


    $required_chars = $lengthLimit - $string_name_length


    for ( ($counter=0); ($counter -lt $required_chars ); $counter++ ) {
        $relative_separator = $relative_separator + $separator_string
    }

    $array = @()
    $obj = new-object psobject
 
    $obj | Add-Member -MemberType NoteProperty -Name "TestName" -Value $stringName
    $obj | Add-Member -MemberType NoteProperty -Name "TestResult" -Value $null
    $array += $obj

    $result = " $(($array).TestName) $relative_separator"
    return $result
}


Tester "First-Test" 40
Tester "Second-Test" 40
Tester "Third-extreme-long-Test-name-for-fail" 40




$a = "a","b","c","d"
$b = 1,2,3,4

$array = @()
for ( ($counter=0); ($counter -lt $a.Length ); $counter++ ) {

    $obj = new-object psobject
 
    $obj | Add-Member -MemberType NoteProperty -Name "Name" -Value $a[$counter]
    $obj | Add-Member -MemberType NoteProperty -Name "Value" -Value $b[$counter]
 
    $array += $obj

}
echo $array
echo "----------"