hr
h1 '1] stuff1'
function stuff {
    begin {
        '==>'
    }
    process { '    🐱' }
    end { '<==' }
}

function stuff2 {
    [CmdletBinding()]
    param(
        [Parameter(ValueFromPipeline)]
        [object]$Stuff2
    )
    begin {
        '==>'
    }
    process { "🐒: $_" }
    end { '<==' }
}
0..2 | stuff2
hr
# stuff2 (0..2)
0..2 | stuff
hr
stuff (0..2)

h1 '2] stuff1'
hr -fg magenta


function Stuff3 {
    [CmdletBinding()]
    param(
        [Parameter(ValueFromPipeline)]
        [object]$InputObject
    )
    begin {
        '==>'
    }
    process { "🐒: $_" }
    end { '<==' }
}
hr -fg yellow

h1 '3] as Pipeline'
0..1 | Stuff3
hr
h1 '3] as Param'
Stuff3 (0..1)



# //=========

function Stuff4 {
    [CmdletBinding()]
    param(
        [Parameter(ValueFromPipeline)]
        [object]$InputObject,

        [string]$Color
    )
    begin {
        '==>'
        $Color = $Color ? $Color : $Teal # because ? ignores blanks
    }
    process {
        $InputObject
        | Join-String -op '    🐒 := ' -sep ', '
        | Join-String -op ( [rgbColor]$Color ) -os $PSStyle.Reset
    }
    end { '<==' }
}
h1 '4] as pipe'
0..1 | Stuff4 'blue'
hr
h1 '4] as Param'
Stuff4 (0..1) 'blue'
