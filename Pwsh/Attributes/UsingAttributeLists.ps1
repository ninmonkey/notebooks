using namespace System
using namespace System.Collections.Generic
using namespace System.Reflection
using namespace System.Management
using namespace System.Management.Automation

err -Clear
Get-Module Picky -all | Remove-Module
# import-module Picky -force -PassThru
goto $PSScriptRoot
$modPath = 'H:\data\2023\pwsh\PsModules\Picky\Picky\Picky.psm1'
import-module $ModPath -force -PassThru -Verbose

@'
## Summary:

- for mandatory parameters:
  - are *always* positional
  - are c-tor arguments

- for optional positional parameters:
  - add a parameterless c-tor
  - or a c-tor overload that omits the parameter to be optional

- for optional named parameters:
  - implemented as properties not in a c-tor

## see more

- [Creating Custom Attributes](https://powershell.one/powershell-internals/attributes/custom-attributes#a-better-autolearn-attribute)
- [Retrieving Information Stored in Attributes](https://learn.microsoft.com/en-us/dotnet/standard/attributes/retrieving-information-stored-in-attributes)
- [Accessing Custom Attributes](https://learn.microsoft.com/en-us/dotnet/framework/reflection-and-codedom/accessing-custom-attributes)
- [How to: Get type and member information by using reflection](https://learn.microsoft.com/en-us/dotnet/framework/reflection-and-codedom/get-type-member-information)

'@ | Write-Host -fore 'green'
class AuthorAttribute : Attribute {
    [List[string]]$Authors = @()
    AuthorAttribute( [string[]]$Authors ) {
        $this.Authors = $Authors
    }
    AuthorAttribute() {}

}
function DoWork {
    [AuthorAttribute(Authors = ('cat', 'monkey', '🐒'))]
    param(
        [string]$Text
    )
    'Did stuff'
}


DoWork
h1 '.ResolveParameter(Te)'
(gcm 'DoWork').ResolveParameter('Te')

h1 '.ResolveParameter(Text).Attributes'
(gcm 'DoWork').ResolveParameter('Text').Attributes

h1 '.ScriptBlock.Attributes'
[List[Attribute]]$Attrs = (gcm 'DoWork').ScriptBlock.Attributes
$authorAttr = $Attrs[0]
$authorAttr

$target = gcm 'DoWork'

# other routes
# gcm 'Dowork' | Function.GetInfo Attributes
# gcm 'Dowork' | Function.GetInfo ScriptBlock | ScriptBlock.GetInfo Attributes
