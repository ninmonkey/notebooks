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

- [about_format_ps1xml](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_format.ps1xml?view=powershell-7.3)
- [Format-ExportData](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/export-formatdata?view=powershell-7.3)
- Implementation:
    - [Get-Error Implementation](https://github.com/PowerShell/PowerShell/blob/master/src/Microsoft.PowerShell.Commands.Utility/commands/utility/Get-Error.cs)
    - [Get-Error unit tests](https://github.com/PowerShell/PowerShell/blob/master/test/powershell/Modules/Microsoft.PowerShell.Utility/Get-Error.Tests.ps1)
    -


It's declared as returning / involving:

## Short names

    - [Exception]
    - [Exception#PSExtendedError]
    - [sma.ErrorRecord]
    - [sma.ErrorRecord#PSExtendedError]


## Same as full names

    - [System.Exception]
    - [System.Exception#PSExtendedError]
    - [System.Management.Automation.ErrorRecord]
    - [System.Management.Automation.ErrorRecord#PSExtendedError]

## Interal cs

    internal const string ErrorRecordPSExtendedError = "System.Management.Automation.ErrorRecord#PSExtendedError";
    internal const string ExceptionPSExtendedError = "System.Exception#PSExtendedError";
    https://learn.microsoft.com/en-us/dotnet/api/system.management.automation.extendedtypedefinition?view=powershellsdk-7.2.0

'@

$Bag.TypeName = @{}
$bag.TypeName.ToJsonSerialization = [System.Collections.ListDictionaryInternal]
[Collections.Generic.List[Object]]$bag.TypeName.FromGetError = @(
    'System.Exception'
    'System.Exception#PSExtendedError'
    'System.Management.Automation.ErrorRecord'
    'System.Management.Automation.ErrorRecord#PSExtendedError'
)


Push-Location $PSScriptRoot
function WroteFile.Message {
    # $Path
    $Input | Get-Item -ea 'ignore' | Join-String -f 'Wrote: <file:///{0}>'
}

function __Collect.ErrorFormatData {
    $Path = './export\FormatData.ErrorRecord.json'

    Get-FormatData -TypeName ([System.Management.Automation.ErrorRecord])
    | ConvertTo-Json -Depth 99 | Set-Content $Path

    $Path | WroteFile.Message

    Get-FormatData -TypeName $bag.TypeName.FromGetError

    $gfd = Get-FormatData -TypeName $bag.TypeName.FromGetError
    # $gfd_one.FormatViewDefinition | fl | iot2
    $gfd_one.FormatViewDefinition | io -SortBy Reported | Format-Table Reported, Type, Name, Value
}

__Collect.ErrorFormatData

function __Export.ErrorFormatData {
    # 'System.Exception'
    # 'System.Exception#PSExtendedError'
    # 'System.Management.Automation.ErrorRecord'
    # 'System.Management.Automation.ErrorRecord#PSExtendedError'
    $bag.TypeName.FromGetError | ForEach-Object {
        $curTypeName = $_
        '::Export FormatData: {0}' -f $curTypeName | Write-Host

        $shortName = $curTypeName
        $shortName = $shortName -replace ([Regex]::Escape('System.Management.Automation.')), ''
        $shortName = $shortName -replace ([Regex]::Escape('System.')), ''
        $shortName = $shortName -replace ([Regex]::escape('#')), '_'
        '   => shortName: {0}' -f $shortName | Write-Host

        $Path = Join-Path './export' "${shortName}.ps1xml"
        Get-FormatData -TypeName $curTypeName -PowerShellVersion 7.3
        | Export-FormatData -Path $Path -Verbose -IncludeScriptBlock

        $Path | WroteFile.Message
    }
}

__Export.ErrorFormatData

Write-Warning 'early exit... collect types'
return

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

