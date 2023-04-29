

# if there's no conflicts, this will run
# netsh show helper

# or even adding exe

# using the array operator simplifies quoting @() -- Not used in this demo

[Collections.Generic.List[Object]]$ArgsSh = @()
function previewCliArgs {
   $ArgsSh | Join-String -sep ' ' -op "$($BinSh.Name) "
}

# Building args with an array gives you flexibiltiy
$something = $true; $TestOnly = $false

if('mode is helper or some condition') {
    $argsSh.AddRange(@(
        'show'
        'helper'
    ))
}
$TestOnly = $true
if($TestOnly) {
    $argsSh.Add('/?')
}
previewCliArgs

# & $binSh @ArgsSh