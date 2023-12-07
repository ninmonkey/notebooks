@"
About:
    > This tests whether "module"-scope variables are exported if they don't exist until after the module import occurs
"@
function Msg {
    [Alias('Blue', 'Green', 'Red')]
    param()
    process {
    $_ | Join-String -f "`n ▸ {0}" | Write-Host -fg '#577859'
} }
$script:ModVar_AlwaysExists = @{ id = 0 }
$script:ModVar_AlwaysNull_free = $null
function ModVar.GetVar {
    param( [string]$Scope )
    # Get-Variable 'ModVar*' -Scope Script
    $splat = @{
        Name = 'ModVar*'
    }
    # hr -fg 'orange'
    # h1 '=> modvar'
    if($Scope) { $Splat.Scope = $Scope }
    $query = Get-Variable @splat
    $query | %{
        $_.Name | Msg
        $_.Value | ConvertTo-Json -depth 4 | Join-String -sep "`n" | Msg
    }

    (Get-Variable 'ModVar*').count | Join-string -op 'Found N modVars: '  | Msg
}

function Module.OnLoad {
    ' ==> Module.Init' | Msg
    $ref = $script:ModVar_AlwaysExists
    $ref.Name = 'Alice'
    $ref.StartTime = [Datetime]::Now
    $script:ModVarInit = @{ id = 3999 }
}
function ModVar.DoStuff {
    '=> enter ' | Msg
    ModVar.GetVar -Scope script
    ModVar.GetVar -Scope global

    $ref = $script:ModVar_AlwaysExists
    $ref.StuffTime = [Datetime]::now

    $script:ModVar_DidStuff = @{ id = 100 }

    '=> exit ' | Msg
    ModVar.GetVar -Scope script
    ModVar.GetVar -Scope global
}


'=> before Init' | Msg
ModVar.GetVar -Scope Script
ModVar.GetVar -Scope global

Module.OnLoad

'=> after Init' | Msg
ModVar.GetVar -Scope Script
ModVar.GetVar -Scope global




Export-ModuleMember -Function @('ModVar.*') -Variable @('ModVar*') -Alias @('ModVar.*')
@'
Try:
    > Get-Command ModVar.* | Ft -auto
    > Get-Variable 'ModVar*'
'@
Gcm 'ModVar.*' | ft -auto | out-string

(Get-Variable 'ModVar*').count | Join-string -op 'Found N modVars: '
