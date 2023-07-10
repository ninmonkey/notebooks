using namespace System.Management
using namespace System.Management.Automation
using namespace System.Collections.Generic
# 2023-07-09

# function TrueEmptyAsFunction {}
remove-item 'function:\TrueEmptyAsFunction' -ea 'ignore'
New-Item 'function:\TrueEmptyAsFunction' -Value {} #-ea 'continue'
# New-Item 'function:\TrueEmptyAsFunction2' -Value TrueEmptyAsFunction


[List[Object]]$Summary = @()

$Sample = @{}
$Sample.TrueEmpty = {}
# $Sample.TrueEmptyCtor = [ScriptBlock]::new()
# $Sample.NewEmptyLiteral = [ScriptBlock]::new()
$Sample.EmptyString = { [string]::StringEmpty }
$Sample.EmptyStringLiteral = { '' }
$Sample.NullLiteral = { $null }
$Sample.EmptyOutput = { $x = 0  }
$Sample.TrueEmptyAsFunction = Get-Item 'function:\TrueEmptyAsFunction'

function InspectScriptBlock {
    <#
    .SYNOPSIS
        inspect different kinds of empty,
    #>
    [CmdletBinding()]
    param(
        # do I want to allow empty?
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [Alias('SB', 'Expression', 'ScriptBlock')]
        [Parameter(ParameterSetName='AsScriptBlock')]
        [ScriptBlock]$InputScriptBlock,

        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [Alias('Function')]
        [Parameter(ParameterSetName='AsFunctionInfo')]
        [FunctionInfo]$InputFunctionInfo
    )
    function __inspect.ScriptBlock {

        return [PSCustomObject]@{
            PSTypeName = 'ninfo.Inspect.ScriptBlock'
            Is = @{
                TrueNull = $null -eq $InputScriptBlock
                StringNullOrEmpty = [string]::IsNullOrEmpty( $InputScriptBlock )
            }
        }
    }
    function __inspect.FunctionInfo {
        return [PSCustomObject]@{
            PSTypeName = 'ninfo.Inspect.FunctionInfo'
            Is = @{
                TrueNull = $null -eq $InputFunctionInfo
                StringNullOrEmpty = [string]::IsNullOrEmpty( $InputScriptBlock )
            }
        }
    }

    switch($PSCmdlet.ParameterSetName){
        'AsFunctionInfo' {
            write-verbose '=> __inspect.FunctionInfo'
            $info = __inspect.FunctionInfo -inputObject $InputFunctionInfo
            break
        }
        'AsScriptBlock' {
            write-verbose '=> __inspect.ScriptBlock'
            $info = __inspect.ScriptBlock -inputObject $InputScriptBlock
            break
        }
        default { throw "Unexpected ParameterSetName: '$($PSCmdlet.ParameterSetName)'" }
    }
    return $Info

}

$sb = $Sample.TrueEmpty
$Sample.GetEnumerator() | %{
    $results = InspectScriptBlock -InputScriptBlock $_.Value
    $query = [PSCustomObject]@{
        PSTypeName = 'ninfo.Inspection.Pairs'
        Name = $_.Key
        Inspection = $results ?? "`u{2400}"
    }
    $Info.Add( $query )
}
return
# function Dotils.Invoke-TipOfTheDay  {
import-module Dotils -force -verb -PassThru #*>$Null
