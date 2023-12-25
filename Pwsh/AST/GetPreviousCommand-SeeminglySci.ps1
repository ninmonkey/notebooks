using namespace System.Management.Automation.Language

function GetPreviousCommand {
    <#
    .SYNOPSIS
        original version: <https://gist.github.com/SeeminglyScience/4d0d63ab56b4f121b98652e831af7219>
        [Discord context](https://discord.com/channels/180528040881815552/447476117629304853/1145817962884899019)
    #>
    param( [Management.Automation.InvocationInfo] $InvocationInfo)

    $InvocationInfo = $InvocationInfo
    $property = $InvocationInfo.
        GetType().
        GetProperty( 'ScriptPosition',
            [Reflection.BindingFlags]::NonPublic -bor 'Public, Instance')

    [IScriptExtent] $extent = $property.GetValue($InvocationInfo)
    $containingDocument = [Parser]::ParseInput(
        $extent.StartScriptPosition.GetFullScript(),
        $extent.File,
        [ref] $null,
        [ref] $null)

    [CommandAst] $foundAst = $containingDocument.Find(
        {
            param([Ast] $Ast)
            end {
                if ($Ast -isnot [CommandAst]) { return $false }

                if ( $Ast.Extent.StartOffset -ne
                         $extent.StartOffset -or
                       $Ast.Extent.EndOffset -ne $extent.EndOffset ) {
                    return $false
                }
                return $true
            }
        },
        $true)

    if ($null -eq $foundAst) {
        throw 'Could not find matching AST'
    }

    $pipelineElements = $foundAst.Parent.PipelineElements
    for ($i = 0; $i -lt $pipelineElements.Count; $i++) {
        if ($pipelineElements[$i] -eq $foundAst) {
            break
        }
    }

    if ($i -eq $pipelineElements.Count) {
        throw 'Cannot tell where the command is in the parent pipeline AST'
    }

    if ($i -eq 0) {
        throw 'This command cannot be the first pipeline element'
    }

    return $pipelineElements[$i - 1]
}


function WriteInlineLables {
    [Alias('L', '㏒', '┟')]
    [CmdletBinding()]
    param(
        [parameter(Mandatory, Position=0, ValueFromRemainingArguments)]
        [string]$Name,

        [AllowNull()][Parameter(ValueFromPipeline)]$InputObject,
        $Separator = ' '
    )
    process {
        if($null -eq $InputObject -and $Config.SkipTrueNull ) { return }
        $InputObject | Write-ConsoleLabel $Name  -Separator $Separator
    }
}

$t = 'hi world'
$t.count                | ㏒ t.count
$t | %{ $_.count }      | ㏒ '%{ $_.count }'
$t | % count            | ㏒ '% count'

$MyInvocation.MyCommand.ScriptBlock.Ast

GetPreviousCommand -InvocationInfo $MyInvocation
# GetPreviousCommand -InvocationInfo $MyInvocation.MyCommand.ScriptBlock.Ast
