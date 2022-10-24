function Hr {
    <#
    .SYNOPSIS
        Print a horizontal ruler to separate text 
    .example
        Pwsh> Hr

            ----------------------------------            
    #>
    # and padding and draw a horizontal rule for visiblity
    $numberOfColumns = $host.ui.RawUI.WindowSize.Width
    $Line = '-' * $numberOfColumns -join ''
    "`n`n$Line`n`n"
}

function showHash {
    <#
    .synopsis
        pretty print hashtables, making tests easier to visual
    .DESCRIPTION
        written to work with or without [CmdletBinding()] style functions
    .example
        showHash @{ a = 3 ; 9 = 20}
        showHash @{ a = 3 ; 9 = 20} 'stuff'
        showHash @{ a = 3 ; 9 = 20} -PadL 0
    .NOTES
        future: will add data types
    #>
    param (
        # What to print
        [hashtable]$Hash,
        
        # Name printed as the heading text
        [string]$Label = '[Hashtable]',

        # Number of columns to align text with. Set to 0 to disable it
        [int]$PadLeft = 10
    )
    if($Label) { 
        "`n ==  $Label == `n"
    }
    $Hash.GetEnumerator() | ForEach-Object { 
        $Key = $_.Key ; $Value = $_.value
        $KeyAligned = $Key.ToString().padLeft( $PadLeft, ' ')
        if($null -eq $Value) { $Value = "<TrueNull>"}
        "$KeyAligned = $Value"
    }
}
function showArray { 
    # version: showArray.1
    <#
    .synopsis
        pretty print arrays, making tests easier to visualize
    .example
        Pwsh> showArray ('z'..'y' + 0..4 + 'a'..'b') stuff -Csv

            == stuff, Length = 9 ==

            z, y, 0, 1, 2, 3, 4, a, b
    .NOTES
        future: will add data types
    #>
    [Alias('ShowArray.1')]
    param (
        # What to print
        $Array,
        [string]$Label = '[Object[]] Array',
        
        # Number of columns to align text with. Set to 0 to disable it
        [int]$PadLeft = 6,

        # print CSV instead?
        [switch]$Csv
    )
    if($Label) { 
        "`n == $Label, Length = $($Array.Count) == `n"
    }
    $Array  = $Array | %{
        if($null -eq $_) {
            "<TrueNull>"
        } else { $_ }
    }
    if($Csv) { 
        $Array -join ', ' 
        return
    }
    "$As"
    $index = 0
    foreach($item in $Array) { 
        $IdAligned = $Index.ToString().PadLeft( $PadLeft, ' ')
        "$IdAligned = $Item" 
        $Index++
    }
}

showArray (0..3) stuff
showArray (0..3 + 'a'..'c') -Csv stuff
showArray ('a', $null, 'e') 'Include a null'
return
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