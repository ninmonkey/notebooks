$error.clear()
# & {
#     # generate fresh sample error }
#     [CmdletBinding()]
#     param()
'ssdf'.EnumerateRunes().value | Join-string -f '{x}' -sep ' '
[ErrorRecord]$serr = $error[0]
# } -ea 'silentlycontinue' -ev 'serr'

function Hrr {
   param( [int]$PadLines = 1 )
   $pad = "`n" * $PadLines -join ''
   ('-' * [console]::WindowWidth) -join '' |Join-String -op $Pad -os $Pad }

function HShowEscape {
    # Replaces escape characters with their saffe-to-print runes
    [CmdletBinding()]
    param( [Parameter(ValueFromPipeline)][string]$InputText )
    process {
        if( $Null -eq $InputText ) { return }
        $InputText.EnumerateRunes() | %{
            ( $_.Value -ge 0 -and $_.value -le 0x1f) ?
                [Text.Rune]::New( $_.Value + 0x2400 ) :
                $_
        } | Join-String
    }
}
function ShowEmojiRepeats {
    # Replaces escape characters
    process {
        $_ -replace
            [Regex]::Escape('␛[32;1m'), '🐈' -replace
            [Regex]::Escape('␛[0m'),    '🦎'
    }
}

[string[]]$outStr_lines = (($serr | Get-Error | out-string) -split '\r?\n').where({$_}, 'first', 6)
$outStr_lines | Set-Clipboard
[string[]]$roundTClippy_lines = Get-Clipboard


(($serr | Get-Error | out-string) -split '\r?\n').where({$_}, 'first', 6) | Join-String -sep (Hrr) -p { $_ | fcc }
| ShowEmojiRepeats


$outStr_lines| HShowEscape
<#
prints
$outStr_lines| HShowEscape
␛[32;1mException             : ␛[0m
␛[32;1m␛[0m    ␛[32;1mType       : ␛[0mSystem.FormatException␛[0m
␛[32;1m␛[0m␛[32;1m␛[0m    ␛[32;1mTargetSite : ␛[0m
␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m        ␛[32;1mName          : ␛[0mThrowFormatInvalidString␛[0m
␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m        ␛[32;1mDeclaringType : ␛[0mSystem.ThrowHelper, System.Private.CoreLib
␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m        ␛[32;1mMemberType    : ␛[0mMethod␛[0m
#>

(($serr | Get-Error | out-string) -split '\r?\n').where({$_}, 'first', 6) | Join-String -sep (Hrr) -p { $_ | HShowEscape } | ShowEmojiRepeats


return

 'ssdf'.EnumerateRunes().value | Join-string -f '{x}' -sep ' '
(($serr | Get-Error | out-string) -split '\r?\n').where({$_}, 'first', 6) | Join-String -sep (Hrr) -p { $_ | fcc }


return

(($serr | Get-Error | out-string) -split '\r?\n').where({$_}, 'first', 6) | Join-String -sep (Hrr) -p { $_ | fcc }
