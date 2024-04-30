function Cats {
    [CmdletBinding()]
    param(
        [switch]$FailOptional,
        [switch]$FatalFail
    )
    $PSCmdlet.MyInvocation.MyCommand.Name
        | Join-String -f 'Enter => {0}'
        | Write-verbose -verb

    # $PSCmdlet.MyInvocation.ScriptLineNumber ~33
    if($FailOptional) {
        write-error 'OptionalBad from Cat'
    }
    if($FatalFail) {

        throw "Bad Stuff in cats"
    }

}

function Dog {
    [CmdletBinding()]
    param(
        [switch]$FailOptional,
        [switch]$FatalFail
    )
    $PSCmdlet.MyInvocation.MyCommand.Name
        | Join-String -f 'Enter => {0}'
        | Write-verbose -verb
    if($FailOptional) {
        write-error 'OptionalBad from dog'
    }

    try {
        if($FatalFail)  {
            Cats -FatalFail
        } else {
            write-error 'dog not fatal, but complain anyway'
            Cats
        }
    } catch {
        $_ | Write-host
        ''
    }


    # Cats -FailOptional $FailOptional -Fatal $fatalFail

}
$Error.Clear()
Dog
$Error.Count
# Cats
# Dog -FailOptional
