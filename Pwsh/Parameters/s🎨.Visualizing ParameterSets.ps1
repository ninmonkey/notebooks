using namespace System.Management.Automation
function pipeTest {
    [CmdletBinding(DefaultParameterSetName = 'Int')]
    param(
        [Parameter(Mandatory, ValueFromPipeline, ParameterSetName = 'Guid')]
        [guid]$Guid,

        [Parameter(Mandatory, ValueFromPipeline, ParameterSetName = 'Int')]
        [int]$Int,

        [Parameter(Mandatory, ValueFromPipeline, ParameterSetName = 'Module')]
        [PSModuleInfo]$Module
    )

    process {
        # $PSBoundParameters | Format-Table -auto
        # $ParamSetName = $PSCmdlet.ParameterSetName
        @(
            H1 'invoke'
            $PSCmdlet
            | Join-String -op "`nInvoke: ParamSet -> " {
                $_.ParameterSetName } -double

            $PSBoundparameters
            | Format-HashTable -FormatMode Pair -Title 'PSBoundParameters'
            # | Format-Hashtable -FormatMode Pair
        )
        | ForEach-Object { $_ | Join-String -op '    ' }


        # $PSBoundParameters.BoundPositionally | fm

        # $PSCmdlet.ParameterSetName.count
        # return
        # ps
        switch ($PSCmdlet.ParameterSetName) {
            'Int' {
                doIntStuff

            }
            'String' {
                [Guid]$coerced = $InputObject
                doIntStuff
            }
            'Guid' {
                break
            }
            'Module' {
                break

            }

            default {
                # "-> as $($PSCmdlet.ParameterSetName)"
                throw "Unhandled ParameterSet: $($PSCmdlet.ParameterSetName)"
            }
        }
    }
}

$strGoodGuid = 'd171a667-7dc5-473f-8ab1-dabeb3d66aa7'
$strBadGuid = 'd171a667-7dc5-473f-8ab1-dabeb3d66aa'
@(
    pipeTest -Guid (New-Guid)
    pipeTest -Int '324325'
    '2132' | pipeTest
    2132 | pipeTest

    # works
    (New-Guid) | pipeTest

    # as guid
    $strGoodGuid | pipeTest -ea 'ignore'
    # throws exception
    $strBadGuid | pipeTest

)