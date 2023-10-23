# Model (Business Logic)
class Model {
    [string] $Message

    Model() {
        $this.Message = Get-ExecutionPolicy
    }

    [string] GetMessage() {
        return $this.Message
    }
}

# View
function ShowView($message) {
    Write-Host $message
}

# Controller
class Controller {
    [Model] $Model

    Controller() {
        $this.Model = [Model]::new()
    }

    [string] DisplayMessage() {             # [string] because [void] has no return output
        $message = $this.Model.GetMessage()
        return $message
        ShowView $message
    }
}

# Tesztelés
$controller = [Controller]::new()
Write-Host "------    --- Component Tests ------------------     -----------------------------------------------"
Write-Host "STATUS    EXPECTED                                   RESULT                                         "
Write-Host "------    --------------------------------------     -----------------------------------------------"
$displayMassage = $controller.DisplayMessage()
if ($displayMassage -eq "RemoteSigned" ) {
    Write-Host "[PASS]    RemoteSigned                               [$displayMassage]" -ForegroundColor Green
} else {
    Write-Host "[FAIL] ... [$displayMassage]"
}