Import-Module Pansies
function OutHost {
    #
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, ValueFromPipeline)]
        $InputObject ,

        [AllowNull()]
        [ArgumentCompletions('Orange', 'Blue', 'Gray30', 'Gray50', 'Gray70')]
        [Parameter(Position = 0)]
        [string]$Fg, #= $null,
        # [string]$Fg = "${fg:gray80}", # #c97b52

        [ArgumentCompletions('Orange', 'Blue', 'Gray30', 'Gray50', 'Gray70')]
        [Parameter(Position = 0)]
        [string]$Bg = '#25727b'
    )
    process {
        $Fg ??= 'orange' # will never occur
        $Fg = 'orange'
        if (-not $Fg) {
            $fg = 'orange'
        }
        $Bg ??= 'white' # will never occur
        # $Bg = 'white'
        # if (-not $Bg) {
        #     $Bg = 'white'
        # }
        # $null -eq $fg
        # $bg = "${fg:25727b}"
        $InputObject
        # | New-Text -fg $Fg
        | New-Text -fg $Fg -bg $Bg
        | Join-String -os $PSStyle.Reset
    }
}

# 'fg and bg  ' | OutHost -fg gray80 -bg '25727b'
'fg and bg  ' | OutHost -bg '#25727b'
'fg and bg  ' | OutHost -bg 'blue'
# return
'neither    ' | OutHost -fg $null -bg $null
'fg and bg  ' | OutHost -fg gray80 -bg '25727b'
'neither    ' | OutHost -fg '' -bg ''

# 'fg and none' | OutHost -fg gray80
