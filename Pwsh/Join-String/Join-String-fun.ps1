$enc8 = [Text.Encoding]::GetEncoding('utf-8')

$Str = @{
    CatHat = '🐱in the 🎩'
}


( $files = gci ~ )
| sort FullName
| Join-String -op "`n- " -sep "`n- "
$first10 = $files | select -first 10
function Join.Csv {
    $Input | Join-String -sep ', ' -SingleQuote
}
function Join.UL {
    $Input | Join-String -op "`n- " -sep "`n- "
}

$first10
# | Join.Csv