$src = @'
Import-Module DbaTools -passthru
$splatExport = @{
    # comment

}
Export-DbaLogin @splatExport
'@

$Tokens = $null
$AstErrors = $Null
$Doc = [Parser]::ParseInput(
        <# input   : #> $src,
        <# tokens  : #> [ref] $tokens,
        <# errors  : #> [ref] $AstErrors )

$find_splats =
    $doc.FindAll( {
        param( $Inp )
            return $Inp -is [VariableExpressionAst] -and
                $Inp.Splatted
        }, $true )

$find_splats | Ft

<#
outputs:

VariablePath Splatted StaticType    Extent       Parent
------------ -------- ----------    ------       ------
splatExport      True System.Object @splatExport Export-DbaLogin @splatExport
#>
