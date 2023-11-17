function CollectThenDoStuff {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, ValueFromPipeline)]
        [object[]]$InputObject
    )
    begin {
        [Collections.Generic.List[object]]$items = @()
    }
    process {
        $items.AddRange( $InputObject )
    }
    end {
        $items | Sort-Object | Join-String -sep ', '
    }
}

function DoStuff {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, ValueFromPipeline)]
        [object[]]$InputObject
    )
    begin {}
    process {
        $InputObject | Sort-Object | Join-string -sep ', '
    }
    end {
    }
}
$text = 'a'..'e'

hr

DoStuff -Inp $text
    # out: "a, b, c, d, e"

$Text | DoStuff
    # out: ["a","b","c","d","e"]

CollectThenDoStuff -inp $text
    # out: "a, b, c, d, e"

$Text | CollectThenDoStuff
    # out: "a, b, c, d, e"
