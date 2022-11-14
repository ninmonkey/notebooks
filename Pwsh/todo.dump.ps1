@'
see: <https://github.com/StartAutomating/PipeScript/blob/main/Transpilers/Syntax/Dot.psx.ps1>

- Dot Notation simplifies multiple operations on one or more objects.
- Any command named . (followed by a letter) will be treated as the name of a method or property.
- .Name will be considered the name of a property or method
- If it is followed by parenthesis, these will be treated as method arguments.
- If it is followed by a ScriptBlock, a dynamic property will be created that will return the result of that script block.
- If any other arguments are found before the next .Name, they will be considered arguments to a method.
'@

h1 'part2'

.> {  "dsfsd", "🐒🐒" | .length .codepoints = $_.EnumerateRunes().Value.Count  } -ov 'lass'

$lass | iot2 -NotSkipMost -PassThru
| select -prop *name*, is*, *type*, * -ea ignore
| Ft

hr

.> {  "dsfsd", "🐒🐒" | .length .codepoints = { $_.EnumerateRunes().Value.Count  } } -ov 'lass'

$lass | iot2 -NotSkipMost -PassThru 
| select -prop *name*, is*, *type*, * -ea ignore
| Ft

h1 'part1'

.> {  "dsfsd", "🐒🐒" | .length .codepoints = $_.EnumerateRunes().Value.Count  } -ov 'lass'

$lass | iot2 -NotSkipMost -PassThru
| select *name*, *type* -ea ignore
#| select -prop *name*, is*, *type*, * -ea ignore
| Ft

hr

.> {  "dsfsd", "🐒🐒" | .length .codepoints = { $_.EnumerateRunes().Value.Count  } } -ov 'lass'

$lass | iot2 -NotSkipMost -PassThru 
#| select -prop *name*, is*, *type*, * -ea ignore
| select *name*, *type* -ea ignore
| Ft