#Requires -Version 7.2
'2022-10-17 save me'

'see also:
    <file:///My_Github\notebooks\Pwsh\Wntd\identifiers\2022-10 - scary identifiers as functions without errors.ipynb>

    <file:///C:\Users\cppmo_000\SkyDrive\Documents\2022\My_Github\notebooks\Pwsh\Wntd\identifiers\2022-10-bad-class-names.ps1>
'


'emphasis given on chaos, and worst maintainability possible'
'Examples of terrible practices, perhaps even evil. At a minimum, cursed.'
'Of course it does not support WinPS, did you think I was a monster?'

function dropIfNull { 
    param()
}

function todo.span.rand {
@'
get array of rand bytes or number
        NextBytes(Span<byte> buffer);
        $bad.rand.NextBytes
'@
}

[ValidateNotNull()][hashtable]$script:bad = @{}

$script:bad.rand = $script:bad.reneg = [Random]::new()

function bad.rand.int { param( [int]$Min, [int]$Max ) $script:bad.rand.NextInt64($min, $max)  }
function bad.rand.double { $bad.rand.NextDouble() }

function bad.write.rand.spacing {
    # bad.rand.int 0 ([console]::BufferWidth)
    ' ' * (bad.rand.int 0 ([console]::WindowWidth))
}
function bad.rand.hexByteStr {(
    '{0:x}' -f  $bad.rand.NextInt64(0, 0xff)
).PadLeft(2, '0')}

function bad.rand.color.hexStr {@('#'
    bad.rand.hexByteStr ; bad.rand.hexByteStr ; bad.rand.hexByteStr
) -join ''}

function idea.break.graphemes.only {
    throw 'NYI: purposely break bytes on encoded text, when emoji''s or otherwise,
    but enumerate on [rune]s, to preserve the actual, real, text
    '

}
function bad.rand.sleep {

}
bad.rand.color.hexStr

function bad.write.rand.color.fg { $PSStyle.Foreground.FromRgb( (bad.rand.color.hexStr) ) }
function bad.write.rand.color.bg { $PSStyle.Background.FromRgb( (bad.rand.color.hexStr) ) }

0..99 | %{
    'hi'
    bad.write.rand.color.fg
    'stuff'
    bad.write.rand.color.bg
    'more'
}

gcm 'bad.*'