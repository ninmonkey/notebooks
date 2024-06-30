$script:VarTest_Null = $Null
$Config = @{
    DeclareExplicitNull = $false
    ExportBeforeInit    = $true
}
if( $Config.DeclareExplicitNull) {
    $script:VarTest_None = $null
}

function ModuleInit {
    'running: ModuleInit' | write-verbose -verbose
    $script:VarTest_Null = 'hiworld'
    $script:VarTest_None = 'stuff'
}

# $script:VarTest_None = $Null
if($Config.ExportBeforeInit) {
    Export-ModuleMember -Variable @( 'VarTest_*')
    ModuleInit
} else {
    ModuleInit
    Export-ModuleMember -Variable @( 'VarTest_*')
}

# for either init order, VarTest_None == 'stuff' in module scope
# but can be missing in the user scope (so the value itself isn't null)
Get-Variable 'VarTest*' -scope Script | Ft -auto
    | oss
    | Write-verbose -verbose

$Config | Ft -auto | out-string | write-host
@'
Example usage:
    > ipmo './ExportVarTest.psm1' -PassThru -Force
    > Get-Variable 'VarTest*' -scope global | ft -auto

    >  $VarTest_Null, $VarTest_None' | write-warning
'@ | write-warning
