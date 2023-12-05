<#
context:
I feel like I've asked this before, but is there a way to make ConvertFrom-Json in PS7 not convert UTC timestamps to local time?
really throws me when looking at objects pulled from our services, b/c all our logs are in UTC
#>
Set-Alias 'Json' 'ConvertTo-Json'
Set-Alias 'Json.From' 'ConvertFrom-Json'
$Now = [Datetime]::Now
$NowUtc = [Datetime]::UtcNow

[ordered]@{
    GetDate = Get-Date
    Now = $Now
    NowUtc = $NowUtc

    Js_Now =
        $Now | Json
    Js_Now_FromManualUtc =
        $Now.ToUniversalTime() | Json

    Js_NowUtc =
        $NowUtc | Json

    R_Now =
        $Now | Json | Json.from

    R_Now2 =
        $Now.ToUniversalTime() | Json | Json.From

    H_1 =
        # "2023-12-05T18:25:48.2587934Z"
        # ["2023-12-05T18:25:48.2587934Z"]
        '["2023-12-05T18:25:48.2587934Z"]' | Json.From
    H_ManualToUni2 =
        ('["2023-12-05T18:25:48.2587934Z"]' | Json.From).ToUniversalTime()

}

<#
output
    Name                           Value
    ----                           -----
    GetDate                        12/5/2023 12:28:49 PM
    Now                            12/5/2023 12:28:49 PM
    NowUtc                         12/5/2023 6:28:49 PM
    Js_Now                         "2023-12-05T12:28:49.1778662-06:00"
    Js_Now_FromManualUtc           "2023-12-05T18:28:49.1778662Z"
    Js_NowUtc                      "2023-12-05T18:28:49.1778723Z"
    R_Now                          12/5/2023 12:28:49 PM
    R_Now2                         12/5/2023 6:28:49 PM
    H_1                            12/5/2023 6:25:48 PM
    H_ManualToUni2                 12/5/2023 6:25:48 PM

#>
