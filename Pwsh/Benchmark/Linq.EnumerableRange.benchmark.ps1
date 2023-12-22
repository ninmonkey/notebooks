@'
Outputs:

# sort: Time

Technique                              Time             RelativeSpeed GroupName Throughput
---------                              ----             ------------- --------- ----------
Nums = [EnumerableRange]::(0, 4mb )    00:00:00.0124675          1.00               160.42
[EnumerableRange]::(0, 4mb ) | %{ $_ } 00:00:00.0846974          6.79                23.61
Nums = 0..4mb                          00:00:00.9147725         73.37                 2.19
Nums = 0..4mb | %{ $_ }                00:00:32.7884668       2629.92                 0.06

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


    Measure-Benchmark -AsJob:$AsJob -ea 'ignore' -Group $GroupName -RepeatCount $RepeatCount -Technique @{
        'Nums = [EnumerableRange]::(0, 4mb )' = {
            $nums = [Linq.EnumerableRange]::(0, 1mb)
        }
        'Nums = 0..1mb' = {
            $nums = 0..1mb
        }
        '[EnumerableRange]::(0, 1mb ) | %{ $_ }' = {
            $nums = [Linq.EnumerableRange]::(0, 1mb) | %{ $_ }
        }
        'Nums = 0..1mb | %{ $_ }' = {
            $nums = 0..1mb | %{ $_ }
        }
    } | sort-Object Time -desc
}

'starting jobs...' | write-host -back 'blue'
$results =  @(
    # Measure.Group -AsJob -GroupName 'Exists' -CommandName 'pwsh' -CommandErrorActionPref 'Continue'
    Measure.Group -AsJob
)
    | Receive-Job -Wait -AutoRemoveJob
# $results =  @(
#     Measure.Group -AsJob -ea 'ignore' -ov 'ovA' -GroupName 'Exists_eaI' -CommandName 'pwsh' -CommandErrorActionPref 'Continue'
#     Measure.Group -AsJob -ea 'ignore' -ov 'ovB' -GroupName 'Missing_eaI' -CommandName 'missing' -CommandErrorActionPref 'ignore'
#     Measure.Group -AsJob -ea 'continue' -ov 'ovC' -GroupName 'Missing_eaC' -CommandName 'missing' -CommandErrorActionPref 'ignore'
# )
#     | Receive-Job -Wait -AutoRemoveJob

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
