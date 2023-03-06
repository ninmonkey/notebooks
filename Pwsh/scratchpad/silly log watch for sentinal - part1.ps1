# 'hi'
return
Import-module NameIt
# term1
$Path = @{
    Log1 = 'g:\temp\emo.log'
    Log2 = 'g:\temp\emo.out.log'
}
$PSDefaultParameterValues.remove('*:verbose')
function _term1 {  
    # tail0: allows sentinal to exist in the log, without having to delete it
    Get-Content $Path.Log1 -Wait -Tail 0 
    | ForEach-Object { $_; if ($_ -match 'end') { break; } }
    | ForEach-Object { 
        $_ | Join.ul # custom formatting applies to stdout and file
    }
    | Set-Content $Path.Log2 -PassThru 
    | ForEach-Object { 
        # custom formatting applies to STDOUT but not the log
        $_ | Join.ul
    }
}
function _term1 { 
    try { 
        Get-Content $Path.Log1 -Wait -Tail 0 -ea  break
        | ForEach-Object { $_;
            if ($_ -match 'end') { throw 'done'; } }
            # if ($_ -match 'end') { break; } }
        | ForEach-Object { 
            "both: $_"
            $_ | Join.ul # custom formatting applies to stdout and file
        }
        | Set-Content $Path.Log2 -PassThru 
        | ForEach-Object { 
            # custom formatting applies to STDOUT but not the log
            "OnlyTerm`n    $_"
            # $_ | Join.ul
        }
    } catch {
        write-warning "Exception: had a: $_"
    }
    'log end'
    gc $path.Log1 -tail 4
}
# term2
function _term2 {
    function random.emoji { (0x1f993 - 100)..(0x1f993 + 100) |  Get-Random -Count 1 | ForEach-Object { [Text.Rune]::new( $_ ) } }
    while ($true) { 
        Start-Sleep 0.4;
        Random.Emoji | Add-Content -Path $Path.Log1 -PassThru 
    }
}
 
function _term3 {
    # term3
    'end' | Add-Content $Path.Log1 -PassThru
}

