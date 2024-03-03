Import-Module 'BenchPress' -PassThru

$items = 0..9999
$item_Str = $items.ForEach([string])

$results = bench -RepeatCount 5 -Technique @{
    JoinStringParam        = {
        Join-String -inp $Items -sep ', '
    }
    JoinStringPipe         = {
        $Items | Join-String -sep ', '
    }
    JoinOperator           = {
        $items -join ', '
    }
    JoinOperator_PreCast           = {
        $items_str -join ', '
    }
    JoinStringPipe_PreCast = {
        $Items_Str | Join-String -sep ', '
    }
    JoinStringPipe_withCast_DuringPipe = {
        $items.ForEach([string]) | Join-String -sep ', '
    }
    JoinStringPipe_withToString_DuringPipe = {
        $items | % ToString | Join-String -sep ', '
    }
    JoinStringPipe_withCast_BeforePipe = {
        $stuff = $items.ForEach([string])
        $stuff | Join-String -sep ', '
    }
}
$results | Ft
