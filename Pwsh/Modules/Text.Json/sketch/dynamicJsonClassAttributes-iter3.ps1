#Requires -Version 7
using namespace System.Collections.Generic
using namespace System.Text
using namespace System.Text.Json
using namespace System.Text.Json.Serialization
using namespace System.Linq

$assembly = Add-type -AssemblyName System.Text.Json -PassThru -ea 'stop'

# This isn't an example of what you should do, it's testing what you can do

function AutoJson {
    <#
    .SYNOPSIS
        Try one of the automatic methods
    .notes
        [System.Text.Json.JsonSerializer] has a ton of overloads
    .LINK
        https://docs.microsoft.com/en-us/dotnet/api/system.text.json.jsonserializer?view=net-8.0#methods
    #>
    [CmdletBinding()]
    param(
        [Parameter(ValueFromPipeline)]
        [Alias('InObj', 'In')]
        [object] $Object,

        # Without a type, it falls back to GetType()
        [Alias('Tinfo', 'T')]
        [type] $TypeInfo
    )
    process {
        if(-not $TypeInfo ) { $TypeInfo = $Object.GetType() }
        [Text.Json.JsonSerializer]::Serialize( <# value: #> $Object, <# tinfo #> $TypeInfo )

        'AutoJson: TryConvert type: {0}' -f $TypeInfo | Write-verbose
    }
}

$error.clear()
$PSDefaultParameterValues['AutoJson:Ea'] = 'break'
$PSDefaultParameterValues['AutoJson:Ea'] = 'continue'

class SomePS {
    [string] $ProcessName
    [int] $Id


    # [example kind 1]: Property on instances to include, but, never serialize it
    [Serialization.JsonIgnoreAttribute()]
    [Diagnostics.ProcessModuleCollection] $Modules

    # [example kind 2]: Serialize property if it's not null, but ignore it if it's null
    # note: It does not work here beacuse [object][string]::empty is not null
    [JsonIgnoreAttribute( Condition = [JsonIgnoreCondition]::WhenWritingNull) ]
    [object] $MainWindowTitle

    SomePS ( [object]$Other ) {
        $WantedProps = [Linq.Enumerable]::Intersect( # because linq is fun
            [string[]]  $This.PSObject.Properties.Name,
            [string[]] $Other.PSObject.Properties.Name )

        foreach($PropName in $WantedProps) {
            $This.$PropName = $Other.$PropName
        }
        # hard coded version:
        # $This.ProcessName     = $Other.ProcessName
        # $This.Id              = $Other.Id
        # $this.MainWindowTitle = $Other.MainWindowTitle
        # $This.Modules         = $Other.Module
    }
}
$hasModules = get-process | ? Modules | select -First 1
$hasTitle   = ( ps ) | ? MainWindowTitle | select -first 1
$noTitle    = ( ps ) | ? -not MainWindowTitle | select -first 1
$notNullSite = (get-process | ?{ $Null -eq $_.site })

# [a] works
$hasModules -as [SomePS[]]
<#  Out:
    ProcessName             Id Modules
    -----------             -- -------
    ApplicationFrameHost 19636 {System.Diagnostics.ProcessModule (ApplicationFrameHost.exe), System.Diagnost ....
#>

$hasModules -as [SomePS[]] | %{ AutoJson -InObj $_ -TypeInfo ([SomePS]) }
<#  Out:
    {"ProcessName":"ApplicationFrameHost","Id":19636}
#>

# cool, typedata is constrained to derived types
{
    $hasModules -as [SomePS[]] | %{ AutoJson -InObj $_ -TypeInfo ([System.Diagnostics.Process]) }
} | Should -Throw -because 'Typedef used did not derive from type'
<#  Out:
    Exception calling "Serialize" with "2" argument(s): "The specified
        type [System.Diagnostics.Process] must derive from the specific value's type [SomePS]."
#>

# [b] not quite working
h1 '[b]'
$hasTitle -as [SomePs[]] | %{ AutoJson -InObj $_ }


$hasModules, $hasTitle, $noTitle -as [SomePs[]]
    | AutoJson

<# Outputs:
    {"ProcessName":"ApplicationFrameHost","Id":19636,"MainWindowTitle":"Snip \u0026 Sketch"}
    {"ProcessName":"AggregatorHost","Id":9268,"MainWindowTitle":""}
#>
