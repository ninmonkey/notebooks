#Requires -Version 7

# Tuple variations
## optionally see the discord thread for context: <https://discord.com/channels/180528040881815552/447476117629304853/1241476332861522052>
## and <https://discord.com/channels/180528040881815552/447476117629304853/1241927888966520862>


## [d] struct that autocompletes constructor params
Add-Type '
public record struct RecCompleter
{
    public string Foo { get; set; }
    public RecCompleter() { }
    public RecCompleter(string foo) => Foo = foo;
}' -IgnoreWarnings
[RecCompleter]$mp = @{ Foo = 23  }


## [a] Nested Tuples
'Using [a] using ValueTuple' | Write-warning
$tuple1 = @{
  [System.ValueTuple[string, string]]::new('1', '2') ="first";
  @{a="3";b="5"}="second"
}
$tuple1[[System.ValueTuple[string, string]]::new('1', '2')]

$tuple1 | ft -AutoSize
<# using [a]

    Name             Value
    ----             -----
    {[a, 3], [b, 5]} second
    (1, 2)           first
#>


<#

Pwsh> $tuple1 | ConvertTo-Json

    ConvertTo-Json: The type 'System.Collections.Hashtable' is not supported for serialization or deserialization of a dictionary. Keys must be strings.
#>

'Using [b] structs' | Write-warning
Add-Type -TypeDefinition 'public struct MyStruct5 { public string Foo; public string Bar; }'
[MyStruct5]$miss = @{
   Foo = 'foo'
   Bar = 1231
}
$miss | ft -AutoSize
<#
    Foo Bar
    --- ---
    foo 1231
#>

$miss | ConvertTo-Json

<#
    {
        "Foo": "foo",
        "Bar": "1231"
    }
#>


'Using [c] record struct' | Write-warning
## [b]
# $struct1 = @{
#   [MyStruct]::new('1', '2') ="first";
# }
# $struct1[[MyStruct]::new('1', '2')]

## [c]
Add-Type 'public record struct recStruct(string foo, string bar);'
[recStruct]$x = @{ foo = 190; bar = '99' }
$x | Json
<#
    {
    "foo": "190",
    "bar": "99"
    }
#>

$record1 = @{
  [MyRect]::new('1', '2') ="first";
}
$record1[[MyRect]::new('1', '2')]

$record1 | ft -AutoSize

<#
    Name                        Value
    ----                        -----
    MyRect { foo = 1, bar = 2 } first
#>
<#

$record1 | ConvertTo-Json

    Error: ConvertTo-Json: The type 'System.Collections.Hashtable' is not supported for serialization or deserialization of a dictionary. Keys must be strings.

#>
