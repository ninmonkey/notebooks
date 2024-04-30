<#
This pattern returns a single value per input.
'break' stops evaluating the rest, once the first match is found
#>

function GuessKind {
    param( [string] $Text )
    switch -Regex ( $Text ) {
        'red|blue' {
            'color'
            break
        }
        '^\d+$' {
            'OnlyNumber'
            break
        }
        '^\s*$' {
            'OnlyWhitespace'
            break
        }
        default { 'other' }
    }
}

GuessKind 'red'        # color
GuessKind '99'         # OnlyNumber
GuessKind '99  foo '   # other
GuessKind ''           # OnlyWhitespace

function MetadataFromName {
    <#
        Build a hashtable of possible values
        the are only included in the hashtable if the condition was true
        the final output is one single hashtable. Regardless of the number of matches
    #>
    param( [string] $processedgame )

    $Info = @{}
    switch -Regex ( $processedgame ) {
         '🐒' { $info.IsMonkey = 'Monkey' }
         'business' { $info.IsBusiness = $true }
         'part\d+'  { $Info.Sequel = $_ }
    }
    $info
}

$meta = MetadataFromName -processedgame '🐒business, part2'
$meta | ft -AutoSize

<#
    Name       Value
    ----       -----
    IsBusiness True
    IsMonkey   Monkey
    Sequel     🐒business, part2
#>

if( $meta.IsBusiness -and $meta.Sequel -match '2' ) {
    'the second time is always best'
}
