$Sample = @{
    CatNinja = '🐱‍👤'
    Monkey = '🐒🔑business'
    Control = " a🐈`n  `u{0} 🐈"
}
$Uni = @{
    Null  = "`u{2400}"
    Space = "`u{2400}"
}

' '.EnumerateRunes()|ft

function j.Hex {
    <#
    .SYNOPSIS
        just format numbers as hex
    .NOTES
        fix: [hex] => <Ninmonkey.Console\public\ConvertTo-Number.>
    .EXAMPLE
        $what = 'a🐒c'
        $bytes = [Text.Encoding]::GetEncoding('utf-16le').GetBytes( $what )

    > $bytes | j.Hex
        61 00 3d d8 12 dc 63 00

    > $bytes | j.Hex -FormatString '{0:x4}' '_'
        0061_0000_003d_00d8_0012_00dc_0063_0000
    #>
    [CmdletBinding()]
    param(
        [Parameter()]
        [ARgumentCompletions(
            "''", "' '" )]
        [string]$Separator = ' ',

        [ArgumentCompletions(
            "'{0:x}'",
            "'{0:x2}'",
            "'{0:x4}'",
            "'{0:x8}'",
            "'{0:x16}'"
        )]
        [Alias('FStr')]
        [string]$FormatString = '{0:x2}',

        [Alias('Op')]
        [string]$OutputPrefix = '',

        [Alias('Os')]
        [string]$OutputSuffix = '',

        # expects integers, in general
        [Alias('InObj', 'Values', 'Num', 'Int')]
        [Parameter(Mandatory, ValueFromPipeline )]
        [object[]]$InputObject
    )
    begin {
        [List[Object]]$Items = @()
    }
    process {
        $Items.AddRange(@( $InputObject ))
    }
    end {
        $Items
            | Join-String -sep $Separator -f $FormatString
            | Join-String -op $OutputPrefix -os $OutputSuffix
    }
}


$what = 'a🐒c'
$list = $what.ToCharArray()
[Text.Encoding]::Unicode.GetBytes( $what ) | Join-string -sep ' ' -f ' {0:x}'

$what = 'a🐒c'
[Text.Encoding]::Unicode.GetBytes( $what ) | Join-string -sep ' ' -f '{0:x2}'
'61 00 3d d8 12 dc 63 00'

$list[1].ToInt64($Null) | % tostring 'x'
'd83d'

$list[0].ToInt64($Null) | % tostring 'x'
'61'

$what -match '\ud83d'
'True'

$what.EnumerateRunes()
[regex]::match( $what, '\ud83d.')       | ft # '[2] = 🐒'
[regex]::match( $what, '\ud83d\udc12')  | ft # '[2] = 🐒'


function CodepointAs16RegexLiteral {
    <#
    .EXAMPLE
        in: 🐒

        > '🐒' -match ( CodepointAs16RegexLiteral '🐒')

        # out: true
    #>
    [OutputType('String')]
    param(
        [ArgumentCompletions('🐒')]
        [string]$Text = '🐒')
    if( @($Text.EnumerateRunes().Value).count -gt 1 ) { throw "expected one codepoint for now"}
    return ([Text.Encoding]::GetEncoding('utf-16le').GetBytes( $Text )
        | Join-string -f '{0:x2}' ) -replace
            '(?<=\G.{4})(?!$)', ':' -split ':' | Join-String -f '\u{0}' { $_ -replace '(..)(..)', '$2$1' }
}

# CodepointAs16Literal

# Update-Typedata -TypeName 'System.Text.Rune' -DefaultDisplayPropertySet @(
#     'Value', 'Utf16SequenceLength', 'Utf8SequenceLength', 'Plane', 'IsAscii', 'IsBmp'

# ) -Force -ea 'silentlycontinue'

