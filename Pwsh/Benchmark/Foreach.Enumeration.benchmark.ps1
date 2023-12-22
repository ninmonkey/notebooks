@'
Outputs:

# sort: Time


Technique      Time             RelativeSpeed GroupName Throughput
---------      ----             ------------- --------- ----------
foreach        00:00:00.0891213          1.00                22.44
process block  00:00:00.6515211          7.31                 3.07
ForEach-Object 00:00:04.4421355         49.84                 0.45
.ForEach()     00:00:06.0717863         68.13                 0.33

'@
h1 (Join-String -f 'File: {0}' -in $PSCommandPath)

function Measure.Group {
    [CmdletBinding()]
    param(
        # [ValidateNotNullOrWhiteSpace()]
        # [Alias('Label')]
        # [string]$GroupName,

        # [ValidateNotNullOrWhiteSpace()]
        # [string]$CommandName,

        [int]$RepeatCount = 2,

        [Management.Automation.ActionPreference]$CommandErrorActionPref = 'Continue',
        [switch]$AsJob = $true
    )


    Measure-Benchmark -AsJob:$AsJob -ea 'ignore' -Group ($GroupName ?? 'none') -RepeatCount $RepeatCount -Technique @{
        'foreach' = {
            $range = [Linq.Enumerable]::Range(0, 1mb)
            & {
                foreach ($i in $args[0]) { $i }
            } $range
        }
        '.ForEach()' = {
            $range = [Linq.Enumerable]::Range(0, 1mb)
            & {
                $args[0].ForEach({ $_ })
            } $range
        }
        'ForEach-Object' = {
            $range = [Linq.Enumerable]::Range(0, 1mb)
            & {
                $args[0] | ForEach-Object { $_ }
            } $range
        }
        'process block' = {
            $range = [Linq.Enumerable]::Range(0, 1mb)
            & {
                $args[0] | & { process { $_ } }
            } $range
        }
    } | sort-Object Time -desc
}

'starting jobs...' | write-host -back 'blue'
$results =
    @( Measure.Group -AsJob )
        | Receive-Job -Wait -AutoRemoveJob

'$results = {0}' -f $Results.count

h1 'grouped'
$results | ft -AutoSize  GroupName, Technique, Throughput, RelativeSpeed, Time

h1 'all'
$results | ft -AutoSize  GroupName, Technique, Throughput, RelativeSpeed, Time
hr -fg magenta

h1 (Join-String -in $PSCommandPath -f "File: {0}")
h1 'sort: Technique, Group'
$results
    | sort Technique, Groupname
    | ft -AutoSize Technique, Time, RelativeSpeed, GroupName, Throughput

h1 'sort: Group, Technique'
$results
    | sort GroupName, Technique
    | ft -AutoSize Technique, Time, RelativeSpeed, GroupName, Throughput

h1 'sort: Time'
$results
    | sort Time, Technique
    | ft -AutoSize Technique, Time, RelativeSpeed, GroupName, Throughput
