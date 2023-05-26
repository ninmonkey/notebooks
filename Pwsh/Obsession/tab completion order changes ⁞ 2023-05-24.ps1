
function CompareCompletions {
    <#
    .synopsis
        capture completion texts, easier
    .description
        two ways to invoke for simplicity. if you pass a 2nd string it will take that as the position.
    .EXAMPLE
        two ways to invoke for simplicity. if you pass a 2nd string it will take that as the position.

        > CompareCompletions -Prompt '[int3' -verb -ColumnOrSubstring '[in'
        > CompareCompletions -Prompt '[int3' -verb -ColumnOrSubstring 3

    #>
    [CmdletBinding()]
    param(
        # text to be completed
        [string]$Prompt,

        # offset or the substring, it will take that as the position.
        [object]$ColumnOrSubstring


        # [int]$Limit = 5
        # [switch]$Fancy,

        # [switch]$PassThru = $true
    )
    # if($ColumnOrSubstring -is 'int') {}

    # if ($false) {
    #     $Column = $ColumnOrSubString -as 'int'
    #     $Column ??= $ColumnOrSubstring.Length
    #     $Column ??= $Prompt.Length
    # # $Column++ # because it's 1-based
    #     if ($Column -le 0 -or $column -gt $Prompt.Length ) {
    #         Write-Error "out of bounds: $Column from $ColumnOrSubString, actual = $($Prompt.Length)"
    #         return
    #     }
    # }
    # $Column = [Math]::Clamp( ($Column ?? 0), 1, $Prompt.Length)
    if($ColumnOrSubstring -is 'int') { $Col = $ColumnOrSubstring -as 'int' }
    else { $Col = $ColumnOrSubstring.Length }

    # else { $Col = $ColumnOrSubstring.Length - 1 }
    $Col | Join-String -f 'Column: {0}' | Write-Verbose

    # $query = TabExpansion2_Original -inputScript $Prompt -cursorColumn $Column
    $query = TabExpansion2 -inputScript $Prompt -cursorColumn $Col
    $results = $query.CompletionMatches

    if ($true -or $PassThru) { return $results }

    # $results | Sort CompletionText | select -First $Limit -Last $Limit
    # $results | Sort ListItemText | select -First $Limit -Last $Limit
    # $results | Sort ResultType | select -First $Limit -Last $Limit
    # $results | sort Tooltip | select -First $Limit -Last $Limit
}

# CompareCompletions -Prompt '[obj'
CompareCompletions -Prompt '[int' -ColumnOrSubstring 3
<# context: <https://discord.com/channels/180528040881815552/446156137952182282/1111044914042650838>


seeminglyscience — Today at 4:35 PM
working correctly would be completing to the short name
[4:35 PM]
like [pscustom<tab>
[4:36 PM]
should be [pscustomobject] rather than [System.Management.Automation.PSCustomObject]

santisq — Today at 4:55 PM
Path.Exists is an ETS?
[4:55 PM]
just realized

@santisq
Path.Exists is an ETS?

seeminglyscience — Today at 6:36 PM
what?
[6:36 PM]
no ETS can't be static

santisq — Today at 6:38 PM
nevermind
[6:38 PM]
was added in .net core
[6:38 PM]
i realized that later

seeminglyscience — Today at 6:38 PM
ahh

santisq — Today at 6:39 PM
i was tyring to use it in my code and didnt understand why it wasnt autocompleting
[6:39 PM]
until i remembered i was using netstandard2 (edited)

@seeminglyscience
should be [pscustomobject] rather than [System.Management.Automation.PSCustomObject]

ninmonkey — Today at 7:11 PM
pscustomobject is short for me too
but [int<tab> becomes [System.Int128 rather than Int32
yet [Int3<tab> becomes [Int32
then [Int32<tab> becomes [System.Xml.Xsl.Runtime.Int32Aggregator

seeminglyscience — Today at 7:12 PM
yeah something feels a little off about type name completions lately. Something to look into for sure
[7:13 PM]
like [obj<tab> becomes [System.Runtime.InteropServices.JavaScript.JSType+Object] which is just bizarre. Something about how prioritization is done changed

ninmonkey — Today at 7:13 PM
I'm running PSReadLine 2.3.0 beta0 /w Pwsh 7.3.4
[7:15 PM]
for that one, it says Object is selected but completes to [System.Runtime.InteropServices.JavaScript.JSType+Object

[7:16 PM]
grepping the patch notes of Pwsh and PSRL might give some hints. they keep adding more completions
NEW

seeminglyscience — Today at 7:16 PM
that one is probably just the deduping that PSRL does
[7:16 PM]
but it should not do it by tooltip probably

#>