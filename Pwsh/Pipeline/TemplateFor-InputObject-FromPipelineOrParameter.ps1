Using namespace System.Collections.Generic
function CollectListTemplate {
    <#
    .synopsis
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
        [Parameter( Mandatory, ParameterSetName='FromPipe',  ValueFromPipeline )]
        [Parameter( Mandatory, ParameterSetName='FromParam', Position = 0 )]
        [object[]]
        $InputObject,

        # sample text
        [Parameter( ParameterSetName='FromPipe',  Position = 0 )]
        [Parameter( ParameterSetName='FromParam', Position = 1 )]
        [ArgumentCompletions('Stuff')]
        [string]$Label

    )
    begin {
        [List[Object]]$items = @()
    }
    process {
        '-Proc {'
            | New-Text -fg 'gray50' -bg 'gray20' | Write-Information
        '}'
            | New-Text -fg 'gray50' -bg 'gray20' | Write-Information
        Join-String -f '-Proc {{ }} ExpectInput? {0}' -in $PSCmdlet.MyInvocation.ExpectingInput
            | New-Text -fg 'gray50' -bg 'gray20' | Write-Information

        Join-String -f '   InputObject: [ {0} ] ' -inp ( $InputObject | Join-String -sep ', ' )
            | New-Text -fg 'gray50' -bg 'gray20' | Write-Information

        # $InputObject -join ', '
        $PSBoundParameters
            | ConvertTo-Json -depth 3 -Compress
            | Join-String -op (Join-String -f '    As {0}: ' -In $PSCmdlet.ParameterSetName)
            | New-Text -fg 'gray50' -bg 'gray20' | Write-Information
            # | Dotils.Write-DimText



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

$PSDefaultParameterValues['CollectList:Infa'] = 'Continue'
'a'..'e' | CollectList  -Label 'stuff'
'a'..'e' | CollectList  -Label 'stuff'
'a'..'e' | CollectList  'stuff'
'a'..'e' | CollectList
CollectList -In ('a'..'e')
CollectList -In ('a'..'e') 'stuff'
CollectList -In ('a'..'e') -Label Stuff
