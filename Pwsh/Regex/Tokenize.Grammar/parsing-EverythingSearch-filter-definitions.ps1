$Samples ??= @{}
$Samples.Basic = @'
( !path:wholeword:.git  ( !path:ww:"%AppData%\Code"  ) ( no_cache: )  )
'@

function __showSpace {
    param(
        [ValidateSet(
            'SpaceExpand.i0',
            'SpaceExpand.i1',
            'SpaceExpand.i2',
            'SpaceExpand',
            'Space'
        )]
        [string]$Template
    )
    process {
        $InObj = $Input
        switch ($Template) {
            'Space' {
                $InObj -replace '\r?\n', '🐕' -replace '\s', '‍🚀'
                break
            }
            'SpaceExpand.i0' {
                $i0 = $InObj -replace '\r?\n', '🐕' -replace '\s+', '‍🚀'
                $i0
                # $i1 = $i0 -replace '🐕', "`n    "
                # $i1
                break
                # $InObj -replace '\r?\n', '🐕' -replace '\s', '‍🚀'
            }
            'SpaceExpand.i1' {
                $i0 = $InObj -replace '\r?\n', '🐕' -replace '\s+', '‍🚀'
                $i1 = $i0 -replace '🐕', "`n    "
                $i1
                break
                # $InObj -replace '\r?\n', '🐕' -replace '\s', '‍🚀'
            }
            'SpaceExpand.i2' {
                $i0 = $InObj -replace '\r?\n', '🐕' -replace '\s+', '‍🚀'
                # $i1 = $i0 -replace '🐕', "`n    "
                $i1 = $i0 -replace
                    '\)', ")`n" -replace
                    '\(', "`n(" -replace
                    '🐕', "`n🐕`n"
                    
                $i2 = $i1
                $i2
                break
                # $InObj -replace '\r?\n', '🐕' -replace '\s', '‍🚀'
            }
            default {
                $InObj -replace '\r?\n', '🐕' -replace '\s', '‍🚀'
            }
        }
    }
}
function __es.parseMode.NaiveParens.iter0 {
    [CmdletBinding()]
    param(
        [Alias('Doc', 'Contents')]
        [string]$RawDoc
    )
    $curDepth = 0

    $re = @'
(?xi)
  ( [\(\)] )

'@
    $foo = [regex]::Replace( $rawDoc, $re, '<()>' )

    $re = @'
(?xi)
  ( [\(\)] )

'@
    $script:openCount = 0
    $script:closeCount = 0
    $script:curIndentDepth = 0

    [regex]::Replace( $rawDoc, $re, {
            param( $stuff )
            $stuff | Format-ShortTypeName | Write-Information
            $stuff | iot2 -NotSkipMost | Out-String | Write-Information
            $dentStr = @{ IndentString = '    ' }

            #need to parse on either (, ), or newline
            switch ($Stuff.Value) {
                '(' {

                    # render old depth, newline, new depth
                    $script:OpenCount++
                    $wasD = [Math]::Max(0, $script:curIndentDepth)
                    $script:curIndentDepth++
                    $curD = [Math]::Max(0, $script:curIndentDepth)

                    @(
                        # '(' # $stuff.Value

                        '(' | Join.Predent @dentStr -Depth $wasD
                        "`n"
                        # '' | Join.Predent @dentStr -Depth $curD

                    ) -join ''

                    break
                }
                ')' {
                    $script:curIndentDepth--
                    $script:CloseCount++
                    break
                }
                default {
                    $Stuff
                    | Join.Predent @dentStr -Depth $script:curIndentDepth

                    # Write-Error 'shouldNeverReach?'
                }
            }

            [ordered]@{
                curDepth   = $script:curIndentDepth
                ScriptOpen = $script:scriptOpen
                Open       = $script:OpenCount
                Close      = $script:CloseCount
            } | Json
            | Write-Information
            # | Write-Host


            $null = 0
        } )
    # $RawDoc

}
function __es.preParse.ParensToNewline {
    [CmdletBinding()]
    param(
        [Alias('Doc', 'Contents')]
        [string]$RawDoc
    )
    $RawDoc -replace '\(', "`n(`n" -replace '\)', "`n)`n"
}
function __es.parseMode.NaiveParens {
    [CmdletBinding()]
    param(
        [Alias('Doc', 'Contents')]
        [string]$RawDoc
    )
    $curDepth = 0
    $re = @'
(?xi)
    (?<ParensOrNL>
        [
            \(
            \)
        ]
        |
            (\r?\n)
    )

'@
    $script:openCount = 0

    $script:closeCount = 0
    $script:curIndentDepth = 0

    [regex]::Replace( $rawDoc, $re, {
            param( $stuff )
            $stuff | Format-ShortTypeName | Write-Information
            $stuff | iot2 -NotSkipMost | Out-String | Write-Information
            $dentStr = @{ IndentString = '    ' }

            #need to parse on either (, ), or newline
            switch ($Stuff.Value) {
                '(' {


                    $script:OpenCount++
                    $wasD = [Math]::Max(0, $script:curIndentDepth)
                    $script:curIndentDepth++
                    $curD = [Math]::Max(0, $script:curIndentDepth)

                    @(
                        # '(' # $stuff.Value

                        '(' | Join.Predent @dentStr -Depth $wasD
                        "`n"
                        # '' | Join.Predent @dentStr -Depth $curD

                    ) -join ''

                    break
                }
                ')' {
                    # ')'
                    # break
                    $script:CloseCount++
                    $wasD = [Math]::Max(0, $script:curIndentDepth)
                    $script:curIndentDepth--

                    $script:curIndentDepth = [Math]::Max(0, $script:curIndentDepth )

                    $curD = [Math]::Max(0, $script:curIndentDepth)

                    @(
                        # '(' # $stuff.Value

                        ')' | Join.Predent @dentStr -Depth $wasD
                        "`n"
                        '' | Join.Predent @dentStr -Depth $curD

                    ) -join ''


                    break
                }
                { $_ -match '\r?\n' } {
                    # $Stuff
                    # | Join.Predent @dentStr -Depth $script:curIndentDepth
                    break
                }
                { $_ -eq ' ' } {
                    ' '
                    break
                }
                default {

                    $Stuff
                    # | Join.Predent @dentStr -Depth $script:curIndentDepth

                    # Write-Error 'shouldNeverReach?'
                }
            }

            [ordered]@{
                curDepth = $script:curIndentDepth
                Open     = $script:OpenCount
                Close    = $script:CloseCount
            } | Json
            | Write-Information
            # | Write-Host


            $null = 0
        } )
    # $RawDoc
}

