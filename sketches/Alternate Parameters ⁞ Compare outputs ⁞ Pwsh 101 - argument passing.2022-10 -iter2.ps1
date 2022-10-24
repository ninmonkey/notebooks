function Note { 
    <#
    .SYNOPSIS
        allows inline text, which can be formatted special --- or even disabled globally
    .EXAMPLE
        Note 'foo bar'
        SideNote 'foo bar'

    .EXAMPLE
        Note 'foo bar'
        $script:DisableSideNotes = $true
        Note
            <nothing>
    #>
    # sugar for tutorial notes
    [Alias('SideNote')]
    [CmdletBinding()]               
    param( 
        [Parameter(Mandatory, ValueFromRemainingArguments)]
            [string]$Text )

    if($script:DisableNotes) { return } 

    "Note: $Text" | write-host -fore yellow
}
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

if($ShowTestOutput) { 
    showArray (0..3) stuff
    showArray (0..3 + 'a'..'c') -Csv stuff
    showArray ('a', $null, 'e') 'Include a null'
}

function ShowArgs  { 
    <#
    .SYNOPSIS
        This function is sautomatic, see showHast() and showArray() for control
    #>
    param(
        [hashtable]$BoundParametersObj,

        [object]$ArgsRemaining
    )
    'newBound'
    $newBound = [hashtable]::new( $BoundParametersObj )
    hr
    showHash $BoundParametersObj -Label 'my paramFor $PSBoundParameters'
    showHash $PSBoundParameters -Label 'My $PSBoundParameters'
    showHash $NewBound -Label '$newBound'
    showArray $ArgsRemaining -Label '$Args ( remaning args )' -Csv
}
function PString.0 {
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

    [pscustomobject] [hashtable]::New($PSBoundParameters) | ft -auto
hr

    "`$Text = $Text"
    "Uncaught args: $( $args.Count )"    

    $args
}

function PString {
    param(
        [String]$Text1
    )    
    
    # showHash $PSBoundParameters 'PSBoundParameters'
    # showArray 
    showArgs $PSBoundParameters $Args
    # showArgs $PSBoundParameters $Args
    return
    "`$PSBoundParameters:"
    # $PSBoundParameters | Ft -AutoSize
    "PSBoundParameters"
    $PSBoundParameters.GetEnumerator() | %{ 
        $Key = $_.Key ; $Value = $_.value
        "$Key = $Value"
    }
hr
    [pscustomobject] [hashtable]::New($PSBoundParameters) | ft -auto
hr

    "`$Text = $Text"
    "Uncaught args: $( $args.Count )"    

    $args
}
Note 'Notice how "Text1 = str1 str2", how does that work? 
the parameter is a single string, meaning type [string]
the value passed was "str1, str2" which is an array. Meaning type [string[]]

it''s as if you had used

$Text1 = $str1, $str2
$Remaining = $str3, $str4


What''s happening is and "str2" are implicitly joined as one [string]
happens when an array, in this case [String[]] is passed to [string] parameter
It implicitly joine
'

$Text1 = $str1, $str2
$Unbound = $str3, $str4
PString -Text1 $Text1 $unbound
SideNote 'Side note, you could use the splat operator here, to pass a list as unbound
verses one parameter to a list 
    PString -Text1 $Text1 @unbound

'

PString 'str1', 'str2' 'str3' 'str4'



PString 'str1', 'str2' 'str3' 'str4'

PString 'text'

hr

PString 'text' 'str2'

hr
PString 'text', 'str2'