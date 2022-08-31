goto 'c:\nin_temp'
$P ??= @{}
$binES = Get-Command -ea stop'C:\Program Files\Everything\Everything.exe'
$P.Dest = 'out.es.txt'
$query = 'dm:today path:"c:\nin_temp"'

@'
try new cycle modes command

fzf --preview 'cat {}' --preview-window right,40% \
    --bind 'ctrl-/:change-preview-window(right,70%|down,40%,border-top|hidden|)'
'@ | Write-Warning


$binArgs = @(
    '-console'
    '-create-file-list'
    'c:\nin_temp\out.es'
    'c:\nin_temp'
    #  $P.Dest
    # $Query
)
$BinArgs = @(
    '-console'
    '-url'
    'es:count:5 dm:last3weeks path:"c:\nin_temp"'
)

#$binArgs -join ' '  | label 'args'
if ($false) {
    $pres = Start-Process -path $binES.Source -RedirectStandardError 'start_stderr.txt' -RedirectStandardOutput 'start_stdout.txt' -ArgumentList $binArgs -WorkingDirectory 'c:\nin_temp' -PassThru
}
$binArgs -join ' ' | label 'args'
#ls 'start*.txt'

& $bin

$NameList
| StripAnsi | To->RelativePath
| Where-Object { -not ( Test-IsDirectory -InputObject $_ ) }
| fzf.exe -m --preview 'bat --style=snip,header,numbers --line-range=:200 "{}"'