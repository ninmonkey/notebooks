## About:



## Sample A

### Using default formatter settings

Before

```ps1
gcm Invoke-RestMethod
    | PSScriptTools\Get-ParameterInfo
    | Sort-Object Type, name
    | ft -AutoSize Name, Aliases, type -GroupBy { $true }
```

After

```ps1
~~~pipescript{
@'
gcm Invoke-RestMethod
    | PSScriptTools\Get-ParameterInfo
    | Sort-Object Type, name
    | ft -AutoSize Name, Aliases, type -GroupBy { $true }
'@ | Invoke-Formatter

}~~~
```



```ps1
gcm Invoke-RestMethod |
     PSScriptTools\Get-ParameterInfo |
     Sort-Object Type, name |
     ft -AutoSize Name, Aliases, type -GroupBy {$true}
    ```