# 🐱‍👤
 Write-FormatView -TypeName ([Text.Rune]) -Property @(
        'Render'
        'Hex'
        'Dec'
        #    'Name', 'PropertyType', 'Attributes', 'PropertyAttributes', 'InitialValue', 'ShortPath', 'ShortExtent'
        'Utf16',
        'Utf8'

        # to remove a bunch, or move to type data
        'Numeric' # 'GetNumericValue'
        'Cat' # 'GetUnicodeCategory'
        # 'Cat' #  'Category'
        'Ctrl'  # 'IsControl'
        # 'IsDigit'
        # 'IsLetter'
            # 'IsLetterOrDigit'
            # 'IsLower'
            # 'IsNumber'
            # 'IsPunctuation'
        # 'IsSeparator'
        # 'Symbol'
        #     # 'IsUpper'
        # 'IsWhiteSpace'
        'Enc8'
        'Enc16'
        'Enc16Be'
        'Upper'
        'Lower'
   )  -AliasProperty @{
        'Cat' = 'GetUnicodeCategory'
        'Dec'    = 'Value'
        'Utf16'  = 'Utf16SequenceLength'
        'Utf8'   = 'Utf8SequenceLength'
        'Text'   = 'Render'
        'Lower'  = 'ToLowerInvariant'
        'Upper'  = 'ToUpperInvariant'
        # 'Ctrl'   = 'IsControl'
        'Symbol' = 'IsSymbol'
    } -AlignProperty @{
        'Rune' = 'right'
        'Hex'  = 'right'
    } -VirtualProperty @{
        Enc8 = {
            [Text.Encoding]::GetEncoding('utf-8').GetBytes( $_ )
                | Join-string -f '{0:x2}' -sep ' ' }
        Enc16 = {
             [Text.Encoding]::GetEncoding('utf-16le').GetBytes( $_ )
                | Join-string -f '{0:x2}' -sep ' ' }
        Enc16Be = {
             [Text.Encoding]::GetEncoding('utf-16be').GetBytes( $_ )
                | Join-string -f '{0:x2}' -sep ' ' }
        Cat = { # Category
            [Text.Rune]::GetUnicodeCategory( $_.Value )
        }
        Hex = {
            Join-String -f '{0:x}' -sep ' ' -In $_.Value
        }
        Render             = { $_ | Format-ControlChar }
        Numeric            = { [Text.Rune]::GetNumericValue( $_ ) } # was: 'GetNumericValue'
        GetUnicodeCategory = { [Text.Rune]::GetUnicodeCategory( $_ ) }
        Ctrl               = { [Text.Rune]::IsControl( $_ ) } <# was: 'IsControl' #>
        IsDigit            = { [Text.Rune]::IsDigit( $_ ) }
        IsLetter           = { [Text.Rune]::IsLetter( $_ ) }
        IsLetterOrDigit    = { [Text.Rune]::IsLetterOrDigit( $_ ) }
        IsLower            = { [Text.Rune]::IsLower( $_ ) }
        IsNumber           = { [Text.Rune]::IsNumber( $_ ) }
        IsPunctuation      = { [Text.Rune]::IsPunctuation( $_ ) }
        IsSeparator        = { [Text.Rune]::IsSeparator( $_ ) }
        IsSymbol           = { [Text.Rune]::IsSymbol( $_ ) }
        IsUpper            = { [Text.Rune]::IsUpper( $_ ) }
        IsWhiteSpace       = { [Text.Rune]::IsWhiteSpace( $_ ) }
        'Lower'            = # ToLowerInvariant =
                { [Text.Rune]::ToLowerInvariant( $_ ) }
        'Upper' = # ToUpperInvariant
                { [Text.Rune]::ToUpperInvariant( $_ ) }
        # ToLower            = { [Text.Rune]::ToLower( $_ ) }
        # ToUpper            = { [Text.Rune]::ToUpper( $_ ) }

    # SExtent = { $_.Extent.Text | Dotils.Format-ShortenWhitespace }
    # SParent = { $_.Parent.Name }
    # SPath = {
    #     $Line = $_.Extent.StartLineNumber
    #     $_.Extent.File | Get-Item
    #         | Join-String -p Name -f "{0}:${Line}" }
    }  -AutoSize
    | Out-FormatData | Push-FormatData

hr

# [Text.Rune] | fime -ParameterType { [Text.Rune] }

$one = $sample.Monkey.EnumerateRunes() | s -First 1

# $sample.Monkey.EnumerateRunes() | ft
# $sample.Control.EnumerateRunes()
