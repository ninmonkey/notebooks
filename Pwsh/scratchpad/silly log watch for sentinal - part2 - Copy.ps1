
# -----------------------------------------
# Example2

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

# Term2 
Import-Module NameIt
function _term2 {
    function random.Pair {
        # assymetric output for tail to parse
        $data = @{ Rune = Random.Emoji | ForEach-Object tostring 
            Name        = Ig '[person]'
        } 
        if (($True, $false | Get-Random -Count 1)) { 
            $data.Id = Ig '##'
        }
        else { 
            $data.Color = Ig '[color]'
            $data.Codepoint = $Data.Rune.EnumerateRunes().Value | hex 
        }
        $data | ConvertTo-Json -Compress
    }

    while ($true) {
        Start-Sleep 0.4; 
        random.Pair
    }

}

function _term3 {
    # term3
    'end' | Add-Content 'g:\temp\emo.log' -PassThru
}

