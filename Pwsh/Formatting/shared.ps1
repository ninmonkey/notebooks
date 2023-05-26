function Console.GetColumnCount {
    [OutputType('System.Int32')]
    param()
    $w = $host.ui.RawUI.WindowSize.Width
    return $w
}
function Write.Info {
    # render as text, to the information stream
    # mainly sugar to enable it
    $Input
    | Out-String -w 1kb
    | Write-Information -infa 'Continue'
}
function Write.Info.Fence {
    $content = $Input
    $content -split '\r?\n'
    | Join-String -f '    {0}'
    | Join-String -op "`nfence`n" -os "`ncloseFence`n"
}
function String.Normalize.LineEndings {
    # replace all \r\n sequences with \n
    process {
        $_ -replace '\r?\n', "`n"
    }
}
function ClampIt {
    # polyfill. Pwsh Can use [Math]::Clamp directly.
    param ( $value, $min, $max )

    [Math]::Min(
        [Math]::Max( $value, $min ), $max )
}
function String.Visualize.Whitespace {
    param( [switch]$Quote)
    process {
        ( $InputObject = $_ )
        | Join-string -SingleQuote:$quote
        | new-text -bg 'gray30' -fg 'gray80' | % tostring
    }
}
function String.Transform.AlignRight {
    # replace all \r\n sequences with \n
    param(
        [switch]$ShowDebugOutput
    )
    process {

        $InputObject = $_
        $re = '^\s*(?<Content>.*?)\s*$'

        $InputObject -split '\r?\n'
            | %{
                [string]$curLine = $_

                if($ShowDebugOutput) {
                    label 'what' 'orig'
                    $curLine
                    | String.Visualize.Whitespace
                    | Write.Info
                }

                if($curLine -match $Re) { } else { return }
                $withoutPadding = $matches.Content ?? ''

                if($ShowDebugOutput) {
                    label 'what' 'without pad'
                    $withoutPadding
                    | String.Visualize.Whitespace
                    | Write.Info
                }

                $width  = (Console.GetColumnCount) ?? 120
                $render = $withoutPadding.ToString().PadLeft( $width, ' ')
                if($ShowDebugOutput) {
                    label 'what' 'new pad'

                    $render
                    | String.Visualize.Whitespace
                    | Write.Info
                }
                return $render
            }
    }
}

h1 'alignment test'

-3..10 | %{
    $sample = 'hi world'
    $i = [Math]::Clamp( $_, 0, $sample.Length )
    $sample.Substring( 0, $i )
}
| String.Visualize.Whitespace

$rawSource = @'
gcm Invoke-RestMethod
    | PSScriptTools\Get-ParameterInfo
    | Sort-Object Type, name
    | ft -AutoSize Name, Aliases, type -GroupBy { $true }
'@ | String.Normalize.LineEndings
$rawSource2 = @'
gcm Invoke-RestMethod |
    PSScriptTools\Get-ParameterInfo |
    Sort-Object Type, name |
    ft -AutoSize Name, Aliases, type -GroupBy { $true }
'@ | String.Normalize.LineEndings
$rawSource3 = @'
# syntax: PS5 trailing Pipe
# variant left-align sort of eaiser to read
                        gcm Invoke-RestMethod                               |
                        PSScriptTools\Get-ParameterInfo                     |
                        Sort-Object Type, name                              |
                        ft -AutoSize Name, Aliases, type -GroupBy { $true }
'@ | String.Normalize.LineEndings

$rawSource4 = @'
# right aligned. ps7 pipe continuations
# pipe pad left alignment, code align right
                                            gcm Invoke-RestMethod
                                | PSScriptTools\Get-ParameterInfo
                                |          Sort-Object Type, name
                                | ft -AutoSize Name, Aliases,
                                          type -GroupBy { $true }
'@ | String.Normalize.LineEndings

($rawSource -split '\r').count
    | Should -BeLessOrEqual 1 -because 'Endings were normalized'

$x = $rawSource
    | Write.Info
$null -eq $x
    | SHould -be $true -Because 'It did not pollute the output stream'

h1 'A: Original, kusto-esque'
$rawSource

h1 'first Invoke-Formatter /w  defaults'
Invoke-Formatter $rawSource

h1 'first, silly right alignment for WinPS5'
$rawSource -split '\r' | String.Transform.AlignRight

h1 'experimet.....'

$str = '    | PSScriptTools\Get-ParameterInfo   '
$str | String.Visualize.Whitespace

h1 'right, with debug output'
$str
| String.Transform.AlignRight -ShowDebugOutput
| String.Visualize.Whitespace

h1 'right, raw format'
$rawSource
| String.Transform.AlignRight
| String.Visualize.Whitespace

h1 'right, raw format, part 2'
$rawSource2
| String.Transform.AlignRight
| String.Visualize.Whitespace

hr


