<#
Returns parsed output as objects
    runs command: docker --help

With re-usable functions

searching for all sub commands
#>
# err -clear
$State = @{
    SkipBefore = $true
    ShouldBreak = $false
}
$Re = @{
  SkipBefore  = '^Commands'
  ShouldBreak = '^Global Options'
}
[hashtable]$script:State = @{
    SkipBefore = @{}
    SkipAfter  = @{}
}
function Text.IsEmpty {
    [OutputType('boolean')]
    param(
        [Parameter(Mandatory, Position=0)]
        $TextContent
    )
    [string]::IsNullOrEmpty( $TextContent)
}
function Text.Where-IsNotEmpty {
    <#
    .example
        Pwsh> Set-Alias -Name 'Pk!Empty' -value 'Picky\Picky.Text.Where-IsNotEmpty'
        Pwsh> 'a', $null, ' ' | Pk!Empty # | Json -Compress
        # outputs: ["a"," "]
    #>
    [Alias(
        '?IsNot-Blank'
    )]
    param()
    process {
        if( Text.IsEmpty $_ ) { return }
        $_
    }
}
function Text.SkipBeforeMatch {
    <#
    .SYNOPSIS
        ignores all text until you reach the first match, output remaining rows
        wait until a flag, ignoring output before ti
    .NOTES
        - future: Pass StringBuilder around?
        - future: Offset so you say say -2, or +3 index relative the match
    #>
    [Alias('Text.SkipBefore', 'Text.SkipUntil')]
    [CmdletBinding()]
    param(

        # filtering regex
        [Parameter(Mandatory, Position=0)]
        [Alias('Regex', 'Re', 'Pattern', 'Condition', 'Filter', 'Until')]
        [string]$BeforePattern,

        [Parameter(ValueFromPipeline)]
        [string[]]$TextContent,

        # default setting ignores the line that matched. this includes it.
        [switch]$IncludeMatch
    )
    begin {
        $ShouldSkip = $true
    }
    process {
        foreach($Line in $TextContent) {
            if($Line -match $BeforePattern) {
                $ShouldSkip = $false
                if($IncludeMatch){ $Line }
                continue
            }
            if( -not $SHouldSkip) { $Line }
        }
    }
    end {}
}
# function Text.TakeLineCount {
#     <#
#     .SYNOPSIS
#         ignores all text until you reach the first match, output remaining rows
#         wait until a flag, ignoring output before ti
#     .NOTES
#         - future: Pass StringBuilder around?
#         - future: Offset so you say say -2, or +3 index relative the match
#     #>
#     [Alias('Text.TakeLines', 'Text.TakeFirstN', 'Text.TakeFirst')]
#     [CmdletBinding()]
#     param(

#         # filtering regex
#         [Parameter(Mandatory, Position=0)]
#         [string]$TakeCount,

#         [Parameter(ValueFromPipeline)]
#         [string[]]$TextContent
#     )
#     begin {
#         write-warning 'broke?, see Text.SkipLinecount for inversion'
#         $ShouldTake = $true
#         $linesProcessed = 0
#     }
#     process {
#         foreach($Line in $TextContent) {
#             if($linesProcessed -gt $TakeCount) {
#                 $shouldTake = $true
#                 continue
#             }
#             $linesProcessed++
#             if(-not $ShouldTake) { $Line }
#         }
#     }
#     end {}
# }
function Text.TakeLineCount {
    <#
    .SYNOPSIS
        ignores all text until you reach the first match, output remaining rows
        wait until a flag, ignoring output before ti
    .NOTES
        - future: Pass StringBuilder around?
        - future: Offset so you say say -2, or +3 index relative the match
    #>
    [CmdletBinding()]
    [Alias(
        'Text.TakeN',
        'Text.TakeLines',
        'Text.TakeFirstN', 'Text.TakeFirst'
    )]
    [CmdletBinding()]
    param(

        # filtering regex
        [Alias('FirstN', 'N', 'Len')]
        [Parameter(Mandatory, Position=0)]
        [string]$TakeCount,

        [Parameter(ValueFromPipeline)]
        [string[]]$TextContent
    )
    begin {
        $ShouldTake = $false
        $linesProcessed = 0
    }
    process {
        foreach($Line in $TextContent) {
            $linesProcessed++
            if($linesProcessed -gt $TakeCount) {
                $shouldTake = $true
                continue
            }
            if(-not $ShouldTake) { $Line }
        }
    }
    end {
        if($TakeCount -gt $LinesProcessed) {
            'TakeCount is greater than the number of lines in the input: FirstN: {0}, Parsed: {1}' -f @(
                $TakeCount, $LinesProcessed
            )
            | write-verbose
        }
    }
}
function Text.SkipAfterMatch {
    <#
    .SYNOPSIS
        ignores all text until you reach the first match, output remaining rows
        wait until a flag, ignoring output After ti
    .NOTES
        - future: Pass StringBuilder around?
        - future: Offset so you say say -2, or +3 index relative the match
    #>
    [Alias('Text.SkipAfter', 'Text.SkipUntil')]
    [CmdletBinding()]
    param(

        # filtering regex
        [Parameter(Mandatory, Position=0)]
        [Alias('Regex', 'Re', 'Pattern', 'Condition', 'Filter', 'Until')]
        [string]$AfterPattern,

        [Parameter(ValueFromPipeline)]
        [string[]]$TextContent,
        # default setting ignores the line that matched. this includes it.
        [switch]$IncludeMatch
    )
    begin {
        $ShouldSkip = $false
    }
    process {
        foreach($Line in $TextContent) {
            if(Text.IsEmpty $Line) { continue }
            if($Line -match $AfterPattern) {
                $ShouldSkip = $true
                if($IncludeMatch) { $Line }
                continue
            }
            if( -not $ShouldSkip) { $Line }
        }
    }
    end {}
}

[string[]]$lines ??= docker --help
$selected = $Lines | %{
    $cur = $_
    if($cur -match $Re.SkipBefore) {
        $state.SkipBefore = $false
        return
    }
    if($State.SkipBefore) { return }

    if($cur -match $Re.ShouldBreak) {
        $state.ShouldBreak = $true
    }
    if($State.ShouldBreak) { return }
    $cur
}
$selected #| CountOf

$render = $selected.ForEach({
    $cur = $_
    if( Text.IsEmpty $Cur ) { return }
    $parseRe = @'
(?x)
    # sample: https://regex101.com/r/A7tyKn/1
    # ex: " top         Display the running processes of a container"
    # ex: "  rename      Rename a container"
    ^
    \s+
    (?<SubCommand>.*?)
    \s+
    (?<Description>.*)
    $
'@
    if( $cur -match $parseRe ) {
        $matches.remove(0)
        [pscustomobject]$Matches
    } else {
        'ShouldNeverReachParsingLine: {0}' -f $cur
            | write-error
    }
})
$render #| CountOf

hr

$lines | Pk.SkipBeforeMatch '^Commands:' -IncludeMatch | CountOf
<#
outputs:

SubCommand Description
---------- -----------
attach     Attach local standard input, output, and error streams to a running container
commit     Create a new image from a container's changes
cp         Copy files/folders between a container and the local filesystem
create     Create a new container
diff       Inspect changes to files or directories on a container's filesystem
events     Get real time events from the server
export     Export a container's filesystem as a tar archi
           ....
#>
