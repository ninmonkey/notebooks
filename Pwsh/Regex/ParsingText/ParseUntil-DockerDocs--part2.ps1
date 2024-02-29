<#
Returns parsed output as objects
    runs command: docker --help

searching for all sub commands
#>
$State = @{
    SkipBefore = $true
    ShouldBreak = $false
}
$Re = @{
  SkipBefore  = '^Commands'
  ShouldBreak = '^Global Options'
}

[string[]]$lines ??= docker --help
$selected = $Lines | %{
    $cur = $_
    if($cur -match $Re.SkipBefore) {
        $state.SkipBefore = $false
        return
    }
    if($State.SkipBefore) { return }

    if($cur -match $Re.ShouldBreak) {
        $state.ShouldBreak = $true
    }
    if($State.ShouldBreak) { return }
    $cur
}
$selected #| CountOf

$render = $selected.ForEach({
    $cur = $_
    $parseRe = @'
(?x)
    # sample: https://regex101.com/r/A7tyKn/1
    # ex: " top         Display the running processes of a container"
    # ex: "  rename      Rename a container"
    ^
    \s+
    (?<SubCommand>.*?)
    \s+
    (?<Description>.*)
    $
'@
    if( $cur -match $parseRe ) {
        $matches.remove(0)
        [pscustomobject]$Matches
    } else {
        'ShouldNeverReachParsingLine: {0}' -f $cur
            | write-error
    }
})
$render #| CountOf

<#
outputs:

SubCommand Description
---------- -----------
attach     Attach local standard input, output, and error streams to a running container
commit     Create a new image from a container's changes
cp         Copy files/folders between a container and the local filesystem
create     Create a new container
diff       Inspect changes to files or directories on a container's filesystem
events     Get real time events from the server
export     Export a container's filesystem as a tar archi
           ....
#>
