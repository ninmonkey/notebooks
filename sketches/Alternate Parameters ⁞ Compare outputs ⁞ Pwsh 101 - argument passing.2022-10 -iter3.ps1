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
    switch($MyInvocation.InvocationName) {
        'SideNote' { 
            $Color = 'blue'
            $Prefix = 'SideNote: '
        }
        default {
            $Color = 'yellow'
            $Prefix = 'Note: '
        }

    }
        "${Prefix}$Text" | write-host -fore $Color
        "${Prefix}$Text" | write-host -fore $Color
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
    # version: showHash.2
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
    [Alias('showHash.2')]
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
    # version: showArray.2
    <#
    .synopsis
        pretty print arrays, making tests easier to visualize
    .example
        Pwsh> showArray ('z'..'y' + 0..4 + 'a'..'b') stuff -Csv

            == stuff, Length = 9 ==

            z, y, 0, 1, 2, 3, 4, a, b
    .EXAMPLE
        showArray @(0..4)
        showArray @(0..4) -Csv
    .NOTES
        future: will add data types
    #>
    [Alias('ShowArray.2')]
    param (
        # What to print
        $Array,
        [string]$Label = '[Object[]] Array',
        
        # Number of columns to align text with. Set to 0 to disable it
        [int]$PadLeft = 6,

        # print CSV instead?
        [Alias('AsCsv')][switch]$Csv
    )
    if($Label) { 
        "`n == $Label, Length = $($Array.Count) ==`n"
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

        [object]$ArgsRemaining,
        
        # Shorter output, good for longer arrays
        [Alias('AsCsv')][switch]$Csv,
        # set to non-zero value to limit max lines to print
        [int]$AutoCsv = 0
    )
    if($AutoCsv -gt 0 -and $ArgsRemaining.count -gt $AutoCsv) {
        $Csv = $true
    }
    
    $newBound = [hashtable]::new( $BoundParametersObj ) # potentially not required
    showHash $BoundParametersObj -Label '$PSBoundParameters'
    # showHash $PSBoundParameters -Label 'My $PSBoundParameters'
    # showHash $NewBound -Label '$newBound'
    
    showArray $ArgsRemaining -Label "UnboundArgs: $($UnboundArgs.count)" -Csv:$Csv
    # showArray $ArgsRemaining -Label "UnboundArgs: $($UnboundArgs.count)" -csv:(-not $AsList)
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
    <#
    .SYNOPSIS
        function that has one 
    #>
    param(
        [String]$Text1,
        [string]$Extra
    )    
    
    # showHash $PSBoundParameters 'PSBoundParameters'
    # showArray 
    showArgs $PSBoundParameters $Args
    return
    # showArgs $PSBoundParameters $Args
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

PString 'a', 'b' 'c' 'd' 0, 4, 5
hr
PString 'a', 'b' 'c' 'd'
hr
return

Note @'
Notice how "Text1 == str1 str2", how does that work? 
The first positional parameter's type is one [String] string, not a list of strings
The first positional argument is resolving to [String[]]
That array is coerced into a single string. 
    
It's implicitly evaluating like this

    PString -Text1 ($str1, $str2) $str3 $str4

or

    $Text1 = $str1, $str2 
    $Unbound = $str3, $str4   

    $s
the value passed was "str1, str2" which is an array. Meaning type [string[]]

it''s as if you had used

$Text1 = $str1, $str2
$Remaining = $str3, $str4


What''s happening is and "str2" are implicitly joined as one [string]
happens when an array, in this case [String[]] is passed to [string] parameter
It implicitly joine
'
'@
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


write-warning 'I can maybe abstract using callstack or myinvocation info istead of the user caring? or will some contexts break?
    ideal is user just runs ShowCmdInfo()'