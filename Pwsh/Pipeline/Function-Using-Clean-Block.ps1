#Requires -Version 7.3

'See: <https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_functions_advanced_methods?view=powershell-7.4#clean>'

function DoStuff {
    [CmdletBinding()]
    param(
        # throw an exception that's handled
        [switch]$ForceFail,

        # throws an exception type that's not expected
        [switch]$ForceUnexpected
    )
    end {
        sleep .75
        if( $ForceUnexpected ) {
            Get-Item -ea 'Stop' 'foo\bar\does\not-exist.md'
        }
        if( $ForceFail ) {
            throw 'Bad🔴'
        }
        'Good🟢'
    }
    clean {
        # 7.3+ added the clean {... } block.
        # see more: <https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_functions_advanced_methods?view=powershell-7.4#clean>
        'DoStuff() => clean' | write-host -fore blue
    }
}
function Main {
    param(
        [switch]$ForceFail,
        [switch]$ForceUnexpected
    )
    try {
        'Main() => try ' | write-host -fore blue
        DoStuff -ForceFail $ForceFail -ForceUnexpected $ForceUnexpected
    } catch {
        if( $_.ToString() -match 'bad🔴' ) {
            'Main() => expected fail'
        } else {
            throw $_ # let other error types bubble
        }
    }
    finally {
        'Main() => finally' | write-host -fore blue
    }
}

## Examples
DoStuff # clean. no errors
DoStuff -ForceFail # force the expecteded error
DoStuff -ForceUnexpected # force the expecteded error

## examples wrapping DoStuff
Main
Main -ForceFail
DoStuff -ForceUnexpected:$false
# DoStuff -ForceUnexpected:$false -ForceFail
# DoStuff -ForceUnexpected:$true
