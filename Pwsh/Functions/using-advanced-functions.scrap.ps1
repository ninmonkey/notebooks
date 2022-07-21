$C = @{
    dimBlue      = [rgbcolor]'515c6b'
    consoleGreen = [rgbcolor]'4cd189'
    Yellow       = [rgbcolor]'4cd189'
}
$Env:No_COLOR = $True;
function newLabel {
    param(
        $CommandName
    )
    if ($ENV:NO_COLOR) {
        "$CommandName |"
        return
    }

    @(
        $C.dimBlue
        $C.Yellow
        $CommandName
        $PSStyle.Reset
    ) -join ''
}
function pipe1 {
    param(
        # from pipeline or not
        [Parameter(ValueFromPipeline)]
        $InputObject
    )
    begin {
        # $Label = $MyInvocation.InvocationName
        # "$Label -> begin -> x = $InputObject"
        $Label = NewLabel $MyInvocation.InvocationName
        $toPad = $Label.length
        $Pre = ' -> '.PadLeft($ToPad)
        # "$Label -> begin -> x = $InputObject"
        "$Pre $Label -> begin -> x = $InputObject"
    }
    Process {
        # "   $Label ->  proc -> x = $InputObject"
        # "        ->  proc -> x = $InputObject"
        "$Pre $Label -> proc -> x = $InputObject"
        "$pre proc -> x = $InputObject"
    }
    end {
        "$Label ->   end -> x = $InputObject"

    }
}
H1 'pipe1'
pipe1 'cat'

# -----

function newLabel {
    param(
        $CommandName
    )

    "$CommandName |"


}
H1 'pipe2'
function pipe2 {
    param(
        # from pipeline or not
        [Parameter(ValueFromPipeline)]
        $InputObject
    )
    begin {
        # $Label = $MyInvocation.InvocationName
        # "$Label -> begin -> x = $InputObject"
        $Label = NewLabel $MyInvocation.InvocationName

        # $toPad = $Label.length
        # $Pre = ' -> '.PadLeft($ToPad)
        # # "$Label -> begin -> x = $InputObject"
        # "$Pre $Label -> begin -> x = $InputObject"
        "$Label -> begin -> x = $InputObject"


    }
    Process {
        # "   $Label ->  proc -> x = $InputObject"
        # "        ->  proc -> x = $InputObject"
        "$Pre $Label -> proc -> x = $InputObject"
        "$pre proc -> x = $InputObject"
    }
    end {
        "$Label ->   end -> x = $InputObject"

    }
}
Hr

Hr
H1 'pipe2'
pipe2 'cat'

Hr

H1 'pipe3'
pipe3 'cat'

$Env:No_COLOR = $null