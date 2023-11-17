
function Dotils.ToStringEnumerate {
    <#
    .SYNOPSIS
        when you want to convert to string, but as steppable pipeline
    .NOTES
        the steppable part is likely overkill, but, this differs when using join-string even if you just want the calculated property portion of join-string

        > get-module | % tostring  | Join.UL   # 10 list items
        > get-module | Join-String | Join.UL   # 1 list item

        # which means you'd have to manually unroll the string aggregation
        # if you want to use the scriptblock param

        > get-module | %{ $_ | Join-string } | Join.UL
    #>


    #>
    [Alias('ToString', 'JoinString-NoEnumerate')]
    [CmdletBinding()]
    param(
        [Parameter(ValueFromPipeline)]
        [psobject] $InputObject
    )
    begin {
        # 2023-11-16 finish me

        'JoinString-NoEnumerate'


        $PSCmdlet.MyInvocation.ExpectingInput | Join-String -f '    ::-begin: ExpectingInput: {0}' | Write-Verbose
        $pipe = { Export-Excel @PSBoundParameters }.GetSteppablePipeline()
        $pipe.Begin($MyInvocation.ExpectingInput)
    }
    process {
        $PSCmdlet.MyInvocation.ExpectingInput | Join-String -f '    ::-proc:  ExpectingInput: {0}' | Write-Verbose
        $pipe.Process( [string]$PSItem )
    }
    end {
        $PSCmdlet.MyInvocation.ExpectingInput | Join-String -f '    ::-end:   ExpectingInput: {0}' | Write-Verbose
        $pipe.End()
    }
}
