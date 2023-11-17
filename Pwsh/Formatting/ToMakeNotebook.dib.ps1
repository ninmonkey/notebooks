function .for { 
    # does this properly stream?
    # experimenting with sugar for number ranges
    param( 
       $start, $end, $delta,

       [ArgumentCompletions(
            '[0, 100)', '[0, 100]', '0:100', '0:100:10',
            '0 10 3', '0 10', '0 10 -InclusiveEnd'
       )]
       [Parameter()]
       [string]$SliceExpression

    ) 
    $accum = $start
    while($accum -lt $end) { 
        $accum; $accum += $delta ;
    }
}

hr
.for 0 64 2 | Grid -PadLeft 8 -Count 3
.for 0 64 2 | Grid -PadLeft 8 -Count 6
hr
.for 0 64 2 | Grid -PadLeft 2 -Count 10
hr
.for 0 64 2 | Grid -PadLeft 2 -Count 3
.for 0 64 2 | Grid -PadLeft 2 -Count 6
hr
.for 0 16 2 | Grid -Auto
hr
