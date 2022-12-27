## NameIt.ToPost.md

- discoverabilty ? 
- custom fields, easier?
    - [ ] currently is duplicating 
- new definitions? 
    - `[animal]` = 'list-of-animals.txt'

```ps1
$template = '
Color = [color]
Id = {0}
'  -f @( 
    $script:guid++
)

InvokeGenerate $Template -Count 5
```