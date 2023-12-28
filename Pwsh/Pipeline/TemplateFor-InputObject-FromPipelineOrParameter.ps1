Using namespace System.Collections.Generic

function CollectListTemplate {
    <#
    .synopsis
        This example collects all inputs regardless of the input mode. position parameter 'Label' works without ke
    .DESCRIPTION

        'a'..'e' | CollectList  -Label 'stuff'
        'a'..'e' | CollectList  -Label 'stuff'
        'a'..'e' | CollectList  'stuff'
        'a'..'e' | CollectList
        CollectList -In ('a'..'e')
        CollectList -In ('a'..'e') 'stuff'
        CollectList -In ('a'..'e') -Label Stuff
    #>
    [Alias('CollectList')]
    [CmdletBinding(DefaultParameterSetName='FromPipe')]
    param(
        # object input
        [Parameter( Mandatory, ParameterSetName='FromPipe',  ValueFromPipeline )]
        [Parameter( Mandatory, ParameterSetName='FromParam', Position = 0 )]
        # should empty lists and null values spam the user with binding errors?
        # if not, use these attributes
        [AllowEmptyCollection()]
        [AllowEmptyString()]
        [AllowNull()]
        [object[]]
        $InputObject,

        # something to test positional binding without the parameter name
        [Parameter( ParameterSetName='FromPipe',  Position = 0 )]
        [Parameter( ParameterSetName='FromParam', Position = 1 )]
        [ArgumentCompletions('Stuff')]
        [string]$Label

    )
    begin {
        [List[Object]]$items = @()
    }
    process {
        if( -not  $PSCmdlet.MyInvocation.ExpectingInput ) {
            $Items = $InputObject
        } else {
            $Items.AddRange(@( $InputObject ))
        }
    }
    end {
        $items | Sort-Object
    }
}
function CollectListTemplateWithDebug {
    <#
    .synopsis
        This is the same code with extra logging, to visualize the pipeline
    .DESCRIPTION

        'a'..'e' | CollectList  -Label 'stuff'
        'a'..'e' | CollectList  -Label 'stuff'
        'a'..'e' | CollectList  'stuff'
        'a'..'e' | CollectList
        CollectList -In ('a'..'e')
        CollectList -In ('a'..'e') 'stuff'
        CollectList -In ('a'..'e') -Label Stuff
    #>
    [Alias('CollectListDebug')]
    [CmdletBinding(DefaultParameterSetName='FromPipe')]
    param(
        [Parameter( Mandatory, ParameterSetName='FromPipe',  ValueFromPipeline )]
        [Parameter( Mandatory, ParameterSetName='FromParam', Position = 0 )]
        [AllowEmptyCollection()]
        [AllowEmptyString()]
        [AllowNull()]
        [object[]]
        $InputObject,

        # something to test positional binding without the parameter name
        [Parameter( ParameterSetName='FromPipe',  Position = 0 )]
        [Parameter( ParameterSetName='FromParam', Position = 1 )]
        [ArgumentCompletions('Stuff')]
        [string]$Label

    )
    begin {
        [List[Object]]$items = @()
    }
    process {
        @(
            $h = (@{} + $PSBoundParameters)
            $h.remove('InputObject')
            $h.remove('InformationAction')

            Join-String -f 'ExpectInput := {0}'      -Inp $PSCmdlet.MyInvocation.ExpectingInput
            Join-String -f 'ParamSet    := {0}'      -Inp $PSCmdlet.ParameterSetName
            Join-String -f 'InputObject := [ {0} ] ' -Inp ( $InputObject | Join-String -sep ', ' )

            $h | ConvertTo-Json -depth 3 -Compress
               | Join-String -f 'PSbound     := {0}'

        )
            | Join-String -op "-Proc {`n" -os "`n}" -sep "`n" -f "   {0}"
            # comment out New-Text if you don't have [pansies] installed
            | New-Text -fg 'gray50' -bg 'gray20'
            | Write-Information

        if( -not  $PSCmdlet.MyInvocation.ExpectingInput ) {
            $Items = $InputObject
        } else {
            $Items.AddRange(@( $InputObject ))
        }
    }
    end {
        $items | Sort-Object
    }
}
$Examples = @{
    SuperVerbose = $true
}


if($Examples.SuperVerbose ) {
    $PSDefaultParameterValues['CollectListDebug:Infa'] = 'Continue'
    $gci = Gci . |select -first 2| CollectListDebug
    $gci = CollectListDebug -InputObject (gci . | select -First 1)
    ' ', "`n", '', $null |   CollectListDebug
    'a'..'e' | CollectListDebug  -Label 'stuff'
    'a'..'e' | CollectListDebug  'stuff'
    'a'..'e' | CollectListDebug
    CollectListDebug -In ('a'..'e')
    CollectListDebug -In ('a'..'e') 'stuff'
    CollectListDebug -In ('a'..'e') -Label Stuff

} else {
    # $PSDefaultParameterValues['CollectList:Infa'] = 'Continue'
    $gci = Gci . |select -first 2| CollectList
    $gci = CollectList -InputObject (gci . | select -First 1)
    ' ', "`n", '', $null |   CollectList
    'a'..'e' | CollectList  -Label 'stuff'
    'a'..'e' | CollectList  'stuff'
    'a'..'e' | CollectList
    CollectList -In ('a'..'e')
    CollectList -In ('a'..'e') 'stuff'
    CollectList -In ('a'..'e') -Label Stuff

}
