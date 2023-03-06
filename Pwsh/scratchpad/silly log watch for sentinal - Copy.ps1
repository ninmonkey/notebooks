# term1
# tail0: allows sentinal to exist in the log, without having to delete it
function _term1 { 
    Get-Content $Path.Log -Wait -Tail 0 
    | ForEach-Object { $_; if ($_ -match 'end') { break; } }
    | ForEach-Object { 
        $_ | Join.ul # custom formatting applies to stdout and file
    }
    | Set-Content 'g:\temp\out.log' -PassThru 
    | ForEach-Object { 
        # custom formatting applies to STDOUT but not the log
        $_ | Join.ul
    }
}

# term2
function _term2 {
    function random.emoji { (0x1f993 - 100)..(0x1f993 + 100) |  Get-Random -Count 1 | ForEach-Object { [Text.Rune]::new( $_ ) } }
    while ($true) { 
        Start-Sleep 0.4;
        Random.Emoji | Add-Content -Path 'g:\temp\emo.log' -PassThru 
    }
}
 
function _term3 {
    # term3
    'end' | Add-Content 'g:\temp\emo.log' -PassThru
}

