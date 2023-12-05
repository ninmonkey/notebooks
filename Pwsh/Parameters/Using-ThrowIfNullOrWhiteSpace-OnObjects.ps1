function FormatDate {
    [Alias('Test.Fmt.Date')]
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, ValueFromPipeline)]
            [datetime]$Dt,

        [Parameter()]
            [ArgumentCompletions(
                '([CultureInfo]::InvariantCulture)', 'en-us', 'de-de' )]
            $Culture
            # $Culture = [CultureInfo]::InvariantCulture
            # [CultureInfo]$Culture = [CultureInfo]::InvariantCulture
    )
    $Culture ??= [CultureInfo]::InvariantCulture
    if( [String]::IsNullOrEmpty( $Culture )) { throw "MandatoryCultureWasBlank!" }
    [ArgumentException]::ThrowIfNullOrWhiteSpace( $Culture, 'Culture' )
    return $Dt.ToString( $Culture )

    # $PSBoundParameters | ConvertTo-Json -Depth 1 -Compress | Write-debug
    # $null -eq $Culture | Join-String -f 'Cult == $Null: {0}' | write-verbose -verb
}
FormatDate -Dt (get-date) (get-culture 'en-us') # good
FormatDate -Dt (get-date)                       # error

return
FormatDate (Get-Date) -Culture (Get-Culture 'en-us')
return
FormatDate (Get-Date) -Culture ([CultureInfo]::InvariantCulture)
Get-Date | FormatDate -Culture ([CultureInfo]::InvariantCulture)


# FormatDate (Get-Date)
# (get-date).ToString( [cultureinfo]::InvariantCulture )
