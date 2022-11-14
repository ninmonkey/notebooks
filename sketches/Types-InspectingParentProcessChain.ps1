$Cfg ??= @{
    DoItMini = $true
    DoIt_iter1= $true
    DoIt_iter0 = $false
}

if($Cfg.DoItMini) {
    doItMini (ps -id $Pid)
    $me = (Get-Process -Id $Pid)
    doItMini $me
    doItMini $me.Parent
    doItMini $me.Parent.Parent
    doItMini $me.Parent.Parent.parent
    doItMini $me.Parent.Parent.parent.parent
    $strb.ToString()

}
if($Cfg.DoIt_iter0) {
    doIt.0 (ps -id $Pid)
}
if($Cfg.DoIt_iter1) {
    doIt.1 (ps -id $Pid)
}
$name = $Me
. ( .>Pipescript { .name = $name .parent = $name.parent .pid = $name.Id } )
$script:depth = 0
$Strb = [Text.StringBuilder]::new('Path = ')
function doItMini {
    param( $Obj )
    $script:Depth++
    [void]$strb.AppendFormat('.{0}', @($depth, ($obj.Name ?? '␀') ))
    # $Obj ?? '␀'| select Name, ProcessName, Path | join-string -sep ', '
    $Obj ?? '␀'| select Name, ProcessName, Path
    # $depth
}

return
function digIt {
    <#
    .INPUTS
        system.Diagnostics.Process
    #>
    [CmdletBinding()]
    [Alias('doIt.1')] # for quick dumps, essentially pinning dependencies
    param(
        #  some process to check out
        [Parameter(ValueFromPipeline, mandatory)]
        [Diagnostics.Process]$InputObject,

        [int]$Depth = 0
    )
    process {
        # yes, this is written in a silly way

        $cur_ps = $InputObject
        class didItResult {
            [string]$Name
            [string]$ProcessName
            [string]$Path

        }
        try {
            while ($null -ne ($name = $current.parent) ) {
                $msg = '{3}{0,-3}: {1} is {2}' -f @(
                    $name
                    $name.GetType().Name
                    ' ' * $depth++ -join ' '
                    try {
                        digIt $InputObject -Depth $Depth
                    } catch {
                        "Overflow at '$Depth'"
                        break
                    }
                )
                $msg
                $null = 0
            }

        } catch {
            "Done: '$Depth'"
        }
    }
}
function digIt.0 {
    <#
    .INPUTS
        system.Diagnostics.Process
    #>
    param(
        #  some process to check out
        [Parameter(ValueFromPipeline, mandatory)]
        [Diagnostics.Process]$InputObject,

        [int]$Depth = 0
    )
    process {
        # yes, this is written in a silly way
        $current = $InputObject
        try {
            while ( ($name = $current.parent) ) {
                $msg = '{3}{0,-3}: {1} is {2}' -f @(
                    $name
                    $name.GetType().Name
                    ' ' * $depth++ -join ' '
                    try {
                        digIt $InputObject -Depth $Depth
                    } catch {
                        "Overflow at '$Depth'"
                        break
                    }
                )
                $msg
                $null = 0
            }

        } catch {
            "Done: '$Depth'"
        }
    }
}

return

# digIt (Get-Process -Id $Pid)


$me = (Get-Process -Id $Pid)
$me | select Name, ProcessName, Path
$me.parent | select Name, ProcessName, Path
$me.parent.parent | select Name, ProcessName, Path
$me.parent.parent.parent ?? '␀' | select Name, ProcessName, Path
$me
