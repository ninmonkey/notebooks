- [To Import Namespace](#to-import-namespace)
- [Serialization](#serialization)
  - [ToString : `JsonSerializer::Serializer( o, type )`](#tostring--jsonserializerserializer-o-type-)
  - [Ignoring Properties : `JsonIgnoreAttribute`](#ignoring-properties--jsonignoreattribute)
    - [Ignore When null : `JsonIgnoreCondition`](#ignore-when-null--jsonignorecondition)
    - [Always Ignore](#always-ignore)
- [Deserialization](#deserialization)
- [Other](#other)
  - [AutoJson helper class](#autojson-helper-class)

## To Import Namespace

```ps1
using namespace System.Collections.Generic
using namespace System.Text
using namespace System.Text.Json
using namespace System.Text.Json.Serialization
$assembly = Add-type -AssemblyName System.Text.Json -PassThru -ea 'stop'
```

## Serialization

### ToString : `JsonSerializer::Serializer( o, type )`

Using the `[type]` overload
```ps1
class SimpleProcess { ... } 
[SimpleProcess] $Obj = Get-process -PID $PID
[JsonSerializer]::Serialize( <# value: #> $Obj, <# jsonTypeInfo: #> [SimpleProcess])
[JsonSerializer]::Serialize( <# value: #> $Obj, $Obj.GetType() )
```

### Ignoring Properties : `JsonIgnoreAttribute`

| enum `JsonIgnoreCondition` |
| -------------------------- |
| Never                      |
| Always                     |
| WhenWritingDefault         |
| WhenWritingNull            |

#### Ignore When null : `JsonIgnoreCondition`

```ps1
class SimpleProcess { 
    [string] $Name

    [JsonIgnoreAttribute( Condition = [JsonIgnoreCondition]::WhenWritingNull) ]
    [object]$MaybeData
}
```

#### Always Ignore

```ps1
class SimpleProcess { 
    [string] $Name

    # always skip
    [Serialization.JsonIgnoreAttribute()]
    [Diagnostics.ProcessModuleCollection] $Modules
}
```


## Deserialization

## Other

### AutoJson helper class

```ps1
function AutoJson {
    <#
    .SYNOPSIS
        Try one of the automatic methods
    .notes
        [System.Text.Json.JsonSerializer] has a ton of overloads
    .LINK
        https://docs.microsoft.com/en-us/dotnet/api/system.text.json.jsonserializer?view=net-8.0#methods
    #>
    param(
        [Alias('InObj', 'In')]
        [object] $Object,

        # Without a type, it falls back to GetType()
        [Alias('Tinfo', 'T')]
        [type] $TypeInfo
    )
    if(-not $TypeInfo ) { $TypeInfo = $Object.GetType() }
    [Text.Json.JsonSerializer]::Serialize( <# value: #> $Object, <# tinfo #> $TypeInfo )
}
```
