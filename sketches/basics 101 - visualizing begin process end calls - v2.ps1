function doStuff2 {
    <#
    support
        A | func B
        func A B
    #>
    [CmdletBinding()]
    param(
        # [Parameter(ValueFromPipeline, Mandatory, Position = 0)]
        [Parameter(Mandatory)]
        [object[]]$InputObject,

        [string]$LabelColor # just so theres some 2nd param
    )
    begin {
        '==>'
        $LabelColor = $LabelColor ? $LabelColor : $Teal # because ? ignores blanks
    }
    process {
        $InputObject
        | Join-String -op '    🐒 := ' -sep ', '
        | Join-String -op $PSStyle.Background.FromRgb($LabelColor) -os $PSStyle.Reset
    }
    end { '<==' }
}
# 0..1 | doStuff2 -Label 'fe32aa'
'## ==  as Pipeline'
0..1 | doStuff2 -Label '#dbdca8'
# hr
'## ==  as Param'
doStuff2 -Inp (0..1) -Label '#dbdca8'


function Fg {
    param(
        [Parameter(Mandatory, ValueFromPipeline, Position = 0)]
        [string]$Color,
        [switch]$Stuff
    )
    process {

    }
    end {

    }
}

$c = '#fe9234'
$c | Fg -stuff
Fg -Color $c -stuff