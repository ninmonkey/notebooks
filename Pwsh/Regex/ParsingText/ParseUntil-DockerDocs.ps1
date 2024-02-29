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
