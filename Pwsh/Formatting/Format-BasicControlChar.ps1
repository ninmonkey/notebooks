#requires -Version 7.0

# hr -fg magenta
# hr -fg yellow

$sample = 'hi 🐵🐒 world', @(
    0..244 | ForEach-Object { [Char]::ConvertFromUtf32( $_ ) } )

$sample | Join-String

$sample.EnumerateRunes() | ForEach-Object {
    if ($_.Value -ge 0 -and $_.Value -le 0x1f) {
        return [Text.Rune]::new( $_.Value + 0x2400 )
        # for WinPS: return [Char]::ConvertFromUtf32( $_.Value + 0x2400 ) # $_
    }
    else {
        $_
    }
}
| Join-String -sep '' # Comment me off and it renders a table
| Format-Table

