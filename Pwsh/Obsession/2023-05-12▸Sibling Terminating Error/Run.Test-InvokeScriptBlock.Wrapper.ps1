<# future: todo:
    find vars in script block
    ensure values null
    then output at the end
#>

function nb.orig.Run.Test {
    <#
    .example

        Run.Test -Expression { $x = 100; $y++; } -VariableNames 'x', 'y'
    #>
    param(
        [Parameter(Mandatory, Position = 0)]
        [string[]]$VariableNames,

        [Parameter(Mandatory, Position = 1)]
        [ScriptBlock]$Expression,

        [Parameter(Position = 2)]
        [ValidateSet('', 'Md.Table', 'Text.Table')]
        [string]$OutputMode = 'Text.Table'

    )

    $global:__runTestId++
    $global:__runTestId | Join-String -f 'Run.Test => InvokeId: {0}' #@-op $PSStyle.Foreground.FromRgb(233, 23, 434)


    # $result = & {
    # should be redundant
    Remove-Variable $VariableNames -ea 'ignore'


    $result = & $Expression
    $vars = Get-Variable -Name $VariableNames -ea ignore
    $result | Out-Host
    # return $state

    # }
    Write-Warning 'left off'
    switch ($OutputMode ) {
        ## move me to out-format or out-mode
        # 'Md.Table' {
        #     $x = '.'

        # }
        { $_ -in @('', 'Text.Table') } {
            $result | Format-Table -auto
            | Out-String | Write-Information -infa 'continue'
        }
        default {
            throw "UhandledOutputMode: $OutputMode"
        }
    }
}


function Fmt.Md.Table {
    [Alias('nb.Out-Markdown.Table')]
    param(
        [object]$InputObject
    )
    throw 'check, already in my other lib'
}

function nb.Test.InvokeTestSummary {
    <#
    .SYNOPSIS
    Takes a script block, invokes it, and summarizes the results

    .DESCRIPTION
    Long description

    .PARAMETER VarName
    Parameter description

    .PARAMETER ScriptBlock
    Parameter description

    .EXAMPLE
    An example

    .NOTES
    docs: bat
        --pager <command>
        --
        --style <components>
            Configure which elements (line numbers, file headers, grid borders, Git modifications,
            ..) to display in addition to the file contents. The argument is a comma-separated list
            of components to display (e.g. 'numbers,changes,grid') or a pre-defined style ('full').
            To set a default style, add the '--style=".."' option to the configuration file or
            export the BAT_STYLE environment variable (e.g.: export BAT_STYLE="..").

            Possible values:

            * default: enables recommended style components (default).
            * full: enables all available components.
            * auto: same as 'default', unless the output is piped.
            * plain: disables all available components.
            * changes: show Git modification markers.
            * header: alias for 'header-filename'.
            * header-filename: show filenames before the content.
            * header-filesize: show file sizes before the content.
            * grid: vertical/horizontal lines to separate side bar
                    and the header from the content.
            * rule: horizontal lines to delimit files.
            * numbers: show line numbers in the side bar.
            * snip: draw separation lines between distinct line ranges.
    #>
    [Alias(
        # 'nb.Test.InvokeTestSummary',
        'TestIt',
        'nb.Invoke-TestResult')]
    param( [string[]]$VarName, [Alias('Expression')][scriptBlock]$ScriptBlock )
    $binBat = Get-Command -CommandType Application -ea 'stop' -path 'bat' | Select-Object -First 1
    [Collections.Generic.List[Object]]$binArgs = @(
        '-l', 'ps1', '--file-name', 'nb.Test.InvokeTestSummary'
    )

    if ( -not $VarName ) { $VarName = 'a'..'z' }
    Remove-Variable -Scope local -Name ('a'..'z') -ea ignore
    . $ScriptBlock
    Hr
    $ScriptBlock
    | & $binBat @batArgs
    | Out-Host # host? info?
    # | bat -l ps1 --file-name 'Test'
    Get-Variable -Scope local -Name ('a'..'z') -ea ignore | Format-Table -AutoSize
}

function nb.Format-TestResult {
    [Alias('nb.Test.RenderResult')]
    [CmdletBinding()]
    param(
        [Alias('ScriptBlock')][Parameter(Mandatory, ValueFromPipelineByPropertyName, ValueFromPipeline)]
        $Expression
    )
    begin {
        $totalIterations = 0
        Hr -fg magenta -ExtraLines 2
        H1 '==> enter: FormatTestPipeLine '
    }
    process {
        $totalIterations++
        TestIt -ScriptBlock $Expression
    }
    end {
        Hr -fg magenta -ExtraLines 2
        H1 (
            '==> end: FormatTestPipeLine {0}' -f @( $totalIterations )
        )

    }
}

H1 'test grouping 1' -fg orange


nb.Test.InvokeTestSummary
return
& {
    Run.Test -Expression {
        'hi world'
        $x = 100; $y++

    } -VariableNames 'x', 'y'

    Run.Test 'a' -Expression {
        'hi 2'
        $x = 3
        $y = $x * 3
    }
}


H1 'test grouping final' -fg orange

@(
    { $a = $i++ }
    { $a = ++$i }
    {
        0..10 | Where-Object {
            $_ -gt 4
        }
        | Join-String -sep ' '
    }
)
| nb.Invoke-TestResult
| nb.Format-TestResult