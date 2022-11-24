err -clear
Import-Module PipeScript *>$Null

$name = $Me




function doItMini {
    [Alias('doItMini.1')]
    param( $Obj )
    $script:Depth++
    # [void]$strb.AppendFormat('.{0}', @($depth, ($obj.Name ?? '␀') ))
    # $Obj ?? '␀'| select Name, ProcessName, Path | join-string -sep ', '

    .> {
        .Name = $Obj.
    }
        # .name = $name .parent = $name.parent .pid = $name.Id .child = 'wip' } )

    $Obj ?? '␀' | Select-Object Name, ProcessName, Path
    # $depth
}

$Cfg ??= @{
    DoItMini   = $true
    DoIt_iter2 = $false
    DoIt_iter1 = $true
    DoIt_iter0 = $false
}

return
if ($Cfg.DoItMini) {
    doItMini (Get-Process -Id $Pid)
    $me = (Get-Process -Id $Pid)
    doItMini $me
    doItMini $me.Parent
    doItMini $me.Parent.Parent
    doItMini $me.Parent.Parent.parent
    doItMini $me.Parent.Parent.parent.parent
    $strb.ToString()

}
if ($Cfg.DoIt_iter0) {
    doIt.0 (Get-Process -Id $Pid)

    . ( .>Pipescript { .name = $name .parent = $name.parent .pid = $name.Id .child = 'wip' } )
}
if ($Cfg.DoIt_iter1) {
    doIt.1 (Get-Process -Id $Pid)
}

if ($Cfg.DoIt_iter2) {
    $script:depth = 0
    $Strb = [Text.StringBuilder]::new('Path = ')

    function doItMini.0 {
        [Alias('doItMini.0')]
        param( $Obj )
        $script:Depth++
        [void]$strb.AppendFormat('.{0}', @($depth, ($obj.Name ?? '␀') ))
        # $Obj ?? '␀'| select Name, ProcessName, Path | join-string -sep ', '
        $Obj ?? '␀' | Select-Object Name, ProcessName, Path
        # $depth
    }
}