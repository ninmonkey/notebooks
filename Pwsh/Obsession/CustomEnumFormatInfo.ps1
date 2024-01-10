<#
this script outputs:

0x300000000
300000000
0000000300000000
0000000100000000
0000000100000000
0000000100000000
0000000100000000

Name                                                Value
----                                                -----
4294967296 | Join-String -f '{0:x}'                 100000000
'{0:x}' -f $o                                       0000000100000000
'{0:x}' -f $o.value__                               100000000
$o.ToString('x')                                    0000000100000000
$o.value__.ToString('x')                            100000000
Join-String -f '{0:x}'                              0000000100000000
Join-String -f '{0:x}' -Property value__            100000000
[enum]::Format( [e], $o.value__, 'x' )              0000000100000000
[enum]::Format( [e], $o, 'x' )                      0000000100000000
[enum]::Format( [e], ([e]4294967296).value__, 'x' ) 0000000100000000
[enum]::Format( [e], ([e]4294967296), 'x' )         0000000100000000


F1 F2    Str1 Str2             ToStr_None ToStr_F1         '{0:x}' -f enum  '{0:x}' -f enum.value__
-- --    ---- ----             ---------- --------         ---------------  -----------------------
G  {0:G} G    A                A          A                0000000100000000 100000000
g  {0:g} g    A                A          A                0000000100000000 100000000
F  {0:F} F    A                A          A                0000000100000000 100000000
f  {0:f} f    A                A          A                0000000100000000 100000000
D  {0:D} D    4294967296       A          4294967296       0000000100000000 100000000
d  {0:d} d    4294967296       A          4294967296       0000000100000000 100000000
X  {0:X} X    0000000100000000 A          0000000100000000 0000000100000000 100000000
x  {0:x} x    0000000100000000 A          0000000100000000 0000000100000000 100000000
#>

@'
See also:
    - [docs: enum format strings](https://learn.microsoft.com/en-us/dotnet/standard/base-types/enumeration-format-strings)
'@
function tryAll {

    param(
        [enum]$Obj
    )
    'G','g', 'F','f', 'D', 'd', 'X', 'x' | %{
        $fStr = $_
        $PosStr = '{0:', $fstr, '}' -join ''
        [pscustomobject]@{
            F1     = $Fstr
            F2     = $PosStr

            Str1 = $Fstr -f $Obj
            Str2 = $PosStr -f $Obj

            ToStr_None    = $Obj.ToString()
            ToStr_F1 = $Obj.ToString( $fstr )

            "'{0:x}' -f enum"  = '{0:x}' -f $Obj
            "'{0:x}' -f enum.value__"  = '{0:x}' -f $Obj.value__
        }
    }
}
[Flags()]
enum e : ulong
{
  A  = 0x100000000
  B  = 0x200000000
}

'0x{0:X}' -f ([e]'A, B').value__
'{0:x}' -f ([e]'A, B').value__
[e]'A, B' | Join-String -f '{0:x}' { $_ }
$o = [e]'A'

$lo = 4294967296l
# all for of these variations all format with the custom zero-prefixed numbers
[enum]::Format( [e], ([e]$lo).value__, 'x' )
[enum]::Format( [e], ([e]$lo), 'x' )
[enum]::Format( [e], $o.value__, 'x' )
[enum]::Format( [e], $o, 'x' )

<# it appears to be calling something roughly like


$someLong = 4294967296l
$someLong.ToString('x')
    vs
$o.ToString('x')

#>

[ordered]@{
    "4294967296 | Join-String -f '{0:x}'" =
        4294967296 | Join-String -f '{0:x}'

    "'{0:x}' -f `$o" =
        '{0:x}' -f $o

    "'{0:x}' -f `$o.value__" =
        '{0:x}' -f $o.value__

    "`$o.ToString('x')" =
        $o.ToString('x')

    "`$o.value__.ToString('x')" =
        $o.value__.ToString('x')

    "Join-String -f '{0:x}'" =
        $o | Join-String -f '{0:x}'

    "Join-String -f '{0:x}' -Property value__" =
        $o | Join-String -f '{0:x}' -Property value__

    "[enum]::Format( [e], `$o.value__, 'x' )" =
        [enum]::Format( [e], $o.value__, 'x' )

    "[enum]::Format( [e], `$o, 'x' )" =
        [enum]::Format( [e], $o, 'x' )

    "[enum]::Format( [e], ([e]$lo).value__, 'x' )" =
        [enum]::Format( [e], ([e]$lo).value__, 'x' )
    "[enum]::Format( [e], ([e]$lo), 'x' )" =
        [enum]::Format( [e], ([e]$lo), 'x' )


} |
ft -AutoSize

tryAll $o|ft
