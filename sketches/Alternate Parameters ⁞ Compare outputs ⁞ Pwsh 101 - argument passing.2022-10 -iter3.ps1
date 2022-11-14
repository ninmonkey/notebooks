hr


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

    if ($script:DisableNotes) { return }
    switch ($MyInvocation.InvocationName) {
        'SideNote' {
            $Color = 'blue'
            $Prefix = 'SideNote: '
        }
        default {
            $Color = 'yellow'
            $Prefix = 'Note: '
        }

    }
    "${Prefix}$Text" | Write-Host -fore $Color
    "${Prefix}$Text" | Write-Host -fore $Color
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
    if ($Label) {
        "`n == $Label == `n"
    }
    $Hash.GetEnumerator() | ForEach-Object {
        $Key = $_.Key ; $Value = $_.value
        $KeyAligned = $Key.ToString().padLeft( $PadLeft, ' ')
        if ($null -eq $Value) { $Value = '<TrueNull>' }
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
    .LINK
        ShowArgs
    .LINK
        ShowHash
    .LINK
        ShowArray
    .LINK
        Hr
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
    if ($Label) {
        "`n == $Label, Length = $($Array.Count) ==`n"
    }
    $Array = $Array | ForEach-Object {
        if ($null -eq $_) {
            '<TrueNull>'
        }
        else { $_ }
    }
    if ($Csv) {
        $Array -join ', '
        return
    }

    $index = 0
    foreach ($item in $Array) {
        $IdAligned = $Index.ToString().PadLeft( $PadLeft, ' ')
        "$IdAligned = $Item"
        $Index++
    }
}

function ShowArgs {
    <#
    .SYNOPSIS
        top level function for users to use. This is automatic, see showHast() and showArray() for control
    .LINK
        ShowArgs
    .LINK
        ShowHash
    .LINK
        ShowArray
    .LINK
        Hr
    #>
    # [Alias('ShowArgs.3')]
    param(
        # Their bound, not mine
        [hashtable]$BoundParametersObj,

        [object]$ArgsRemaining,
        # for Shorter output, print as a Csv, good for longer arrays
        [Alias('AsCsv')][switch]$Csv,

        # Set a maximum row limit (for printing). 0 Means no limits
        [int]$AutoCsv = 0,

        # show scriptblock ?
        [ALias('SB')][switch]$IncludeCode
    )
    if ($AutoCsv -gt 0 -and $ArgsRemaining.count -gt $AutoCsv) {
        $Csv = $true
    }
    hr -fg orange

    '{2}> {0}{1}' -f @(
        $call = Get-PSCallStack; $cfirst = $call | Select-Object -First  1 ; $clast = $call | Select-Object -Last 1
        $call[1].InvocationInfo.Line ?? '?' | Bat -l ps1
        "`n"
        hr
        # "`n`n"  ?? ''
    )



    $newBound = [hashtable]::new( $BoundParametersObj ) # potentially not required
    showHash $BoundParametersObj -Label '$PSBoundParameters'
    showArray $ArgsRemaining -Label 'UnboundArgs' -Csv:$Csv
    # grab ends
    # hr
    # $cfirst.InvocationInfo | iot2 -NotSkipMost
    # hr
    # $clast.InvocationInfo.MyCommand | iot2 -NotSkipMost
}
function ShowCommandSyntax {
    param( [string]$CommandName )
    $syn = Get-Command -syntax $CommandName
    $syn ??= ''
    $render = $syn | Bat -l ps1

    hr -fg 'yellow'
    hr -fg 'yellow'
    "`n== Syntax == "
    $render
    # hr -fg '#c186b7'

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

    showArgs $PSBoundParameters $Args
}
function OneParam {
    <#
    .SYNOPSIS
        simplified version of PString()
    #>
    param(
        # [Parameter()]
        [String]$Text1
    )
    showArgs $PSBoundParameters $Args
}
function OneParamAsAdvanced {
    <#
    .SYNOPSIS
        simplified version of PString()
    #>
    param(
        [Parameter()]
        [String]$Text1
    )
    showArgs $PSBoundParameters $Args
}
function OneParamFromRemaining {
    <#
    .SYNOPSIS
        simplified version of PString()
    #>
    param(
        [Parameter(ValueFromRemainingArguments)]
        [String]$Text1
    )
    showArgs $PSBoundParameters $Args
}


if ($true -or $ExtraDemos) {
    showArray (0..3) stuff
    showArray (0..3 + 'a'..'c') -Csv stuff
    showArray ('a', $null, 'e') 'Include a null'

    PString 'a', 'b' 'c' 'd' 0, 4, 5
    hr
    PString 'a', 'b' 'c' 'd'
    hr


    PString -Text1 ('str1', 'str2') 'str3' 'str4'

    $Text1 = 'str1', 'str2'
    $Unbound = 'str3', 'str4'
    hr
    PString -Text1 $Text1 $unbound
    PString -Text1 $Text1 @Unbound
}




return
ShowCommandSyntax 'OneParam'

OneParam 'a' 'b'
OneParam 'a', 'b' 'c'
OneParam 'a', 'b' 'c' 'd'
OneParam 'a' 'b' 'c' 'd'


OneParam bob cat dog
OneParam 'bob cat dog'
OneParam 'bob' 'cat' 'dog'
OneParam 'bob', 'cat', 'dog'
OneParam bob, cat, dog       #not even a string literal
OneParamFromRemaining bob cat dog
OneParamFromRemaining 'bob cat dog'
OneParamFromRemaining 'bob' 'cat' 'dog'

# OneParamFromRemaining 'bob', 'cat', 'dog'
#     >   Error: Cannot process argument transformation on parameter 'Text1'.
#         Cannot convert value to type System.String

# OneParamFromRemaining bob, cat, dog       #not even a string literal

#     >   Error: Cannot process argument transformation on parameter 'Text1'.
#         Cannot convert value to type System.String





function InspectTheInspected {
    param( $stuff )
    # grab ends
    $call = Get-PSCallStack; $cfirst = $call | Select-Object -First  1 ; $clast = $call | Select-Object -Last 1
    hr
    $cfirst.InvocationInfo | iot2 -NotSkipMost
    hr
    $clast.InvocationInfo | iot2 -NotSkipMost
}
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


Write-Warning 'I can maybe abstract using callstack or myinvocation info istead of the user caring? or will some contexts break?
    ideal is user just runs ShowCmdInfo()'