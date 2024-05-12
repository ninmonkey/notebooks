function MiniCountOf {
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
