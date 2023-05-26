## About:







## Sample A

### Using default formatter settings

Before


```ps1

```

**Before**

```ps1
gcm Invoke-RestMethod
| PSScriptTools\Get-ParameterInfo
| Sort-Object Type, name
| ft -AutoSize Name, Aliases, type -GroupBy { $true }
```

**default config**

before 
```ps1
gcm Invoke-RestMethod
| PSScriptTools\Get-ParameterInfo
| Sort-Object Type, name
| ft -AutoSize Name, Aliases, type -GroupBy { $true }
```

After

```ps1

```



```ps1
gcm Invoke-RestMethod |
     PSScriptTools\Get-ParameterInfo |
     Sort-Object Type, name |
     ft -AutoSize Name, Aliases, type -GroupBy {$true}
    ```
