$Samples ??= @{}
$Samples.Basic = @'
( !path:wholeword:.git  ( !path:ww:"%AppData%\Code"  ) ( no_cache: )  )
'@

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

function __es.parseMode.NaiveParens {
    [CmdletBinding()]
    param(
        [Alias('Doc', 'Contents')]
        [string]$RawDoc
    )
    $curDepth = 0
    $re = @'
(?xi)
  ( [
        \(
        \)
        \n
    ] )

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
Hr -fg '4a65ff'
$Samples.Basic
Hr