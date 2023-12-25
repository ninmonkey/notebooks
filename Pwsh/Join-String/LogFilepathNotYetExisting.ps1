


@(
    'temp:\notyetexisting.log'

    Join-path (gi 'temp:') 'notyetexisting.log'
    Join-path (Convert-Path 'temp:') 'notyetexisting.log'

    # Can you do this? Yes. Should you? Probably not.
    [IO.FIleInfo]::new('temp:\notyetexisting.log')
    [IO.FIleInfo]::new( (Join-Path (gi temp:\) 'notyetexisting.log'))
 ) | Join-String -f "`n - {0}"
