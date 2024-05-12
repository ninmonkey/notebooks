function MiniCountOf {
    <#
    .EXAMPLE
        🐒> 'a'..'z' | MiniCountOf -OutNull
        # out:
            26 Items, First: System.Char

    .EXAMPLE
        🐒> 0..10 | MiniCountOf | Join-String -sep ', '

        # out:
            11 Items, First: System.Int32
            0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10

    .EXAMPLE
        🐒>
        'a'..'f'
            | Add-Content -path 'append.txt' -PassThru
            | MiniCountOf
            | Join-String -sep ', ' -op 'Adding records: '
            | Write-Host -bg 'gray15' -fg 'gray70'

        # out:
            6 Items, First: System.Object[]
            Adding records: a, b, c, d, e, f
    #>
    [CmdletBinding()]
    param(
        # Show type names of collection and items
        [Parameter(ValueFromPipeline)]
        [object]$InputObject,
        # output objects and the summary, or use Out-Null too
        [switch]$OutNull
    )
    begin {
        [int]$totalCount = 0
        [Collections.Generic.List[Object]]$Items = @()
        $Config = $Options
    }
    process {
        $Items.Add( $InputObject )
    }
    end {
        if( -not $OutNull ) {
            $items
        }
        $Msg =
            if($Items.Count -eq 0) {
                'Empty List'
            } else {
                '{0} Items, First: {1}' -f @(
                    $Items.Count
                    @( $Items )[0]?.GetType()
                )
            }

        $Msg | Write-Host -fg '#362b1f' -bg '#f2962d'
    }
}
