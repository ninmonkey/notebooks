
$RootPaths = @(
    $Env:LocalAppData
    $Env:AppData
    $Env:ProgramFiles
    '..'
    'G:\datasource'
) | Get-Item

$Term = $rootPaths
| ForEach-Object {
    $_ | Join-String -DoubleQuote -sep ' ' -op 'path:ww' {
        $_
    }
}

$Term
return

$newQuery = @(
    'es:dm:last5minutes ext:log;jsonl '
    $RootPaths | Join-String -op ' ' -sep ' ' { $_ | Join-String -op 'path:ww:' -os -DoubleQuote }
)
#$newQuery
#{   $_.FullName | Join-String -DoubleQuote -Property Fullname }


$paths.FullName



return
$paths | ForEach-Object {
    $_ | Join-String FullName -DoubleQuote
}

function _addOr {
} function _addAnd {
}
# | Join-STring -sep ' '
#Join-String -op ' ' -sep ' ' { $_  | Join-String -op 'path:ww:' -os -DoubleQuote  }