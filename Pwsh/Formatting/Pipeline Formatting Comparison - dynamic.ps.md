## About:

- [About:](#about)
- [Sample A](#sample-a)
  - [Using default formatter settings](#using-default-formatter-settings)
- [Manual Experiments](#manual-experiments)
  - [PS5](#ps5)


## Sample A

### Using default formatter settings[]

Before


```ps1
~~~pipescript{
$rawSource = @'
gcm Invoke-RestMethod
    | PSScriptTools\Get-ParameterInfo
    | Sort-Object Type, name
    | ft -AutoSize Name, Aliases, type -GroupBy { $true }
'@
}~~~
```

**Before**

```ps1
~~~pipescript{
$rawSource
}~~~
```

**default config**

before 
```ps1
~~~pipescript{
$rawSource | Invoke-Formatter
}~~~
```
## Manual Experiments

### PS5 

```ps1
gcm Invoke-RestMethod |
     PSScriptTools\Get-ParameterInfo |
     Sort-Object Type, name |
     ft -AutoSize Name, Aliases, type -GroupBy {$true}
```
```ps1
gcm Invoke-RestMethod |
     PSScriptTools\Get-ParameterInfo |
     Sort-Object Type, name |
     ft -AutoSize Name, Aliases, type -GroupBy {$true}
```