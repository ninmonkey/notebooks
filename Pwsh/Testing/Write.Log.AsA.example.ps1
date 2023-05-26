. (gi -ea 'stop' ($PSCommandPath -replace '\.example', ''))


function FormatStuff {
    $Input
    | Join-String -f "`n - {0}" -op "Stuff"
}


function AddStuff.Basic {
    param (
         [object]$A,
         [object]$b
    )

    $a + $b | FormatStuff

    Write.Log.AsA CurrentLine
    Write.Log.AsA PSCommandPath
}

AddStuff.Basic -A 10 -B 20

function AddStuff.WithBind {
    [CmdletBinding()]
    param (
         [object]$A,
         [object]$b
    )
    $a + $b | FormatStuff


    Write.Log.AsA CurrentLine
    Write.Log.AsA PSCommandPath
}
function AddStuff.WithProc {
    [CmdletBinding()]
    param (
         [object]$A,
         [object]$b
    )
    process {
        $cur = $_
        $addSome = $a + $b
        $addSome | Join-string -op "item $cur = "

        Write.Log.AsA CurrentLine
        Write.Log.AsA PSCommandPath
    }
    end {
        $addSome

        Write.Log.AsA CurrentLine
        Write.Log.AsA PSCommandPath
    }
}


Label 'section' 'start'
Write.Log.AsA CurrentLine
Write.Log.AsA PSCommandPath

hr -fg magenta
Label 'section' 'Basic'
AddStuff.Basic -A 10 -B 20

hr -fg magenta
Label 'section' 'WithBind'
AddStuff.WithBind -A 10 -B 20

hr -fg magenta
Label 'section' 'WithProc'
'a'..'c' | AddStuff.WithProc -A 10 -B 20
