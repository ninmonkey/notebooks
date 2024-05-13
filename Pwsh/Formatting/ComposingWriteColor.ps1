#Requires -Version 7
<#
I was talking to HotCake about ansi colors for console output. They wrote <https://github.com/HotCakeX/WinSecureDNSMgr/tree/main/WinSecureDNSMgr/Module>
Color utils start here: https://github.com/HotCakeX/WinSecureDNSMgr/blob/1297a9bc5c34a63675255130922bb81ec124f022/WinSecureDNSMgr/Module/Shared/ColorFunctions.psm1

For fun I went on a tangent This started as an example of another style to to achieve a similar effect.
I threw in a few Pwsh7+ required features.

Pansies has a custom version of Write-Host that supports lots of values for -fg and -bg

    'hi world' | Write-Host -fg 'orange' -bg 'gray15'
    'hi world' | Write-Host -fg '#feaa99'

    New-Text has the same parameters, but it returns objects. They convert to ansi
    escapes automatically if you pipe to Write-Host.

    $stuff = 'hi world' | New-Text -fg 'orange'
    $stuff | Write-Host

    # You can use it with other streams:
    $stuff | Write-Verbose
    $Stuff | Write-Information -infa Continue

#>

# Since we're using PSStyle, so we might as well
filter Format-ShowEscapeChar {
    ($_)?.tostring() -replace "`e", "`u{241b}" # '␛' is 0x241b
}

filter Format-ShowControlChar {
    <#
    .SYNOPSIS
        Safely print a bunch of control char escape sequences
    .EXAMPLE
        > 0..0x30 -as [Text.Rune[]] | Format-ShowControlChar | Join-string -sep ' '

        ␀ ␁ ␂ ␃ ␄ ␅ ␆ ␇ ␈ ␉ ␊ ␋ ␌ ␍ ␎ ␏ ␐ ␑ ␒ ␓ ␔ ␕ ␖ ␗ ␘ ␙ ␚ ␛ ␜ ␝ ␞ ␟ ␠ ! " # $ % & ' ( ) * + , - . / 0
    .notes
        this is a superset of Format-ShowEscapeChar. It's a bit slower than char array array.
        This guarantees codepoints. It's fast enough if the strings aren't intensive.

        tip: Control characters in the range [0x00..0x20] can be safely rendered if you add
            0x2400 to their codepoints. That maps to the "symbol for x" characters

            that means newline, cr, tab, null strings ( ie: U+0000 ), etc....
    .LINK
        https://www.compart.com/en/unicode/block/U+0000
    .LINK
        https://www.compart.com/en/unicode/block/U+2400
    #>
    # control chars save to view, by adding 0x2400 to any codepoint
    if($null -eq $_) { return }
    # ($_)?.tostring() -replace "`e", "`u{241b}" # '␛' is 0x241b

    $_.ToString().EnumerateRunes() | %{
        if( $_.Value -le 0x20 ) {
            [Text.Rune]::new( $_.Value + 0x2400 )
        } else {
            $_
        }
    } | Join-String

}

function Write.Fg {
    <#
    .SYNOPSIS
        sugar to return Fg Colors as raw ansi escapes using the built in functions of Pwsh
    #>
     param(
        [ArgumentCompletions("'#c882f1'")]
        [Alias('Hex', 'Color')]
        [Parameter(ValueFromPipeline)][string] $Rgb
    )
    process {
        $PSStyle.Foreground.FromRgb( $Rgb )
    }
}
function Write.Bg {
    <#
    .SYNOPSIS
        sugar to return Bg Colors as raw ansi escapes using the built in functions of Pwsh
    #>
    param(
        [ArgumentCompletions("'#c882f1'")]
        [Alias('Hex')]
        [Parameter(ValueFromPipeline)][string] $Rgb
    )
    process {
        $PSStyle.Background.FromRgb( $Rgb )
    }
}
function Write.Color {
    param(
        [ArgumentCompletions("'#c882f1'")]
        [Parameter(Position = 0)]
        [Alias('Fg', 'HexFg')]$ColorFg,

        [ArgumentCompletions("'#3882f1'")]
        [Parameter(Position = 1)]
        [Alias('Bg', 'HexBg')]$ColorBg,

        [Parameter(ValueFromPipeline)]
        [string[]] $Content,

        [switch]$WithoutResetColor
    )
    process {
        $joinStringSplat = @{
            InputObject = $Content

            OutputPrefix = @(
                $ColorFg ? (Write.Fg -Rgb $ColorFg): ''
                $ColorBg ? (Write.Bg -Rgb $ColorBg): ''
            ) | Join-String -sep ''

            OutputSuffix =  $WithoutResetColor ? '' : $PSStyle.Reset
        }

        Join-String @joinStringSplat
    }
}

