using namespace System.Collections.Generic
using namespace System.IO
using namespace System.Linq
using namespace System.Text
using namespace System.Text.Json
using namespace System.Text.Json.Serialization
$assembly = Add-type -AssemblyName System.Text.Json -PassThru -ea 'stop'
pushd $PSScriptRoot
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

# [JsonSerializer]::Serialize( <# value: #> $CastObj, <# jsonTypeInfo: #> [Forecast])
# [JsonSerializer]::Serialize( <# value: #> $CastObj, $CastObj.GetType() )

class SimpleProcess {
    [string]$Name
    [string]$CommandLine

    # example kind1: something that should never serialize
    [Serialization.JsonIgnoreAttribute()]
    [Diagnostics.ProcessModuleCollection] $Modules

    # some property that can be blank
    # example kind2: serialize when not null
    [JsonIgnoreAttribute( Condition = [JsonIgnoreCondition]::WhenWritingNull) ]
    [string]$MainWindowTitle = ''

    SimpleProcess ( ) {
    }
    SimpleProcess ( [object]$Other ) {
        # $This.Name            = ($Other)?.Name ?? ''
        # $This.CommandLine     = ($Other)?.CommandLine ?? ''
        # $this.MainWindowTitle = ($Other)?.MainWindowTitle ?? ''
        # $This.Modules         = ($Other)?.Modules
        $WantedProps = [Linq.Enumerable]::Intersect(
            [string[]] $This.PSObject.Properties.Name,
            [string[]] $Other.PSObject.Properties.Name )

        foreach($PropName in $WantedProps) {
            $This.$PropName = $Other.$PropName
        }
    }
}

$pslist = [SimpleProcess[]] @(
    Get-Process
        | Select-First -first 3
    Get-Process
        | ?{ $_.MainWindowTitle.length -gt 0 }
        | select -first 1
)
h1 'should only serialize .MaybeData for one result'
AutoJson $pslist| jq

<#
other ways to instantiate object
#>
[SimpleProcess] @(get-process | select-object -first 1 )
# return
[List[Object]] $Records = @(
    # class coerce from an object
    [SimpleProcess] (get-process pwsh | Select-Object -First 1)

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

<#
example output:
[{"Name":"pwsh","CommandLine":"\u0022C:\\Program Files\\PowerShell\\7\\pwsh.exe\u0022 -WorkingDirectory ~"},{"Name":null,"CommandLine":null},{"Name":"","CommandLine":""},{"Name":"pwsh","CommandLine":"\u0022C:\\Program Files\\PowerShell\\7\\pwsh.exe\u0022 -WorkingDirectory ~"}]

- [c# Text.Json intro](https://learn.microsoft.com/en-us/dotnet/standard/serialization/system-text-json/how-to)
#>

AutoJson $pslist[-1]
AutoJson $pslist[0]
<#
Outputs:
{"Name":"ApplicationFrameHost","CommandLine":"C:\\WINDOWS\\system32\\ApplicationFrameHost.exe -Embedding","MainWindowTitle":"Settings"}
{"Name":"AppleMobileDeviceService","CommandLine":"","MainWindowTitle":""}
#>
