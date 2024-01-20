- [To Import Namespace](#to-import-namespace)
- [Serialization](#serialization)
  - [Ignoring Properties : `JsonIgnoreAttribute`](#ignoring-properties--jsonignoreattribute)
    - [Ignore When null : `JsonIgnoreCondition`](#ignore-when-null--jsonignorecondition)
    - [Always Ignore](#always-ignore)
- [Deserialization](#deserialization)

## To Import Namespace

```ps1
using namespace System.Collections.Generic
using namespace System.Text
using namespace System.Text.Json
using namespace System.Text.Json.Serialization
$assembly = Add-type -AssemblyName System.Text.Json -PassThru -ea 'stop'
```

## Serialization

### Ignoring Properties : `JsonIgnoreAttribute`

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