function .Render.EverythingSearch.Filter {
    [CmdletBinding()]
    param(
        [ValidateNotNullOrEmpty()]
        [Alias('Doc', 'Contents')]
        [string]$RawDoc
    )
    $Parsed = __es.parseMode.NaiveParens $RawDoc
    $Parsed
}

# super verbose
$winfo = @{
    InformationAction = 'Continue'
}

# $parsed = __es.parseMode.NaiveParens @winfo -RawDoc $Samples.Basic
$parsed = __es.parseMode.NaiveParens -RawDoc $Samples.Basic

Hr -fg magenta -ExtraLines 2
.Render.EverythingSearch.Filter -Doc $Samples.Basic
| __showSpace -Template SpaceExpand.i0

Hr -fg magenta
.Render.EverythingSearch.Filter -Doc $Samples.Basic
| __showSpace -Template SpaceExpand.i1

Hr -fg magenta
.Render.EverythingSearch.Filter -Doc $Samples.Basic
| __showSpace -Template SpaceExpand.i2

Hr -fg '4a65ff'
__es.preParse.ParensToNewline $Samples.Basic

Hr -fg '4a65ff'
$pre = __es.preParse.ParensToNewline $Samples.Basic
__es.preParse.ParensToNewline $pre

Hr -fg '4a65ff'
$Samples.Basic


Hr