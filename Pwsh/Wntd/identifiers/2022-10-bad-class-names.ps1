#Requires -Version 7.2
'2022-10-17 save me'
'2022-10-20 save me'

'see also:
    <file:///My_Github\notebooks\Pwsh\Wntd\identifiers\2022-10 - scary identifiers as functions without errors.ipynb>

    <file:///C:\Users\cppmo_000\SkyDrive\Documents\2022\My_Github\notebooks\Pwsh\Wntd\identifiers\2022-10-bad-class-names.ps1>
'
'emphasis given on chaos, and worst maintainability possible'
'Examples of terrible practices, perhaps even evil. At a minimum, cursed.'
'Of course it does not support WinPS, did you think I was a monster?'



class Person {
    $Angle = 90
    $Name = 'bob'
    ${Full``Name} = 'bob hubert, montgomery, the 3rd.'
    ${Full`Name} = 'bob hubert, montgomery, the 1strd.'
    [int]${``FullName} = 'bob hubert, montgomery, the 1strd.'
    $FullName_safe = 'bob hubert, montgomery, the 3rd.'
}

[Per.son]::new()
$bob = [Per.son]@{ Name = 'jen' }


h1 'part3: What Not To Do'

class wntd3 {
    $bob = [Person2]::new()
    ${a``} = 'a'
    ${b```n`n``} = 2392
    ${c```na`n``f} = 5e1
}
[wntd3]::new() | to->Json
<#
output:
    [wntd3]::new()|to->Json

{
  "bob": {
    "Object": null
  },
  "a`": 42,
  "b`\n\n`": 42,
  "c`\na\n`f": 42
}
#>


h1 'part2'

class Person2 { $Object }
class wntd {
        $bob = [Person2]::new()
        ${a``} = 42
}

    $w = [wntd]::new()

$w | ft -AutoSize


$w.'a`' = 1e34
$w | fl 


Label 'bad' 'stuff'
[wntd]::new() | to->Json
hr 



try { 
    
    $str_herestring = @'
class Per.son { 
    [string]$Any
}
'@
[scriptblock]::new( $str_herestring ).Invoke()
# iex $str_herestring # ? 
} catch { 'invalid' }

try { 
    
    $sb_str = '
    class Per.son { 
        [string]$Any
    }'
    & $sb_str
} catch { 'invalid' }
