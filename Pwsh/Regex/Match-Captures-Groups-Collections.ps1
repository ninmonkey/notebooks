
$single = [regex]::Matches('a9', '9')

$few = [regex]::Matches('sda324r32 d23 ew', '(?<Token>.+)')
$few.Captures.Groups | Ft
$few.Groups | Ft

$single[0].Groups                        | Ft ; hr ;
$single[0].Captures.groups               | Ft
                                           hr -fg magenta
$few[0].Groups                           | Ft ; hr ;
$few[0].Captures.groups                  | Ft

$single | %{ $_.Captures[0].Groups[0].gettype()   } # -is <Match : Group>
$single | %{ $_.Captures[0].Groups[999].gettype() } # -is <Group : Capture>
$single | %{ $_.Captures[0].Groups.count }          # but the length is 1

$few | %{ $_.Captures[0].Groups[0].gettype()   } # -is <Match : Group>
$few | %{ $_.Captures[0].Groups[999].gettype() } # -is <Group : Capture>
$few | %{ $_.Captures[0].Groups.count }          # but the length is 2

$few | %{ $Null -eq $_.Captures[1] } # Is always true null for >= 1
