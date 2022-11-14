## [ ] get / pick

```ps1
all $randColors where { $_.X11ColorName -match 'red' } | get first 2
all $gradient Where IsBright | Get first 3
all $gradient Where IsBright | Get 3
```

## [ ] random : choose

```ps1
all $gradient Where IsBright | choose 3
```


## [ ] multi type statements
```ps1
Pwsh> .> { .name = 'Ant' .alias = 'Jen'  } are tiny, insect -ov 'last'

name alias
---- -----
Ant  Jen

$last.PSTypeNames
    Tiny, Insect
```

## [ ] long-form record syntax
```ps1
.> { .a = 3  .b = 3 }
.> { .name = 'bob' .id = 34 .region = 'east' } are human 
.> {    .name = 'bob' `
        .id = 34 .region = 'east' } are human 
```


```ps1
all $purp_ish Where { 
     'cGray' -in @($_.pstypenames) -and 'cDark' -notin @($_.pstypenames) }
```