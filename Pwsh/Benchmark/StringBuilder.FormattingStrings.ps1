
#requires -Module Benchpress
@'
future:
    try: https://learn.microsoft.com/en-us/dotnet/api/system.iformattable?view=net-8.0
    more: https://learn.microsoft.com/en-us/dotnet/csharp/programming-guide/strings/

Outputs:


'@
goto $PSScriptRoot

err -clear
Import-Module (Join-Path $PSScriptRoot './nin.Benchmark.psm1') -force -PassThru
Benchy.NewTechniqueGroup -Name 'SingleItem' -RepeatCount 2 -Parameter @{} -Technique @{
   'foreach i.ToString()' = {
    foreach($i in 0..1mb) {
            $i.ToString()
        }
    }
    'foreach [string]i' = {
        foreach($i in 0..1mb) {
            [string]$i
        }
    }
    '{0} -f i' = {
        foreach($i in 0..1mb) {
            '{0}' -f $i
        }
    }
    '{0:n} -f i' = {
        foreach($i in 0..1mb) {
            '{0:n}' -f $i
        }
    }
    '{0:n0} -f i' = {
        foreach($i in 0..1mb) {
            '{0:n0}' -f $i
        }
    }
}

return


h1 (Join-String -f 'File: {0}' -in $PSCommandPath)
$Now = [Datetime]::Now

function Measure.Group {
    [CmdletBinding()]
    param(
        # [ValidateNotNullOrWhiteSpace()]
        # [Alias('Label')]
        # [string]$GroupName,

        # [ValidateNotNullOrWhiteSpace()]
        # [string]$CommandName,

        [int]$RepeatCount = 3,

        [Management.Automation.ActionPreference]$CommandErrorActionPref = 'Continue',
        [switch]$AsJob = $true,

        [hashtable]$TestsConfig = @{}
    )

    # if($TestsConfig.)

    Measure-Benchmark -AsJob:$AsJob -ea 'ignore' -Group 'Loop' -RepeatCount $RepeatCount -Technique @{

            'foreach i.ToString()' = {
                foreach($i in 0..1mb) {
                    $i.ToString()
                }
            }
            'foreach [string]i' = {
                foreach($i in 0..1mb) {
                    [string]$i
                }
            }
            '{0} -f i' = {
                foreach($i in 0..1mb) {
                    '{0}' -f $i
                }
            }
            '{0:n} -f i' = {
                foreach($i in 0..1mb) {
                    '{0:n}' -f $i
                }
            }
            '{0:n0} -f i' = {
                foreach($i in 0..1mb) {
                    '{0:n0}' -f $i
                }
            }
    }


    Measure-Benchmark -AsJob:$AsJob -ea 'ignore' -Group 'NoLoop' -RepeatCount $RepeatCount -Technique @{
        '-f (Get-Date)' = {
            '{0}' -f (Get-Date)
        }
        '-f constant' = {
            '{0}' -f ($Now)
        }
        '-f 1gb' = {
            '{0}' -f 1gb
        }
        '(1gb).ToString()' = {
            (1gb).ToString()
        }
        '[string]1gb' = {
            [string]1gb
        }

    } | sort-Object Time -desc
}

$Config = @{
    GlobalRepeat = 1
    AlternateVerboseSummary = $false
}

function bench.AddRule {
    param( [string]$Name )
}
$TestsConfig = @{
    SkipGroups = @(
        'Loop'
        # 'NoLoop'
    )
    Rules = @(
        @{
            Group = 'NoLoop'
            Enabled = $false
        }
        @{
            Group = 'Loop'
            Enabled = $false
        }
    )


}
'starting jobs...' | write-host -back 'blue'
$results =
    @( Measure.Group -AsJob -RepeatCount $Config.GlobalRepeat -TestsConfig $TestsConfig )
        | Receive-Job -Wait -AutoRemoveJob

'$results[] = {0}' -f $Results.count

$results | Group GroupName  | %{
    hr
    h1 $_.Name
    $_.Group | ft -auto
}

hr -fg Magenta

h1 'All As One'
$results | ft -AutoSize  GroupName, Technique, Throughput, RelativeSpeed, Time

h1 'config'
$Config | ft -auto

if($Config.AlternateVerboseSummary){


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

}