# 📌 example starts here
function WriteViolet.Pansies {
    # New-Text is from Pansies
    # Pansies is nice in that it converts several formats, including names to a RgbColor
    # the value is an object, so you can filter or modify it later.
    # compared to writing ansi colors inline, like Write.Fg
    param(
        [Parameter(ValueFromPipeline)][string[]] $Content
        # [object]$Separator
    )
    process {
        $Content | New-Text -fg 'violet' #-Separator $Separator
    }
}
# function WriteVioletColor {
#     # or purely Pwsh
#     param(
#         [Parameter(ValueFromPipeline)][string[]] $Content
#     )
#     begin {
#         $Violet = $PSStyle.Foreground.FromRgb('#c882f1')
#     }
#     process {
#         $Content | Join-String -f "$Violet"
#     }
# }
function Write.Color.usingPansies {
    <#
    .SYNOPSIS
        sugar to return Fg Colors as raw ansi escapes using the built in functions of Pwsh
    #>
    param(
        [ArgumentCompletions("'#c882f1'")]
        [Parameter(Position = 0)]
        [Alias('Fg', 'HexFg')]$ColorFg,

        [ArgumentCompletions("'#3882f1'")]
        [Parameter(Position = 1)]
        [Alias('Bg', 'HexBg')]$ColorBg,

        [Parameter(ValueFromPipeline)]
        [string[]] $Content,

        [switch]$LeaveColor
    )
    process {
        # you could include separator
        $newTextSplat = @{
            ForegroundColor = $ColorFg
            BackgroundColor = $ColorBg
            LeaveColor      = $LeaveColor
        }

        $Content | New-Text @newTextSplat
    }
}


Write.Fg '#c882f1' | Format-ShowControlChar
# Write.Fg '#c882f1' | Format-ShowEscapeChar

0..0x30 -as [Text.Rune[]]
    | Format-ShowControlChar
    | Join-string -sep ' '


'a'..'d' | Write.Color -Fg '#c882f1' | Join-String -sep ', '

'foo', 'hi world'
    | Join-String -op (Write.Bg -Hex '#303030') -sep ', '

'foo', 'bar'
    | Write.Color -Fg '#c882f1' -ColorBg '#3882f1'
    | Join-String -sep ', ' # -os $PSStyle.Reset -op $PSStyle.Reset

'Write.Color can return a collection of strings : '

'line1', 'line2' | Write.Color -Fg '#c882f1' -ColorBg '#3882f1'
    | Join-String -f "- ${fg:red}BeforeContent {0} After ${fg:clear}clear" -sep "`n"
<# outputs a collection of strings, 2.
    - BeforeContent line1 After clear
    - BeforeContent line2 After clear
#>

'line1', 'line2' | Write.Color -Fg '#c882f1' -ColorBg '#3882f1'
    | Join-String -f "- ${fg:red}BeforeContent {0} After ${fg:clear}clear" -sep ''
<# outputs single value, 1 string

    - BeforeContent line1 After clear- BeforeContent line2 After clear

#>

# Pansies will give you the gradient between two colors
$grads = Get-Gradient '#ce88aa' '#1e88aa' -Width 10
$grads | ForEach-Object {
    $_ | New-Text -fg $_
} | Join-String -sep ' ' -op 'Pansies generates gradients: '
# outputs color range: #CE88AA #C286B1 #B386B8 #A387BD #9088BF #7C88C0 #6689BE #5089B9 #3889B3 #1E88AA
