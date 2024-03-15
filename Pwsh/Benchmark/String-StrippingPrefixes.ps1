$CommandName = 'pwsh'
@'
Outputs:
'@
h1 (Join-String -f 'File: {0}' -in $PSCommandPath)
$Samples = @(
    
)
function Measure.Group {
    [CmdletBinding()]
    param(
        [ValidateNotNullOrWhiteSpace()]
        [Alias('Label')]
        [string]$GroupName,
        [int]$RepeatCount = 1,

        [Management.Automation.ActionPreference]$CommandErrorActionPref = 'Continue',
        [switch]$AsJob = $true
    )
    Measure-Benchmark -AsJob:$AsJob -ea 'ignore' -Group $GroupName -RepeatCount $RepeatCount -Technique @{
        'a' = {

        }
    } | sort-Object Time -desc
}

'starting jobs...' | write-host -back 'blue'
$results =  @(
    # Measure.Group -AsJob -GroupName 'Exists' -CommandName 'pwsh' -CommandErrorActionPref 'Continue'
    Measure.Group -AsJob -GroupName 'Basic'
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

return
return





# old normal invoke
h1 'exists, missing'
$results.A =
    Measure.Group -ea 'ignore' -ov 'ovA' -GroupName 'Exists' -CommandName 'pwsh' -CommandErrorActionPref 'Continue'

$results.B =
    Measure.Group -ea 'ignore' -ov 'ovB' -GroupName 'Missing' -CommandName 'does_not_exist' -CommandErrorActionPref 'Continue'

return
hr
h1 (Join-String -in $PSCommandPath -f "File: {0}")
h1 'ByName'
$ovSummary | sort-Object Technique | ft -auto
h1 'ByTime'
$ovSummary | sort-Object Time | ft -auto
