# Test, what does expecting input route go
# copy or merge with previous example: <file:///H:\data\2023\pwsh\notebooks\Pwsh\Pipeline\Expecting%20Parameters%20from%20Pipeline%20to%20render%20PSCallStack.ps1>

function pipeit {
    # standard valuefrompPipeline
    [CmdletBinding()]
    param(
        [Parameter(ValueFromPipeline)]$InputObject
    )
    begin {
        '-begin' |  Write-host -back darkyellow
        $MyInvocation.ExpectingInput | Label 'MyInvo.ExpectingInput'
        $PSCmdlet.MyInvocation.ExpectingInput | Label 'Cmdlet.ExpectingInput'
    }
    process {
        '-proc' |  Write-host -back darkyellow
        $MyInvocation.ExpectingInput | Label 'MyInvo.ExpectingInput'
        $PSCmdlet.MyInvocation.ExpectingInput | Label 'Cmdlet.ExpectingInput'
    }
    end {
        '-end' |  Write-host -back darkyellow
        $MyInvocation.ExpectingInput | Label 'MyInvo.ExpectingInput'
        $PSCmdlet.MyInvocation.ExpectingInput | Label 'Cmdlet.ExpectingInput'
        $null -eq $InputObject
    }
}

gci . | Select -first 3 | pipeIt
hr
pipeIt -InputObject (gci . | Select -first 3 )
hr
pipeIt

function pipeitFlat {
    # value from pipeline with only an end block
    [CmdletBinding()]
    param(
        [Parameter(ValueFromPipeline)]$InputObject
    )

    '-end' |  Write-host -back darkyellow
    $MyInvocation.ExpectingInput | Label 'MyInvo.ExpectingInput'
    $PSCmdlet.MyInvocation.ExpectingInput | Label 'Cmdlet.ExpectingInput'
    ($InputObject)?.GetType() ?? '<null>' | Label 'typeof { InputObject } '
    $InputObject.Count | Label 'count'
    $null -eq $InputObject

}
hr -fg magenta
gci . | Select -first 3 | pipeItFlat
hr
pipeItFlat -InputObject (gci . | Select -first 3 )
hr
pipeItFlat