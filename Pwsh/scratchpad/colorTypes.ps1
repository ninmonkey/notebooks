Set-Alias 'js' 'join-string' -desc 'notebook sugar'
# class _fgColor {

#     # 515c6b

# }
# $isFirstRun = ($runCount++)
$C = @{
    dimBlue      = '515c6b'
    consoleGreen = '4cd189'
    Yellow       = '4cd189'
    # TestUsingAlpha = '515c6b99'
    # Bad9Digits     = '515c6bfff'
}

function _processColors {
    param($c)

    #throttled because error stream is slow  for re-runs

    $C.Keys.clone() | ForEach-Object {
        $Key = $_; $Value = $C.Item($Key)
        $ResolvedColor = try {
            [PoshCode.Pansies.RgbColor]$Value
        } catch {
            Write-Error -ea 'continue' "Failed [PoshRgbColor]: '$Key' = '$Value'"
        }
        if (-not $ResolvedColor) {
            $ResolvedColor = try {
                $PSStyle.Foreground.FromRgb( $Value )
            } catch {
                Write-Error -ea 'continue' "Failed PSStyle.fromRgb: '$Key' = '$Value'"
            }
        }
        if (-not $resolvedColor) {
            $C.Remove( $Key )
        }

        # $resolvedColor ??= $Value # should never reach, or return null?
        $C[ $Key ] = $ResolvedColor
    }
}
Hr
$isFirstPass = $null
if (-not $isFirstPass) {
    $isFirstPass = $true
    _processColors $C
}