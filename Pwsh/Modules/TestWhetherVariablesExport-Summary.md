
This is a Summary of the Results of this test: [TestWhetherVariablesAreExported.psm1](./TestWhetherVariablesAreExported.psm1)

```ps1
$script:ModVar_Exists = @{ Name = 'alice' }
$script:ModVar_Null = $null

function Module.OnLoad {
    $script:ModVar_OnLoad = @{ name = 'bob' }
}
function DoStuff {
    $script:ModVar_DidStuff = @{ name = 'herbert' }
}
Module.OnLoad
 
Export-ModuleMember -Function @('ModVar.*') -Variable @('ModVar_*')
```

## What exports on Import? 

What exactly is exported if you were to [1] import, and then [2] call `DoStuff` to add a new variable ?
```ps1
# [1] State from the initial import
Import-Module ./TestWhetherVariablesAreExported.psm1 -Force -PassThru
Get-Variable

# [2] Test if new variables are exported? 
ModVar.DoStuff
Get-Variable
```
```ps1

```



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
```