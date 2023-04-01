
function WriteHr {
    param(
        [int]$Width,
        [ArgumentCompletions('*', '-')]
        [string]$Character = '*'
    )
    if(-not $width) {
        $Width = $host.ui.RawUI.WindowSize.Width
    }
    $Character * $width -join ''
}
function WriteNL {
    param( [int]$Count = 1)
    "`n" * $count -join ''
}

function WriteMessage {
    param(
        [string]$Message,
        [int]$Width
    )
    if(-not $width) {
        $Width = $host.ui.RawUI.WindowSize.Width
    }

    WriteNL
    WriteHr -Width $Width
    "  $Message "
    WriteHr -Width $Width
    WriteNL
}

WriteMessage 'hi world'