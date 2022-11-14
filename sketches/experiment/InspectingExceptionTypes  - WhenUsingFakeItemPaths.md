
```mermaid
classDiagram
class Shape{
    <<interface>>
    noOfVertices
    draw()
}
class Color{
    <<enumeration>>
    RED
    BLUE
    GREEN
    WHITE
    BLACK
}
```

## inheritance:
```ps1
Pwsh> $error[2] | io |  ft Type, Name, Value

Type                    Name                  Value
----                    ----                  -----
                        PSMessageDetails      <␀>
                        ErrorDetails          <␀>
                        PipelineIterationInfo <Blank>
[ErrorCategoryInfo]     CategoryInfo          ObjectNotFound: (C:\foo\bar:String) [Get-Item], ItemNotFoundException
[InvocationInfo]        InvocationInfo        System.Management.Automation.InvocationInfo
[ItemNotFoundException] Exception             System.Management.Automation.ItemNotFoundException: Cannot find path 'C:\foo\bar' because it does not exist.…
[string]                TargetObject          C:\foo\bar
[string]                FullyQualifiedErrorId PathNotFound,Microsoft.PowerShell.Commands.GetItemCommand
[string]                ScriptStackTrace      at Resolve-FileInfo<Process>, C:\nin_temp\now\try-irm.ps1: line 25…
```


```ps1
FileInfo : FileSystemInfo
DirectoryInfo : FileSystemInfo

        Pwsh>
            gi 'c:\foo\bar'

        Err
            $error[0].CategoryInfo

            Cannot find path 'C:\foo\bar' because it does not exist.

                Category   : ObjectNotFound
                Activity   : Get-Item
                Reason     : ItemNotFoundException
                TargetName : C:\foo\bar
                TargetType : String
```

## stuff

```ps1
3！7.2.6 C:\nin_temp\now
Pwsh> $error[2] | io | Format-Table Type, Name, Value

Get-Content Name Value
----                    ----                  ---- -
PSMessageDetails      <␀>
ErrorDetails          <␀>
PipelineIterationInfo <Blank>
[ErrorCategoryInfo]     CategoryInfo ObjectNotFound: (C:\foo\bar:String) [Get-Item], ItemNotFoundException
[InvocationInfo]        InvocationInfo System.Management.Automation.InvocationInfo
[ItemNotFoundException] Exception System.Management.Automation.ItemNotFoundException: Cannot find path 'C:\foo\bar' because it does not exist.…
[string]                TargetObject C:\foo\bar
[string]                FullyQualifiedErrorId PathNotFound, Microsoft.PowerShell.Commands.GetItemCommand
[string]                ScriptStackTrace at Resolve-FileInfo<Process>, C:\nin_temp\now\try-irm.ps1: line 25…

```