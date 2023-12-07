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
function Render.Array {
    param( [string]$Name )
    process {
        $_ | Join-String -f "`n {0}" -op "$Name = [" -os "`n]"
    }
}
function ModVar.ListImport { process {
    $Mod = $_
    ,@($mod.ExportedVariables.Keys) | Render.Array 'Export Variablesname'
    ,@($mod.ExportedCommands.Keys)  | Render.Array 'Export Commands'
 } }
# test whether the location of 'Export-ModuleMember' has any affect
Module.OnLoad.BeforeExport
Export-ModuleMember -Function @('ModVar.*') -Variable @('ModVar_*')
Module.OnLoad.AfterExport

# 'ModVar_Exists', 'ModVar_Null', 'ModVar_OnLoad_AfterExport', 'ModVar_OnLoad_BeforeExport', 'ModVar_DidStuff'
#     | Join-String -sep "`n" -SingleQuote -op 'To Look For: [ ' -os "`n ]"

# [1] Import normally, check whether Before and After vars exported
