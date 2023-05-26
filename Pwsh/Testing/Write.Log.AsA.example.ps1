. (gi -ea 'stop' ($PSCommandPath -replace '\.example', ''))


function FormatStuff {
    $Input | Join-String -f "`n - {0}" -op "Stuff"
}

Label 'section' 'start'
Write.Log.AsA CurrentLine
Write.Log.AsA PSCommandPath

function AddStuff.Basic {
    param (
         [object]$A,
         [object]$b
    )

    $a + $b | FormatStuff

    Write.Log.AsA CurrentLine
    Write.Log.AsA PSCommandPath

}

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
        $addSome = $a + $b
        $addSome

        Write.Log.AsA CurrentLine
        Write.Log.AsA PSCommandPath
    }
    end {
        $addSome

        Write.Log.AsA CurrentLine
        Write.Log.AsA PSCommandPath
    }
}

hr -fg magenta
Label 'section' 'Basic'
AddStuff.Basic
