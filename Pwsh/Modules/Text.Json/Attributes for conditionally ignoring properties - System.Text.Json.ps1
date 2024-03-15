using namespace System.Collections.Generic
using namespace System.Text
using namespace System.Text.Json
using namespace System.Text.Json.Serialization
$assembly = Add-type -AssemblyName System.Text.Json -PassThru -ea 'stop'
goto $PSScriptRoot
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
    [JsonSerializer]::Serialize( <# value: #> $Object, <# tinfo #> $TypeInfo )
}

# [Serialization.JsonIgnore(Condition = [Serialization.JsonIgnoreCondition]::Always)]

@'
## Part 1:

As a base case, automatically serialize all properties (if able to)
'@

class Forecast {
    [datetime] $Date
    [int] $Degrees
    [string] $Summary
}

[Forecast]$CastObj = @{
   Degrees = 134    
   Date    = Get-Date
   Summary = 'sunny'
}

# when things are automatic, this invoke works.
$value = $CastObj
$jsonTypeInfo = [Forecast]
[JsonSerializer]::Serialize( <# value: #> $CastObj, <# jsonTypeInfo: #> [Forecast])
[JsonSerializer]::Serialize( <# value: #> $CastObj, $CastObj.GetType() )

@'
## Part 2:

A custom class with properties that won't coerce
example: [System.Diagnostics.Process]

Tons of properties will throw. I'm using '.modules' for the example

This class defines a couple of properties that will auto-assign by name
if you keep a parameter-less c-tor.
'@ | Out-Null

# [Text.Json.Serialization.JsonIgnoreCondition]
# [JsonIgnore(Condition = JsonIgnoreCondition.WhenWritingDefault)]
# [Serialization.JsonIgnoreCondition([Serialization.JsonIgnoreCondition]::Always )]
# [Serialization.JsonIgnoreAttribute]
# [Serialization.JsonIgnore(Condition = 'always')]$Modules

class SimpleProcess {
    [string]$Name
    [string]$CommandLine

    [Datetime]$When

    # a property that normally errors out (with default serialization)
    # or: [System.Text.Json.Serialization.JsonIgnoreAttribute()]
    [Serialization.JsonIgnoreAttribute()]
    [Diagnostics.ProcessModuleCollection]$Modules

    # and a property to only ignore when null

    # [Serialization.JsonIgnoreCondition(
    #    'always'
    # )]
    [JsonIgnoreAttribute( Condition = [JsonIgnoreCondition]::WhenWritingNull) ]
    [object]$MaybeData

    SimpleProcess ( ) {
        $This.When      = Get-Date
        $this.MaybeData = $Null
    }
    SimpleProcess ( [object]$Other ) {
        $this.When        = Get-Date
        $this.MaybeData   = $Null
        $This.CommandLine = ($Other)?.CommandLine ?? ''
        $This.Modules     = ($Other)?.Modules
        # $this.Modules     =  ($Other)?.Modules
        # $this.Modules = 0..10
        # $this.Modules     =  ($Other)?.Modules
    }
}

$pslist = [SimpleProcess[]] @( ps  | s -first 2)
$psList[0].MaybeData = @{ Name = 'Jen' ; Species = 'cat' }

h1 'should only serialize .MaybeData for one result'
AutoJson $pslist| jq
return

[SimpleProcess] @(ps | s -first 1 )
# return
[List[Object]] $Records = @(
    # class coerce from an object
    [SimpleProcess] (get-process pwsh | s -First 1)

    # explicit ctor
    [SimpleProcess]::new()

    # automatic if parameterless c-tor:
    [SimpleProcess] @{}

    # a similar variation
    $One = Get-Process 'pwsh' | Select -first 1
    [SimpleProcess] $One
)

$records | ft -auto

# neat, it works without extra work
AutoJson $Records
@'
[{"Name":null,"CommandLine":"pwsh.exe -nol","When":"2024-01-19T15:13:20.8026851-06:00"},{"Name":null,"CommandLine":null,"When":"2024-01-19T15:13:21.0254829-06:00"},{"Name":null,"CommandLine":"","When":"2024-01-19T15:13:21.0266413-06:00"},{"Name":null,"CommandLine":"pwsh.exe -nol","When":"2024-01-19T15:13:21.0397003-06:00"}]

If you didn't ignore that property, you'd get an error

Error will occur if 'modules' isn't excluded

AutoJson -IN $simple

MethodInvocationException: H:\data\2024\pwsh\sketch\2024-01-18-WeatherSerializeJson\WeatherFor
ecast-System.Text.Json--part2.ps1:15:5
Line |
  15 |      [JsonSerializer]::Serialize( <# value: #> $Object, $TypeInfo )
     |      ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
     | Exception calling "Serialize" with "2" argument(s): "Serialization and deserialization
     | of 'System.IntPtr' instances is not supported. Path: $.Modules.BaseAddress."
#>
'@ | Out-Null

# string jsonString = JsonSerializer.Serialize<WeatherForecast>(weatherForecast);


# AutoJson -IN $simple

@'
See more:
- [c# Text.Json intro](https://learn.microsoft.com/en-us/dotnet/standard/serialization/system-text-json/how-to)

[JsonSerializer]::Serialize
[JsonSerializer]::SerializeAsync
[JsonSerializer]::SerializeToDocument
[JsonSerializer]::SerializeToElement
[JsonSerializer]::SerializeToNode
[JsonSerializer]::SerializeToUtf8Bytes
'@
