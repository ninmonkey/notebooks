## About:



## Sample A

### Using default formatter settings

```ps1
gcm Invoke-RestMethod
| PSScriptTools\Get-ParameterInfo
| Sort-Object Type, name
| ft -AutoSize Name, Aliases, type -GroupBy { $true }
```


```ps1
gcm Invoke-RestMethod |
     PSScriptTools\Get-ParameterInfo |
     Sort-Object Type, name |
     ft -AutoSize Name, Aliases, type -GroupBy {$true}
    ```