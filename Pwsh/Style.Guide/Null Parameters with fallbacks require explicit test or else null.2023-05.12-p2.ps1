Import-Module Pansies -ea 'stop'
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

        [AllowNull()]
        [ArgumentCompletions('Orange', 'Blue', 'Gray30', 'Gray50', 'Gray70')]
        [Parameter(Position = 0)]
        [string]$Bg = '#25727b',

        [Alias('Strict')]
        [switch]$TreatBlanksAsNull = $false
    )
    process {
        $Fg ??= 'yellow' # will never occur
        $Fg = 'orange'
        if ($TreatBlanksAsNull -and -not $Fg) {
            $fg = 'orange'
        }
        $Bg ??= 'magenta' # will never occur
        if ($TreatBlanksAsNull -and -not $Bg) {
            $Bg = 'white'
        }

        $InputObject
        | New-Text -fg $Fg -bg $Bg
        | Join-String -os $PSStyle.Reset
    }
}

@'
to simplfy the example code above, this uses switch defaulting to on
set to false to see the null related errors

Undefined parameter $Fg is not null, so coalesce never assigns it

Pansies\New-Text -Fg and Bg params are of data type:
    [PoshCode.Pansies.RgbColor]

which normally will:

    empty string: Throws an exception

    $null value: Silently Coerce to $null

$x = $null
$x ??= 'red'
$y = ''
$y ??= 'yellow'

'hi' | New-Text -fg $x -bg $y
| Join-String
because it passes empty strings to




'@


$PSDefaultParameterValues['OutHost:TreatBlanksAsNull'] = $true
# 'fg and bg  ' | OutHost -fg gray80 -bg '25727b'
'fg and bg  ' | OutHost -bg '#25727b'
'fg and bg  ' | OutHost -bg 'blue'
# return
'neither    ' | OutHost -fg $null -bg $null
'fg and bg  ' | OutHost -fg gray80 -bg '25727b'
'neither    ' | OutHost -fg '' -bg ''
'neither    ' | OutHost -fg '' -bg $null
'neither    ' | OutHost -fg $null -bg $null


function microtest {
    # simplificaiton of the above
    $x = $null
    $x ??= 'red'
    $y = ''
    $y ??= 'yellow'

    'hi' | New-Text -fg $x -bg $y
    | Join-String
}
<#
output:

Pwsh> microtest

    'hi' | New-Text -fg $x -bg $y
                                ~~
    Cannot bind parameter 'BackgroundColor'. Cannot convert
    value "" to type "PoshCode.Pansies.RgbColor". Error: "Color
    value can't be an empty string."

#>