function trySeveralF { 
    <#
    .NOTES
        try several variations, and explicitly local/uni versions
    .example
        Pwsh> [DateTimeOffset]::Now | trySeveralF
            # ... output

        Pwsh> [DateTime]::Now | trySeveralF
            # ... output
    .LINK
        https://en.wikipedia.org/wiki/ISO_8601
    .LINK
        https://learn.microsoft.com/en-us/dotnet/standard/base-types/standard-date-and-time-format-strings
    .LINK
        hhttps://learn.microsoft.com/en-us/dotnet/standard/base-types/custom-date-and-time-format-strings
    #>
    param(
        [Parameter(ValueFromPipeline, Position = 0, Mandatory)]
        [object]$InputObject
    )
    process { 
        $fStr = @{
            Longer = $f_long = 'yyyy-MM—dd HH:mm:ss.fff'    
        }
        switch ($InputObject) {
            { $_ -is 'datetime' } {
                [PSCustomObject]@{
                    TypeName   = $InputObject.GetType().Name
                    o          = $InputObject.ToString('o')
                    oBig       = $InputObject.ToString('O')
                    u          = $InputObject.ToString('u')
                    uBig       = $InputObject.ToString('U')
                    long       = $InputObject.ToString($f_long)
                    uni_o      = $InputObject.ToUniversalTime().ToString('o')
                    uni_oBig   = $InputObject.ToUniversalTime().ToString('O')
                    uni_u      = $InputObject.ToUniversalTime().ToString('u')
                    uni_uBig   = $InputObject.ToUniversalTime().ToString('U')
                    uni_long   = $InputObject.ToUniversalTime().ToString($f_long)
                    local_o    = $InputObject.ToLocalTime().ToString('o')
                    local_oBig = $InputObject.ToLocalTime().ToString('O')
                    local_u    = $InputObject.ToLocalTime().ToString('u')
                    local_uBig = $InputObject.ToLocalTime().ToString('U')
                    local_long = $InputObject.ToLocalTime().ToString($f_long)
                }
            }
            { $_ -is 'datetimeoffset' } {
                # 'U' is not valid 
                [PSCustomObject]@{
                    TypeName   = $InputObject.GetType().Name
                    o          = $InputObject.ToString('o')
                    oBig       = $InputObject.ToString('O')
                    u          = $InputObject.ToString('u')
                    
                    long       = $InputObject.ToString($f_long)
                    uni_o      = $InputObject.ToUniversalTime().ToString('o')
                    uni_oBig   = $InputObject.ToUniversalTime().ToString('O')
                    uni_u      = $InputObject.ToUniversalTime().ToString('u')
                    
                    uni_long   = $InputObject.ToUniversalTime().ToString($f_long)
                    local_o    = $InputObject.ToLocalTime().ToString('o')
                    local_oBig = $InputObject.ToLocalTime().ToString('O')
                    local_u    = $InputObject.ToLocalTime().ToString('u')
                    
                    local_long = $InputObject.ToLocalTime().ToString($f_long)
                }
            

            }
            default { "Throw: ShouldNotReach: Unhandled type: $_" }
        }
    }
    
}

[DateTimeOffset]::Now | trySeveralF
[DateTime]::Now | trySeveralF

hr
$dt = '2023-01-13T00:12:11Z'
[DateTimeOffset]::Parse($dt).ToString("yyyy-MM-dd HH:mm:ss.fff")
[DateTimeOffset]::Parse($dt).UtcDateTime.ToString("yyyy-MM-dd HH:mm:ss.fff")

$dt2 = '2023-01-13T00:12:11+10:00'
[DateTimeOffset]::Parse($dt2).ToString("yyyy-MM-dd HH:mm:ss.fff")
[DateTimeOffset]::Parse($dt2).UtcDateTime.ToString("yyyy-MM-dd HH:mm:ss.fff")
@'

$dt = '2023-01-13T00:12:11Z'
[DateTimeOffset]::Parse($dt).ToString("yyyy-MM-dd HH:mm:ss.fff")
[DateTimeOffset]::Parse($dt).UtcDateTime.ToString("yyyy-MM-dd HH:mm:ss.fff")

$dt = '2023-01-13T00:12:11+10:00'
[DateTimeOffset]::Parse($dt).ToString("yyyy-MM-dd HH:mm:ss.fff")
[DateTimeOffset]::Parse($dt).UtcDateTime.ToString("yyyy-MM-dd HH:mm:ss.fff")

> Notice the difference here. The first example with Z is fine as the input value is UTC and it gives you 2023-01-13 00:12:11.000. But the 2nd example 2023-01-13T00:12:11+10:00 has a specific time zone so the 2 options give you 2023-01-13 00:12:11.000 and 2023-01-12 14:12:11.000 respectively. Where only the UtcDateTime (2nd option) is the same as the original input value
'@



# $f_long = 'yyyy-MM—dd HH:mm:ss.fff'
# $now = [Datetime]::Now
# $now.ToString('o')
# $now.ToString('u')
# $now.ToString($f_long)
# $now.ToUniversalTime().ToString('o')
# $now.ToUniversalTime().ToString('u')
# $now.ToUniversalTime().ToString($f_long)


# $f_long = 'yyyy-MM—dd HH:mm:ss.fff'
# $now.ToString('o')
# $now.ToString('u')
# $now.ToString($f_long)
# $now.ToUniversalTime().ToString('o')
# $now.ToUniversalTime().ToString('u')
# $now.ToUniversalTime().ToString($f_long)

