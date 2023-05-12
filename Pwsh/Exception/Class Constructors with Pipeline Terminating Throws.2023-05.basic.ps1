Import-Module 'NameIt' -ea 'stop'

throw 'syntax or else extension error'
class User {
    [string]$Name
    [int]$Id

    User () {
        $this.Name = Ig 'person'
        $this.Id = Get-Random -Minimum -2 -Maximum 5

        if ($this.id -le 0) {
            $msg = 'UserCreationException: InvalidIdOutOfRange Name: {0}, Id: {1}' -f @(
                $This.Name, $this.Id
            )
            throw $msg
        }
    }

    [string] ToString() {
        '[User: {0}, Id: {1} }' -f  @(
            $this.Name ?? "`u{2400}"
            $this.Id ?? "`u{2400}"
        )
    }
}
function New-Employee {
    # pipeline partial failures
    try {
        [User]::new()
    }
    catch {
        Write-Error $_
    }
}

'New Employees: {0}, Failed {1}' -f @(
    $employees.Count ?? 0
    $error.count ?? 0
)
$error | Join-String -sep "`n"

# return
# example with pipeline termination


$employees = $Null
$error.clear() # normally you wouldn't
$employees = @(
    0..5 | ForEach-Object {
        try {
            [User]::new()
        }
        catch {
            Write-Error -ErrorRecord $_ 'NewExployeeException: Failed!'
        }
    }
)
'New Employees: {0}, Failed {1}' -f @(
    $employees.Count
    $error.count
)
$error | Join-String -sep "`n"