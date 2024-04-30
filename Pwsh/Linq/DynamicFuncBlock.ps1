using namespace System.Collections.Generic
using namespace System.Linq
using namespace System.Management.Automation

goto $PSScriptRoot -alwaysLsAfter


<#
#>
[Func[
   [string],
   [List[Object]]
]]

function Linq.CreateFunc2 {
    <#
    .SYNOPSIS
        Builds a new type: [Func[ Type1, Type2 ]]
    .notes
    outputs a type like
        [Func[
            [Type1],
            [Type2]
        ]]
    .EXAMPLE
        Linq.CreateFunc2 ( [String] ) ( [string] )
    #>
    [CmdletBinding()]
    [OutputType( [System.Func`2] )]
    [Alias('Linq.Func2')]
    [CmdletBinding()]
    param(
        [type]$Type1,
        [type]$Type2
    )
    $Type1, $Type2
        | Join-String -op 'using types: ' -sep ', ' -SingleQuote -p { $_.Name, $_.Namespace }
        | Write-Verbose

    # [Func
    # $t1 =
    # $fn = [Func`2].MakeGenericType($t1, [string])]
    $fn = [Func`2].MakeGenericType( $Type1, $Type2 )
    return $fn

}

function newFunc {
    param(
        [ArgumentCompletions(
            'PropName',
            'Static')]
        [string]$Template,

        [hashtable]$Params
    )
    switch($Template) {
        'PropName' {
            $whichProp = $Params.PropName
            [Func[object, string]]{
            param($p) return $p.$whichProp }
        }
        'Static' {
            [Func[object, string]]{
            param($p) return $p.Name }
        }
        default {
            throw "UnhandledTemplate: $Template"
        }
    }
}

function Fmt.ShortType {
    param(
        [Parameter(Mandatory, ValueFromPipeline)]
        $InputObjectOrType
    )
    process {
        $Obj = $InputObjectOrType
        if($Obj -is 'type'){
            $tinfo = $Obj
        } else {
            $tinfo = $Obj.GetType()
        }
        $tinfo | Join-string { $Obj -replace '\bSystem\.', ''}
        return
    }
}
$fn.a2.GetType() | Join-string { $_ -replace '\bSystem\.', ''}
$fn.a2.GetType() | Fmt.ShortType
$fn.a2 | Fmt.ShortType


function inspectFunc {
    [OutputType(
        'Hashtable', 'Object'
    )]
    param(
        $InputObject,

        # return object not hashtables
        [Alias('Psco', 'PassThru', 'AsObj', 'AsPSObject')][switch]$AsObject
    )
    $T = $InputObject
    $info = [ordered]@{
        LocalsCount = $t.Target.Locals.Count
        ConstantsCount = $t.Target.Constants.Count
        'Is Func²' = $t -is [Func`2]
    }

    # T.Method -is [Reflection.Emit.DynamicMethod]
    [Reflection.MethodInfo]$meth = $T.Method

    # T.Target -is [CompilerServices.Closure]
    [Runtime.CompilerServices.Closure]$Target = $T.Target

    # $info.Method = $Meth


    [Reflection.Emit.DynamicMethod]


    if( $AsObject ) { return [pscustomobject]$info }
    return $info
}

$fn = @{}
$file = fd -e ps1  | select -First 1 | gi

h1 'a1: StaticDefault'
$fn.a1 ??= newFunc Static
$fn.a1.Invoke( $file )

h1 'a2: -ByPropName FullName'
$fn.a2 = newFunc PropName -Params @{ PropName = 'FullName' }
$fn.a2.Invoke( $file )
hr
h1 'a1: Inspect'
InspectFunc $fn.a1
h1 'a2: Inspect'
inspectFunc $fn.a2 -AsObject | Ft -auto
hr
InspectFunc $fn.a2
