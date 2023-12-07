$script:ModVar_Exists = @{ Name = 'alice' }
$script:ModVar_Null = $null

function Module.OnLoad.AfterExport {
    $script:ModVar_OnLoad_AfterExport = @{ name = 'kelly' }
}
function Module.OnLoad.BeforeExport {
    $script:ModVar_OnLoad_BeforeExport = @{ name = 'bob' }
}
function ModVar.DoStuff {
    $script:ModVar_DidStuff = @{ name = 'herbert' }
}
function ModVar.GetVar {
    param(
        [ArgumentCompletions('Script', 'Global', 0, 1, 2)]
        [string]$Scope )
    Get-Variable mod* | ft -AutoSize | write-host
}
# test whether the location of 'Export-ModuleMember' has any affect
Module.OnLoad.BeforeExport
Export-ModuleMember -Function @('ModVar.*') -Variable @('ModVar_*')
Module.OnLoad.AfterExport
