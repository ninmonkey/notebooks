$argsComple = 'foo', 'bar'
function testCr2 {
    <#
    .SYNOPSIS
        experiment
    #>
    param(
        # sets bullet types, but if overriden in -Options, Options has priority
        [string]$BulletStr = '-',
        [ArgumentCompletions(
            '@{ ULHeader = (hr 0) ; ULFooter  = (hr 0); }',
@'
@{
    ULHeader =  @( (hr 1) ; Label "Newest Files" "c:/temp"  ) | Join-String
    ULFooter  = (hr 0);
}
'@, #-replace '\r?', '',
            '@{ BulletStr = "•" }'
        )]
        [hashtable]$Options = @{},

        # sets bullet types, but if overriden in -Options, Options has priority
        [ArgumentCompletions(
            '$argsComple'
        )]
        [string]$q3 = '-'

    )
    'DidStuff'
}
function testCr {
    <#
    .SYNOPSIS
        experiment
    #>
    param(
        [ArgumentCompletions(
            'oneline',
'multi
line',
            'anothersingle'
        )]

        # sets bullet types, but if overriden in -Options, Options has priority
        [string]$BulletStr = '-',
        [ArgumentCompletions(
            '@{ ULHeader = (hr 0) ; ULFooter  = (hr 0); }',
@'
@{
    ULHeader =  @( (hr 1) ; Label "Newest Files" "c:/temp"  ) | Join-String
    ULFooter  = (hr 0);
}
'@, #-replace '\r?', '',
            '@{ BulletStr = "•" }'
        )]
        [hashtable]$Options = @{},
        # sets bullet types, but if overriden in -Options, Options has priority
        [string]$q3 = '-',
        [ArgumentCompletions(
            '$argsComple'
        )]

    )
    'DidStuff'
}