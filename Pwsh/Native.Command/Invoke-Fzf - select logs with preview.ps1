<#
.synopsis
  example of piping, using native commands (fzf, bat), then output file objects
#>

$Config = @{ EnablePreview = $true } 
$binFzf = Gcm fzf -CommandType Application -ea 'stop'

[Collections.Generic.List[Object]]$fzfArgs = @(
    '-i'
    '-q', 'query.sql$'
    '--ansi'
    '--history={0}' -f @( 'g:\temp\fzf.history.log' )
)
# you can conditionally append to arrays for dynamic args to native commands
if($Config.EnablePreview) { 
    $fzfArgs.AddRange(@(
        '--preview={0}' -f @( 
             'bat --force-colorization --line-range 0:20 {}'
        )
    ))
}

$selectLogs2 = ls . *.log -Recurse | % FullName |
& $binFzf @fzfArgs |
Get-Item | Sort LastWriteTime
