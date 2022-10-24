function Hrr {
    # and padding and draw a horizontal rule for visiblity
    $numberOfColumns = $host.ui.RawUI.WindowSize.Width
    $Line = '-' * $numberOfColumns -join ''
    "`n`n$Line`n`n"
}
function showArgs { 
    param( 
        [string]$Name,
        $Value
    )
    "$Name is '$Value'"
}
function PString {
    param(
        [String]$Text 
    )    
    "`$PSBoundParameters:"
    # $PSBoundParameters | Ft -AutoSize
    "PSBoundParameters"
    $PSBoundParameters.GetEnumerator() | %{ 
        $Key = $_.Key ; $Value = $_.value
        "$Key = $Value"
    }
    hr
    hr

    [pscustomobject] [hashtable]::New($PSBoundParameters) | ft -auto
hr

    "`$Text = $Text"
    "Uncaught args: $( $args.Count )"    

    $args
}

PString 'text'

hr

PString 'text' 'str2'

hr
PString 'text', 'str2'