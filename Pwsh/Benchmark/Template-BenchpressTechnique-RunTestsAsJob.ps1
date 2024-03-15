$start = [datetime]::Now
( $bench1 = Measure-Benchmark -AsJob:$false -GroupName 'first' -RepeatCount 1 -Technique @{
    a = { sleep 1 }
    b = { sleep 1 }
    c = { sleep 1 }
})
( $bench2 = Measure-Benchmark -AsJob:$false -GroupName 'two' -RepeatCount 1 -Technique @{
    d = { sleep 1 }
    e = { sleep 1 }
    f = { sleep 1 }
})

( $summary = $bench1, $bench2 | Receive-Job -Wait -AutoRemoveJob )
$end = [datetime]::Now
$delta = $end - $start

$summary | Ft -auto

$delta | Join-String -p TotalMilliseconds -f 'total duration: {0:n2} ms'
