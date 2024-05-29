function Start-TestConnectionLoop {
    <#
    .SYNOPSIS
        repeat pinging until canceled by ctrl+c. Writes to log every iteration.
    .EXAMPLE
        Pwsh> Start-TestConnectionLoop -SleepSeconds 0.1 -Verbose -Targets 'somedoesnotexist.com', 9.12.3.3, 'google.com', 1.1.1.1
        Pwsh> Get-Content 'ping-history.csv'

            "Status","Ping","Latency","Address","DisplayAddress","Source","DateTime"
            "Success","1","37","8.8.8.8","8.8.8.8","bob","2024-05-28 8:16:48 PM"
            "Success","1","16","1.1.1.1","1.1.1.1","bob","2024-05-28 8:16:48 PM"
            "TimedOut","1","0",,"*","bob","2024-05-28 8:16:49 PM"
            "Success","1","37","8.8.8.8","8.8.8.8","bob","2024-05-28 8:16:49 PM"
            "Success","1","14","1.1.1.1","1.1.1.1","bob","2024-05-28 8:16:49 PM"
    .EXAMPLE
        Pwsh> $targetList = 'somedoesnotexist.com', '9.12.3.3', 'google.com', '1.1.1.1'
        Pwsh> Start-TestConnectionLoop -SleepSeconds 0.1 -Verbose -Targets $TargetList

        # all logs
        Pwsh> Get-Content ping-history.csv -Raw | ConvertFrom-Csv  | ft

        # filter shows timedOut records only

        Pwsh> Get-Content ping-history.csv -Raw | ConvertFrom-Csv |
            ? Status -ne 'Success' | ft

            Status   Ping Latency Address DisplayAddress Source DateTime
            ------   ---- ------- ------- -------------- ------ --------
            TimedOut 1    0               *              nin8   2024-05-28 8:16:46 PM
            TimedOut 1    0               *              nin8   2024-05-28 8:16:47 PM

        # errors and exceptions:
        Pwsh> Get-Content error-history.csv

            "DateTime","ErrMessage","CategoryInfo"
            "2024-05-28 8:47:37 PM","Testing connection to computer 'somedoesnotexist.com' failed: Cannot resolve the target name.","ResourceUnavailable: (somedoesnotexist.com:String) [Test-Connection], PingException"


    #>
    [CmdletBinding()]
    param(
        [string[]] $Targets = ('google.com', '1.1.1.1'),
        [double] $SleepSeconds = 0.5,
        [int] $TimeoutSeconds = 1,
        [string] $DestinationPath = 'ping-history.csv',
        [string] $ErrorLogPath = 'error-history.csv'
    )
    'Start Ping Loop, Target[s]: {0}, Destination: {1}' -f @(
        $Targets -join ', '
        $DestinationPath
    )

    while($True) {
        $lastCount = $error.count
        Sleep -Milliseconds $SleepSeconds
        $Now = Get-Date
        $testConnectionSplat = @{
            TargetName         = $Targets
            Ping               = $true
            Count              = 1
            TimeoutSeconds     = $TimeoutSeconds
            ResolveDestination = $false # if off, it goes faster
            ErrorVar           = 'evPingError'
        }

        # 'Success' and 'TimedOut' are both included in the $results list
        $results = Test-Connection @testConnectionSplat
        $records = $Results
            | Select-Object Status, Ping, Latency, Address, DisplayAddress, Source
            | Add-Member -PassThru -NotePropertyMembers @{
                DateTime = $Now
            }

        $records | Export-Csv -Append $DestinationPath
        'wrote {0} records to {1}' -f @(
            $records.count
            $destinationPath
        ) | Write-Verbose

        if($evPingError) {
            'Loop had {0} errors!' -f @( $evPingError.count ) | Write-verbose
            $evPingError | %{
                [pscustomobject]@{
                    DateTime     = $Now
                    ErrMessage   = $_.ToString()
                    CategoryInfo = $_.CategoryInfo.ToSTring()
                }
            }
            | Export-Csv -Append $ErrorLogPath
        }
    }
}

@'
## Try this:
> $targetList = 'somedoesnotexist.com', '9.12.3.3', 'google.com', '1.1.1.1'
> Start-TestConnectionLoop -SleepSeconds 0.1 -Verbose -Targets $TargetList
> Get-Content ping-history.csv -Raw | ConvertFrom-Csv  | ft

> Get-Content ping-history.csv -Raw | ConvertFrom-Csv |
    ? Status -ne 'Success' | ft

## filter shows timedOut records only

    Status   Ping Latency Address DisplayAddress Source DateTime
    ------   ---- ------- ------- -------------- ------ --------
    TimedOut 1    0               *              nin8   2024-05-28 8:16:46 PM
    TimedOut 1    0               *              nin8   2024-05-28 8:16:47 PM
    TimedOut 1    0               *              nin8   2024-05-28 8:16:48 PM

> Get-Content error-history.csv
'@
