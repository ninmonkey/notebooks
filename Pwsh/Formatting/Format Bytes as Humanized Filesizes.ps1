function Format-HumanizeFileSize {
    <#
    .synopsis
        Convert integer bytes into a humanized abbreviated strings
    .notes
        Pwsh 6.2 and 7 added additional units: <https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_numeric_literals?view=powershell-7.4#integer-literals>
    .example
        pwsh> Format-HumanizeFileSize 1.234kb
            1.2 KB

        pwsh> Format-HumanizeFileSize 1.234kb -Digits 5
            1.23438 KB
    .example
        pwsh> 12.45gb, .9mb, 91231451, 2 | Format-HumanizeFileSize | Join-string -sep ', '
            12.5 GB, 921.6 KB, 87.0 MB, 2.0 b
    #>
    # Converts size in bytes to a humanized string
    [Alias('FormatFilesize')]
    [OutputType( [String]) ]
    param(
        # Size in bytes. future could include [uint64]. I used [long] because pwsh 5.1 and 7 use that
        [Parameter( Mandatory, ValueFromPipeline)]
        [long[]] $SizeInBytes,

        # 0-to-number of digits after the decimal
        [Parameter()]
        [int] $Digits = 1
    )

    # example final template string:
        # '{0:n2} TB'
    process {
        $Prefix = '{0:n', $Digits, '}' -join ''
        foreach($Item in $SizeInBytes) {
            switch( $Item) {
                # outer bounds
                { $_ -lt 1kb } { "$Prefix b" -f $_ ; break}
                { $_ -ge 1pb } { "$Prefix PB" -f ($_ / 1pb) ; break}
                # rest
                { $_ -ge 1tb } { "$Prefix TB" -f ($_ / 1tb) ; break}
                { $_ -ge 1gb } { "$Prefix GB" -f ($_ / 1gb) ; break}
                { $_ -ge 1mb } { "$Prefix MB" -f ($_ / 1mb) ; break}
                { $_ -ge 1kb } { "$Prefix KB" -f ($_ / 1kb) ; break}
                default {
                    # break should be redundant, and this should too, unless there's a logic error
                    throw "ShouldNeverReachCase: $SizeInBytes"
                }
            }
        }
    }
}

$Samples = [long[]]@(
    780, 1234,
    0.8kb, 1.2kb,
    0.8mb, 1.2mb,
    0.8gb, 1.2gb,
    0.8tb, 1.2tb,
    0.8pb, 1.2pb
)
$Samples | %{
    [pscustomobject]@{
        BytesAsLong = $_
        Humanized   = Format-HumanizeFileSize $_ -Digits 2
    }
}

<# output
     BytesAsLong Humanized
     ----------- ---------
             780 780.00 b
            1234   1.21 KB
             819 819.00 b
            1229   1.20 KB
          838861 819.20 KB
         1258291   1.20 MB
       858993459 819.20 MB
      1288490189   1.20 GB
    879609302221 819.20 GB
   1319413953331   1.20 TB
 900719925474099 819.20 TB
1351079888211149   1.20 PB

#>
