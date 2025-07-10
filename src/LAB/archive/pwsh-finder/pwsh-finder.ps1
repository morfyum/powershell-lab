# DEVELOPER: morfyum  # EMAIL: morfyum@gmail.com  # LICENSE: pass

[CmdletBinding()]
param (
    [string] $param1,             # $1 input param
    [string] $param2,             # $2 input param
    [switch] $Match,              # $any input param
    [string] $param3,             # $3 input param
    [switch] $Contain             # $any input param
)


# BASIC FINDER COMMAND
$value_match = ""
$value_contain = ""
$finder_command = 'Get-ChildItem -Path $param1 -Recurse -ErrorAction SilentlyContinue'
$finder_command_end = ' | %{$_.FullName}'
$finder_result_command = $finder_command


# Standard variables
$last_path_file = "last_path.txt"
$last_tree_file = "last_tree.txt"


# custom pre-defined object
#[pscustomobject]@{
#firstname = 'Prateek'
#lastname = 'Singh'
#}
# custom object
$finder_obj = New-Object -TypeName psobject
$finder_obj | Add-Member -MemberType NoteProperty -Name Name -Value "File/???"
$finder_obj | Add-Member -MemberType NoteProperty -Name path -Value $line
# add a method to an object
#$obj | Add-Member -MemberType ScriptMethod -Name "GetName" -Value {$this.firstname +' '+$this.lastname}



# Functions
function useLastPath {
    #PASS
}

# Example code
function pwshFinderExample1 {
    Write-Host "Example: ./pwsh-finder.ps1 ./ -Match something" -ForegroundColor Yellow
}


function pwshFinderHelpMenu {
    Write-Host " --- HELP MENU ---
finder.ps1 help                     # Show this menu
    finder.ps1 ./                   # List all file/folder under ./ recursively,
    finder.ps1 C:/Users             # List all file/folder under C:/Users/ recursively,
                                    # show all file with name Def
                                    # OUTPUT: C:\Users\Default
                                    # WARNING: List files under user dirs!
    finder.ps1 ./ -Match txt        # List *txt* files under ./ recursively

    # List *txt* files and search 'name' string in listed files
    finder.ps1 ./ -Match txt -Contain name



    " -ForegroundColor Gray
}



# BASIC ERROR HANDLING
if ($param1 -eq "help") {
    pwshFinderExample1
    pwshFinderHelpMenu
    Exit 0
}
elseif ($param1 -eq "") {
    Write-Host "Empty find path... Exit 1" -ForegroundColor Red
    pwshFinderExample1
    pwshFinderHelpMenu
    Exit 1
}


# SWITCH MANAGEMENT
# test -Match
if ($Match -eq $True) {
    if ($param2 -eq ""){
        Write-Host "Missing argument, exit 2" -ForegroundColor Red
        Exit 2
    } else {
        $value_match = $param2
        $Match_commands =  ' -Filter *$value_match*'
        $finder_result_command = $finder_result_command+$Match_commands
    }
}
#  test -FindInFile
if ($Contain -eq $True ) {
    if ($Match -eq $False -and $param2 -eq "" -or $Match -eq $True -and $param3 -eq ""){
        Write-Host "Missing argument, exit 2" -ForegroundColor Red
        Exit 2
    }
    else {
        #PASS
    }
}



# Add last command, finish finder_result_command building...
$finder_result_command = $finder_result_command+$finder_command_end

#Debug
#Write-Host "COMMAND: $finder_result_command" -ForegroundColor Gray

# Execute command

function finderOnFilesystem {
    Write-Host "**** Finder [ $param1*$param2* ] ****" -ForegroundColor Cyan
    Invoke-Expression $finder_result_command > result.list

    foreach($line in Get-Content .\result.list) {
            Write-Output $line
    }
}

function finderInFiles {
    #search in files

        Write-Host "**** Search in files [ $param3 ] ****" -ForegroundColor Cyan

        foreach($line in Get-Content .\result.list) {
            if ($param3 -eq "") {
                $value_contain = $param2
            }
            else {
                $value_contain = $param3
            }

            $find_strings = Select-String -Path $line -Pattern $value_contain
            $find_strings
        }

}


# EXECUTION PATH

finderOnFilesystem

if ($Contain -eq $True) {
    finderInFiles
}

<#
# SCRIPT
Write-Host "**** Search [ $param1 ] / [ *$param2* ] ****" -ForegroundColor Cyan
$found_files = Get-ChildItem -Path $param1 -Filter *$param2* -Recurse -ErrorAction SilentlyContinue | %{$_.FullName}
$found_files

Write-Host "**** Search in files for [ $param1 ] / [ *$param3* ] ****" -ForegroundColor Cyan
$found_strings = Select-String -Path $found_files -Pattern $param3
$found_strings
#>
