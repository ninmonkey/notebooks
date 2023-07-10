using namespace System.Management
using namespace System.Management.Automation
using namespace System.Collections.Generic
# 2023-07-09
goto $PSScriptRoot
# function TrueEmptyAsFunction {}
Remove-Item 'function:\TrueEmptyAsFunction' -ea 'ignore'
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
$Sample.EmptyNoOutputMany = { $x = 10; $z = 30; }
$Sample.NoOutputWithPipeline = { 0..10 | Out-Null }
$Sample.EmptyOutput = { $x = 0 }
$Sample.FromStringCoerce_TrueEmpty = '{}'
$Sample.FromStringCoerce_TrueEmptyString = '{ [string]::StringEmpty }'
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
        [Parameter(ParameterSetName = 'AsScriptBlock')]
        [ScriptBlock]$InputScriptBlock,

        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [Alias('Function')]
        [Parameter(ParameterSetName = 'AsFunctionInfo')]
        [FunctionInfo]$InputFunctionInfo
    )
    function __inspect.ScriptBlock {
        [CmdletBinding()]
        param(
            [ValidateNotNullOrEmpty()]
            [ValidateNotNull()]
            [Parameter(Mandatory, Position = 0)]
            [object]$InputObject
        )
        $Info = [ordered]@{
            PSTypeName   = 'ninfo.Inspect.ScriptBlock'
            FullTypeName = $InputObject.GetType().FullName
            Is           = [pscustomobject][ordered]@{
                TrueNull          = $null -eq $InputScriptBlock
                StringNullOrEmpty = [string]::IsNullOrEmpty( $InputScriptBlock )
            }
        }

        return [PSCustomObject]$Info
    }
    function __inspect.FunctionInfo {
        [CmdletBinding()]
        param(
            [ValidateNotNullOrEmpty()]
            [ValidateNotNull()]
            [Parameter(Mandatory, Position = 0)]
            [object]$InputObject
        )
        $info = [ordered]@{
            PSTypeName   = 'ninfo.Inspect.FunctionInfo'
            FullTypeName = $InputObject.GetType().FullName
            Is           = [pscustomobject][ordered]@{
                TrueNull          = $null -eq $InputFunctionInfo
                StringNullOrEmpty = [string]::IsNullOrEmpty( $InputScriptBlock )
            }
        }
        return [PSCustomObject]$info
    }

    switch ($PSCmdlet.ParameterSetName) {
        'AsFunctionInfo' {
            Write-Verbose '=> __inspect.FunctionInfo'
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
[List[Object]]$summary = @(
    InspectScriptBlock -InputScriptBlock $Sb
    InspectScriptBlock -InputScriptBlock $sample.EmptyString
    InspectScriptBlock -InputScriptBlock $sample.EmptyStringLiteral
 )
 Hr
 $Summary | s -prop Name -ExpandProperty Is -ea 0
 Hr
 $Summary

hr -fg magenta
write-warning 'Early Exit!!!'
return


$Sample.GetEnumerator() | % {
    # $results = InspectScriptBlock -InputScriptBlock $_.Value
    $results = InspectScriptBlock -InputObject $_.Value -ea 'break' #FunctionInfo $_.Value
    $query = [PSCustomObject]@{
        PSTypeName = 'ninfo.Inspection.Pairs'
        Name       = $_.Key
        Inspection = $results ?? "`u{2400}"
    }
    $Info.Add( $query )
}
return
# function Dotils.Invoke-TipOfTheDay  {
Import-Module Dotils -Force -verb -PassThru #*>$Null
