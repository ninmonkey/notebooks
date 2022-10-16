using namespace System.Collections.Generic
using namespace System.Globalization
using namespace System.Text
# [Globalization.StringInfo]
$b ??= @{}

$b.v_end_crlf = @'
a
b
'@
# $Symbol = @{
#     NL = "`n"
# }
$str = @{
    Family = '👪'
    ManFactory1 = '👨🏼‍🏭'

}

# example:
if($false) {
    [Text.Rune] | Find-Member -MemberType Method -ParameterType { [anyof[ Rune, String, Char ]] }
    [Text.Rune] | Find-Member -MemberType Method -ParameterType { [anyof[ rune ]] } #| % Name | cl
}

function _inspectRune {
    param(
        [Parameter(Mandatory, ValueFromPipeline, ParameterSetName='fromPipe', ValueFromPipelineByPropertyName)]
        [Parameter(Mandatory, ParameterSetName='fromParam')]
        [Text.Rune]$Rune
    )
    begin {
        # [Text.Rune]$Target = $Null
    }
    process {
        switch ($PSCmdlet.ParameterSetName) {
            'fromPipe' { $Target = $Rune }
        }
    }

    end {
        switch ($PSCmdlet.ParameterSetName) {
            'fromParam' { $Target = $Rune }
        }
        $cultInfo = [Globalization.CultureInfo]::new('en-us')

        [pscustomobject]@{
            Instance = $Target
            Category = [Text.Rune]::GetUnicodeCategory( $Target )
            GetNumericValue = [Text.Rune]::GetNumericValue( $Target )
            GetUnicodeCategory = [Text.Rune]::GetUnicodeCategory( $Target )
            IsControl = [Text.Rune]::IsControl( $Target )
            IsDigit = [Text.Rune]::IsDigit( $Target )
            IsLetter = [Text.Rune]::IsLetter( $Target )
            IsLetterOrDigit = [Text.Rune]::IsLetterOrDigit( $Target )
            IsLower = [Text.Rune]::IsLower( $Target )
            IsNumber = [Text.Rune]::IsNumber( $Target )
            IsPunctuation = [Text.Rune]::IsPunctuation( $Target )
            IsSeparator = [Text.Rune]::IsSeparator( $Target )
            IsSymbol = [Text.Rune]::IsSymbol( $Target )
            IsUpper = [Text.Rune]::IsUpper( $Target )
            IsWhiteSpace = [Text.Rune]::IsWhiteSpace( $Target )
            ToLower = [Text.Rune]::ToLower( $Target, $cultInfo )
            ToLowerInvariant = [Text.Rune]::ToLowerInvariant( $Target )
            ToUpper = [Text.Rune]::ToUpper( $Target, $cultInfo )
            ToUpperInvariant = [Text.Rune]::ToUpperInvariant( $Target )

        }
    }
}

function _iterRune {
    <#
    .SYNOPSIS
        sugar to iterate codepoints / runes

    .EXAMPLE
        "`u{27}`u{1f468}`u{1f3fc}`u{200d}`u{1f3ed}`u{27}" | _iterRune | ft
        "`u{27}`u{1f468}`u{1f3fc}`u{200d}`u{1f3ed}`u{27}" | _iterGrapheme
    #>
    [CmdletBinding()]
    param(

        [Parameter(Mandatory, ValueFromPipeline, ParameterSetName='fromPipe')]
        [Parameter(Mandatory, ParameterSetName='fromParam')]
        [string]$InputText
    )
    process {
        switch ($PSCmdlet.ParameterSetName) {
            'fromPipe' { $InputText.EnumerateRunes() }
        }
    }
    end {
        # explict switch unecessary but makes intent more clear, especially since same var is both
        switch ($PSCmdlet.ParameterSetName) {
            'fromParam' { $InputText.EnumerateRunes() }
        }
    }
}
function _iterGrapheme {
    <#
    .SYNOPSIS
        sugar to iterate graphemes or textelements
    .EXAMPLE
        "`u{27}`u{1f468}`u{1f3fc}`u{200d}`u{1f3ed}`u{27}" | _iterRune | ft
        "`u{27}`u{1f468}`u{1f3fc}`u{200d}`u{1f3ed}`u{27}" | _iterGrapheme
    #>
    [CmdletBinding()]
    param(

        [Parameter(Mandatory, ValueFromPipeline, ParameterSetName='fromPipe')]
        [Parameter(Mandatory, ParameterSetName='fromParam')]
        [string]$InputText
    )
    process {
        switch ($PSCmdlet.ParameterSetName) {
            'fromPipe' {  [Globalization.StringInfo]::GetTextElementEnumerator( $InputText ) }
        }
    }
    end {
        # explict switch unecessary but makes intent more clear, especially since same var is both
        switch ($PSCmdlet.ParameterSetName) {
            'fromParam' {  [Globalization.StringInfo]::GetTextElementEnumerator( $InputText ) }
        }
    }
}


