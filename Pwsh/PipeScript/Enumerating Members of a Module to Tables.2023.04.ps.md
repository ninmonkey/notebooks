- [try 1: saved as yaml](#try-1-saved-as-yaml)
- [try 2 : shows table](#try-2--shows-table)
- [try 3 : shows table of all](#try-3--shows-table-of-all)


<!-- get-alias | ? Source -EQ 'pipescript'|sort -->

## try 1: saved as yaml 

Output results as a yaml code-fence.

```yml
~~~pipescript{
Import-Module powershell-yaml -scope 'global'

get-alias 
| ? Source -EQ 'pipescript'
| select-Object -First 3 
| select-Object ModuleName, ResolvedCommandName, DisplayName, Segments, Separator, Synopsis, Namespace, CommandType #, Parameters
| Sort-Object
| ConvertTo-Yaml
}~~~
```
## try 2 : shows table

If an object has the property `Table`, it will automatically output as `markdown tables`

~~~pipescript{
Import-Module powershell-yaml -scope 'global'

$results = get-alias 
| ? Source -EQ 'pipescript'
| select-Object -First 3 
| select-Object ModuleName, ResolvedCommandName, DisplayName, Segments, Separator, Synopsis, Namespace, CommandType #, Parameters
| Sort-Object

[pscustomobject]@{ 
    Table = $Results | sort-Object name 
}

}~~~

## try 3 : simplified #4


~~~pipescript{

$results = get-alias 
| ? Source -EQ 'pipescript'
| select-Object -ea ignore ModuleName, ResolvedCommandName, DisplayName,  Synopsis, Namespace, CommandType
| Sort-Object ModuleName, ResolvedCommandName, Name, DisplayName -ea ignore 

# simplify for readability 

[pscustomobject]@{ 
    Table = $Results
    | Select -Exclude 'ModuleName'
}
}~~~

## Try 4 verbose

~~~pipescript{

$results = get-alias 
| ? Source -EQ 'pipescript'
| select-Object ModuleName, ResolvedCommandName, DisplayName, Segments, Separator, Synopsis, Namespace, CommandType #, Parameters
| Sort-Object ModuleName, Name, DisplayName, ResolvedCommandName

# simplify for readability 

[pscustomobject]@{ 
    Table = $Results
    | Select -Exclude 'ModuleName'
}
}~~~




