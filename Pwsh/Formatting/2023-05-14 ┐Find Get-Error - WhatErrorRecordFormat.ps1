@'
to try JSON serialization

## Json dotnet6+

- [\[NewtonSoft.Json\] to \[Json.Text\] table](https://learn.microsoft.com/en-us/dotnet/standard/serialization/system-text-json/migrate-from-newtonsoft?pivots=dotnet-7-0#table-of-differences-between-newtonsoftjson-and-systemtextjson)
- [Supported Generic Collection Types](https://learn.microsoft.com/en-us/dotnet/standard/serialization/system-text-json/supported-collection-types?pivots=dotnet-7-0)
- [System.Text.Json TOC](https://learn.microsoft.com/en-us/dotnet/standard/serialization/system-text-json/overview)
- <https://learn.microsoft.com/en-us/dotnet/standard/serialization/system-text-json/how-to?pivots=dotnet-8-0#how-to-write-net-objects-as-json-serialize>
- [Polymorphic Serialization](https://learn.microsoft.com/en-us/dotnet/standard/serialization/system-text-json/polymorphism?pivots=dotnet-7-0#polymorphic-type-discriminators)
- [AutoIgnore or include prop name attribute](https://learn.microsoft.com/en-us/dotnet/standard/serialization/system-text-json/ignore-properties?pivots=dotnet-7-0)
- [Reflection vs Serialization](https://learn.microsoft.com/en-us/dotnet/standard/serialization/system-text-json/source-generation-modes?pivots=dotnet-8-0)
- customizing prop names

## Pwsh Error Test

- [Get-Error Implementation](https://github.com/PowerShell/PowerShell/blob/master/src/Microsoft.PowerShell.Commands.Utility/commands/utility/Get-Error.cs)
- [Get-Error unit tests](https://github.com/PowerShell/PowerShell/blob/master/test/powershell/Modules/Microsoft.PowerShell.Utility/Get-Error.Tests.ps1)


It's declared as returning:
    - [System.Management.Automation.ErrorRecord#PSExtendedError]
    - [System.Exception#PSExtendedError]

    - [sma.ErrorRecord#PSExtendedError]
    - [Exception#PSExtendedError]
'@



function __makeError.Sample1 {
    Join-Path '.' 'someFakepath' | Get-Item -ea 'continue'
    (3525).Replace('adf', 'fdd')
}

function __makeError.Sample2 {
    0..1 | ForEach-Object {
        Get-Item (1 / 0 ) '324' -fooop
    }
    Join-Path '.' 'someFakepath' | Get-Item -ea 'continue'
    (3525).Replace('adf', 'fdd')
}

# $error.clear()

__makeError.Sample1
$serr1 = $error | Get-Error -Verbose -Debug
$serr1.Count | Join-String -op 'err1: '

## type names maybe related or invlovled
[ValidateNotNull()][Hashtable]$Bag ??= @{}

$Bag.TypeName = @{}
$bag.TypeName.ToJsonSerialization = [System.Collections.ListDictionaryInternal]
$bag.TypeName.FromGetError = [System.Management.Automation.ErrorRecord]
