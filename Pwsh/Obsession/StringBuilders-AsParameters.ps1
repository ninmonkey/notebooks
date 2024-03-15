$maxLen = [Math]::Clamp( 100, 0, 'cdb'.Length )
'bbd'.Substring( 0, $maxLen )

function String.Clamp {
    param(
        [string]$InputText = '',
        [int]$RelativePos
    )
    if($RelativePos -lt 0) {
        $finalPos = $InputText.Length + $RelativePos
    } else {
        $finalPos = $RelativePos
    }
    # Clamp: 10, 0, 3 => 3
    # 'abc'.Substring(0, 3) => 'abc'
    $ClampedLen = [Math]::Clamp( $FinalPos, 0, $InputText.Length)
    $InputText.Substring( <# startIndex: #> 0, <# length: #> $ClampedLen)
}

String.Clamp 'abcd' 4 | SHould -BeExactly 'abcd'
String.Clamp 'abcd' 0 | SHould -BeExactly ''
String.Clamp 'abcd' -1 | SHould -BeExactly 'abc'

# function Sb.JoinPipe


return


# Experimenting with strange parameters
function SB.Render {
    param(
        [Text.StringBuilder]$SingleSB = '',
        [Text.StringBuilder[]]$ListSB = @() )

    # appears to be creating an array of string builders, not an array as a string builder
    ($ListSb)?.ToString()
        | Label (Join-String -f 'init ListSB [{0}]:  ' -in $ListSb.Count)

    $ListSB.ToString() -join ' ' | Join-String -op 'sb: '
    $SingleSB.ToString() | Join-String -os 'Single: '
}

Sb.Render -List 'jen', 'bob'
Sb.Render -Single 'ted mittens'

function Sb.Accum {
    param( [Text.StringBuilder]$Sb = '' )

    $null = $Sb.Append( (get-date).ToString('o') )
    $sb
}


$zed = Sb.Accum 'hi world'
$zed.ToString()
($zed2)?.tostring()

$zed2 = Sb.Accum $zed
$zed.ToString() | Label 'final'
