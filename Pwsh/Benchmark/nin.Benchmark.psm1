#requires -Module Benchpress
using namespace System.Collections
using namespace System.Collections.Generic
using namespace System.Management.Automation
using namespace System.Management.Automation.Language
# using namespace System.Text

<#
Exported commands follow one of the patterns
    Verb-BenchNoun
    Benchy.*
#>

class BenchGroupRule {
    <#
    .synopsis
        encapsulates a group-level unit of work
    .description
    # See: BenchPress\Measure-Benchmark for params
    .link
        BenchPress\Measure-Benchmark
    #>
    [bool]$Enabled
    [string]$Name
    [bool]$AsJob   = $true
    [uint]$RepeatCount = 3
    # [Management.Automation.ActionPreference]$CommandErrorActionPref = 'Continue'
    # [Collections.IDictionary]$Technique = @{}

    # [Collections.IDictionary]$Parameter = @{}

    # If set, will provide detailed output, containing average runtimes, minimums, and maximums.
    # [bool]$Detailed

}
class BenchGroupDefinition {
    <#
    .synopsis
        encapsulates a group-level unit of work
    .description
    # See: BenchPress\Measure-Benchmark for params
    .link
        BenchPress\Measure-Benchmark
    #>
    [bool]$Enabled
    [string]$Name
    [bool]$AsJob   = $true
    [uint]$RepeatCount = 3
    [Management.Automation.ActionPreference]$CommandErrorActionPref = 'Continue'
    [Collections.IDictionary]$Technique = @{}

    [Collections.IDictionary]$Parameter = @{}

    # If set, will provide detailed output, containing average runtimes, minimums, and maximums.
    # [bool]$Detailed

}

function Benchy.NewTechniqueGroup {
    param(
        # [switch]$Enabled,
        [string]$Name,

        [switch]$NotAsJob,

        [uint]$RepeatCount = 2,
        [Management.Automation.ActionPreference]$CommandErrorActionPref = 'Continue',
        [Collections.IDictionary]$Technique = @{},

        [Alias('PropertyBag', 'Bag', 'Vars', 'Define')][Collections.IDictionary]$Params = @{}
    )

    write-host -fore 'orange' 'rewrite left off
    rework as

[BenchGroupDefinition] : covers core test logic
[BenchGroupRule] : covers whether it''s going to run, or disabled
    maybe, just maybe, also lets you configure parameters passed to the same tests?
    '
    return

    $params = @{} + $PSBoundParameters
    $Params = @{
        AsJob = -not ($PSBoundParameters)?.NotAsJob ?? $true
        Enabled = ($PSBoundParameters)?.Enabled
    }

    # Measure-Benchmark -AsJob:$AsJob -ea 'ignore' -Group 'Loop' -RepeatCount $RepeatCount -Technique @{
    # }
}

Export-ModuleMember -Function @(
    'Benchy.*'
    '*-Bench*'
) -Alias @(
    'Benchy.*'
    '*-Bench*'
) -Variable @(
    'Benchy_*'
)
