using namespace System
using namespace System.Collections.Generic
using namespace System.Reflection
using namespace System.Management
using namespace System.Management.Automation

@'
# see more

- [Creating Custom Attributes](https://powershell.one/powershell-internals/attributes/custom-attributes#a-better-autolearn-attribute)
- [Retrieving Information Stored in Attributes](https://learn.microsoft.com/en-us/dotnet/standard/attributes/retrieving-information-stored-in-attributes)

## Summary:

- for mandatory parameters:
  - are *always* positional
  - are c-tor arguments

- for optional positional parameters:
  - add a parameterless c-tor
  - or a c-tor overload that omits the parameter to be optional

- for optional named parameters:
  - implemented as properties not in a c-tor

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
h1 '.ResolveParameter(Text)'
(gcm DoWork).ResolveParameter('Text')

h1 '.ResolveParameter(Text).Attributes'
(gcm DoWork).ResolveParameter('Text').Attributes

h1 '.ScriptBlock.Attributes'
[List[Attribute]]$Attrs = (gcm DoWork).ScriptBlock.Attributes
$authorAttr = $Attrs[0]

<#

    param(
        # object input

        # should empty lists and null values spam the user with binding errors?
        # if not, use these attributes
        [AllowEmptyCollection()]
        [AllowEmptyString()]
        [AllowNull()]
        [object[]]
        $InputObject,

        # something to test positional binding without the parameter name
        [Parameter( ParameterSetName='FromPipe',  Position = 0 )]
        [Parameter( ParameterSetName='FromParam', Position = 1 )]
        [ArgumentCompletions('Stuff')]
        [string]$Label

    )
    #>
function ScriptBlock.GetInfo {
    <#
    .SYNOPSIS
        Quickly and easily grab properties and metadata for [ScriptBlock] types
    .EXAMPLE
        # use auto completion
        Pwsh> gcm 'DoWork'
            | Function.GetInfo ScriptBlock
            | ScriptBlock.GetInfo File
    .LINK
        Picky\Function.GetInfo
    .LINK
        Picky\ScriptBlock.GetInfo
    .notes
        future info
        - [ ] other scriptblock/function types

        - [ ] DefaultParameterSet
        - [ ] (Jsonify) => Id, Ast, Module, Etc...
    #>
    [OutputType(
        'PSModuleInfo'

    )]
    [CmdletBinding(DefaultParameterSetName='FromPipe')]
    param(
        [Parameter( Mandatory, ParameterSetName='FromPipe',  ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [Parameter( Mandatory, ParameterSetName='FromParam', Position = 0 )]
        [Alias('Name', 'Func', 'Fn', 'Command', 'InObj', 'Obj', 'ScriptBlock', 'SB', 'E', 'Expression')]
        [object]$InputObject,

        [Parameter( ParameterSetName='FromPipe',  Position = 0 )]
        [Parameter( ParameterSetName='FromParam', Position = 1 )]
        [Parameter(Mandatory)]
        [ValidateSet(
            'Attributes',
            'File',
            'Module',
            'StartPosition',
            'Id',
            'Ast'
        )]
        [string]$OutputKind
    )
    # future: assert properties exist
    process {
        if( $InputObject -isnot [ScriptBlock] ) {
            'Expected A <ScriptBlock | ... >. Actual: {0}' -f @(
                $InputObject.GetType().Name
            )
            | Dotils.Write-DimText | Infa
                # | write-warning
        }
        'InputType: {0}, Expected <ScriptBlock>' -f @(
            $InputObject.GetType().Name
        ) | write-verbose

        # if( -not $InputObject -isnot 'F')
        if($Null -eq $InputObject) { return }
        switch( $OutputKind ) {
            'Attributes' {
                # -is [List[Attribute]]
                $result  = $Input.Attributes
                break
            }
            'File' {
                # -is [string]
                $result  = $Input.File
                break
            }
            'Module' {
                # is [PSModuleInfo]
                $result  = $input.Module
                break
            }
            'StartPosition' {
                # -is [PSToken]
                $result  = $InputObject.StartPosition
                break
            }
            'Id' {
                # -is [Guid]
                $result  = $InputObject.Id
                break
            }
            'Ast' {
                # -is [Ast>]
                $result  = $InputObject.Ast
                break
            }
            default { throw "Unhandled OutputKind: $OutputKind" }
        }


        $isBlank = [string]::IsNullOrWhiteSpace( $result )
        if($isBlank -and $InputObject) {
            'Object exists but the attribute is blank'
                | Dotils.Write-DimText | Infa
        }
        return $result

    }
}
function Function.GetInfo {
    <#
    .SYNOPSIS
        Quickly and easily grab properties and metadata for [CommandInfo], [FunctionInfo] etc
    .EXAMPLE
        # use auto completion
        Pwsh> gcm 'DoWork' | Function.GetInfo Parameters
    .LINK
        Picky\Function.GetInfo
    .LINK
        Picky\ScriptBlock.GetInfo
    .notes
        future info
        - [ ] ParameterMetadata ResolveParameter(string name);
        - [ ] DefaultParameterSet
        - [ ] ScriptBlock
        - [ ] CommandType

        - [ ] (Jsonify) => Options, Description, Noun, Verb, Name, ModuleName, Source, Version
    #>
    [OutputType(
        'ScriptBlock',
        'PSModuleInfo',
        '[IDictionary[string, [System.Management.Automation.ParameterMetadata]]]',
        '[Collections.ObjectModel.ReadOnlyCollection[Management.Automation.CommandParameterSetInfo]]'

    )]
    [CmdletBinding(DefaultParameterSetName='FromPipe')]
    param(
        [Parameter( Mandatory, ParameterSetName='FromPipe',  ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [Parameter( Mandatory, ParameterSetName='FromParam', Position = 0 )]
        [Alias('Name', 'Func', 'Fn', 'Command', 'InObj', 'Obj', 'ScriptBlock', 'SB')]
        [object]$InputObject,

        [Parameter( ParameterSetName='FromPipe',  Position = 0 )]
        [Parameter( ParameterSetName='FromParam', Position = 1 )]
        [Parameter(Mandatory)]
        [ValidateSet(
            'Attributes',
            'ScriptBlock',
            'Module',
            'Parameters',
            'ParameterSets'
        )]
        [string]$OutputKind
    )
    # future: assert properties exist
    process {
        if( $InputObject -isnot [CommandInfo] -and $InputObject -isnot [FunctionInfo]) {
            'Expected A <CommandInfo | FunctionInfo>. Actual: {0}' -f @(
                $InputObject.GetType().Name
            )
            | Dotils.Write-DimText | Infa
                # | write-warning
        }
        'InputType: {0}, Expected <CommandInfo|FunctionInfo>' -f @(
            $InputObject.GetType().Name
        ) | write-verbose

        # if( -not $InputObject -isnot 'F')
        if($Null -eq $InputObject) { return }
        switch( $OutputKind ) {
            'Attributes' {
                $result  = $Input.ScriptBlock.Attributes
                break
            }
            'ScriptBlock' {
                # -is [ScriptBlock]
                $result  = $Input.ScriptBlock
                break
            }
            'Module' {
                # is [PSModuleInfo]
                $result  = $input.Module
                break
            }
            'Parameters' {
                # -is [Dictionary<string, ParameterMetadata>]]
                $result  = $InputObject.Parameters
                break
            }
            'ParameterSets' {
                # -is [ReadOnlyCollection<CommandParameterSetInfo>]
                $result  = $InputObject.ParameterSets
                break
            }
            default { throw "Unhandled OutputKind: $OutputKind" }
        }


        $isBlank = [string]::IsNullOrWhiteSpace( $result )
        if($isBlank -and $InputObject) {
            'Object exists but the attribute is blank'
                | Dotils.Write-DimText | Infa
        }
        return $result

    }
}
$target = gcm 'DoWork'
Function.GetInfo -Fn $Target -Out Attributes
