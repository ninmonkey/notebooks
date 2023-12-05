function FormatDate {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, ValueFromPipeline)]
            [datetime]$Dt,

        [Parameter()]
            [ArgumentCompletions(
                '([CultureInfo]::InvariantCulture)', 'en-us', 'de-de' )]
            [CultureInfo]$Culture = [CultureInfo]::InvariantCulture
    )
    $PSBoundParameters | ConvertTo-Json -Depth 1 -Compress | Write-debug
    $null -eq $Culture | Join-String -f 'Cult == $Null: {0}' | write-verbose -verb
    if( [String]::IsNullOrWhiteSpace( $Culture )) {
        throw "MandatoryCultureWasBlank!"
    }
    [ArgumentException]::ThrowIfNullOrWhiteSpace( $Culture, 'Culture' )
}
return


# FormatDate (Get-Date)
# (get-date).ToString( [cultureinfo]::InvariantCulture )
# Get-Date | FormatDate -Culture ([CultureInfo]::InvariantCulture)
