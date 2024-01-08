function ShowControlChars1 {
    # Convert ansi escapes to safe-to-print symbol versions
    # just add 0x2400 to the codepoint
    param( [string]$Str )
    $str -replace '[\x00-\x1f]', {
        $codepoint = [char]::ConvertToUtf32( $_.Captures[0].Value, 0)
        return [Text.Rune]::new( $codepoint + 0x2400 )
    }
}


function ShowControlChars2 {
    # Convert ansi escapes to safe-to-print symbol versions
    # just add 0x2400 to the codepoint
    param( [string]$Str )
    $str.EnumerateRunes() | %{
        if( $_.Value -le 0x1f ) {  [Text.Rune]( $_.Value + 0x2400 ) }
        else { $_ }
    } | Join-String
}


$str = "hi`n`nworld`r`nfooo`tbar`u{0}cat"
ShowControlChars1 $Str
ShowControlChars2 $Str