function _formatSymbol {
    param( [string]$InputText  )
    if($null -eq $InputText ) { throw "Expected string, found null" }
        # if($_ -isnot 'string') { throw "Expected string, found $($_.GetType().Name)"}
        # $_.EnumerateRunes().Value | %{

    $InputText.EnumerateRunes() | %{

        'write-debug $_'
    }
}

_formatSymbol "`n`r"
function _summarizeText {
    <#
    .SYNOPSIS
        text lines debugging end of lines etc
    .NOTES
        see more:
        - 5+ distinct definitions for keyword [Glyph] and [Grapheme] <https://www.unicode.org/glossary/#grapheme_cluster>
        - [graphemes](https://learn.microsoft.com/en-us/dotnet/standard/base-types/character-encoding-introduction#grapheme-clusters)
        - [TextElement from StringInfo.GetTextElementEnumerator](https://learn.microsoft.com/en-us/dotnet/api/system.globalization.stringinfo.gettextelementenumerator?view=net-6.0)
        - [WellFormed Surrogate pairs](https://learn.microsoft.com/en-us/dotnet/standard/base-types/character-encoding-introduction#well-formed-encoding)

        [Globalization.UnicodeCategory]
        [Globalization.StringInfo.GetTextElementEnumerator]


    #>
    [CmdletBinding()]
    param( [string[]]$InputText, [switch]$FromClip )
    $Summary = $null
    if(-not $InputText -and -not $FromClip) {
        throw "empty input"
    }
    $target = $FromClip ? (Get-Clipboard) : $InputText

    function _lineStats {
        param( [string]$Text )

        [pscustomobject]@{
            Raw = $Text
            Len_Char = $Text.Length
            Len_Codepoint = $Text.EnumerateRunes().Value.count
            Len_Grapheme = @([Globalization.StringInfo]::GetTextElementEnumerator( $Text)).count
            Num_NL = ($Text -split '\n').count
            Num_CRNL = ($Text -split '\r\n').count
            Num_Line = ($Text -split '\r?\n').count
        }
    }

    $dbg = [ordered]@{
        IsText = $target -is 'string'
        Len = $target.Count
        ALen = @($target).Count
    }
    [pscustomobject]$dbg | Write-Information

    $i = 0
    $summary = foreach($CurText in $target) {
        _lineStats $CurText
        | %{
            $_ | Add-Member -NotePropertyName 'Id' -NotePropertyValue ($i++) -ea ignore -Force -PassThru
        }
    }
    return $summary
}

function _summarizeBag {
    $bagSummary = $b.GetEnumerator() | %{
        $k = $_.key; $v = $_.Value
        [pscustomobject]@{
            Label = $_.Key
            Num_Element = $v.count

            Num_NL = ($v -split '\n').count
            Num_NL_Normalized = ($v -join "`n" -split '\n').count
            Num_CRLF = ($v -split '\r\n').count
            Num_CRLF_Normalized = ($v -join "`n" -split '\r\n').count

            RawValue = $v
            JoinStr = $v -join '_'
        }
    }
}
# . _summarizeBag
# $bagSummary | fl
# $bagSummary | ft -Wrap

# . _summarizeText -FromClip | Ft -AutoSize

"ab" | _iterRune | %{ $_ | _inspectRune  }  |ft
"ab" | _iterRune | _inspectRune | ft

write-warning 'warning, piping to _inspectRune appears to miss the first rune'

h1 'herestring'
$here1 = _summarizeText $here.from_CrLf
$here2 = _summarizeText $here.from_Lf

_summarizeText $here.from_CrLf | ft -auto -wrap
_summarizeText $here.from_Lf | ft -auto -wrap