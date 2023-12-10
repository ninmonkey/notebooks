$CommandName = 'pwsh'
@'
Outputs:

# grouped


GroupName          Technique                                                 Throughput RelativeSpeed Time
---------          ---------                                                 ---------- ------------- ----
Missing_EaIgnore   Get-Command: Kind: ApplicationInfo -All | Select -first 1    1044.06          1.00 00:00:00.0019156
Missing_EaIgnore   Get-Command: Kind: ApplicationInfo                           1003.01          1.04 00:00:00.0019940
Missing_EaIgnore   Get-Command: Kind: ApplicationInfo, TotalCount: 1             758.81          1.38 00:00:00.0026357
Missing_EaIgnore   Get-Command: Kind: ApplicationInfo -All                       734.05          1.42 00:00:00.0027246
Missing_EaIgnore   ExContext: GetCommand_QuitOnFirst                             613.40          1.70 00:00:00.0032605
Missing_EaIgnore   Get-Command: Kind: ApplicationInfo | Select -first 1          137.22          7.61 00:00:00.0145752
Missing_EaIgnore   ExContext: GetCommandName_WithoutPattern                       46.92         22.25 00:00:00.0426222
Missing_EaIgnore   ExContext: GetCommands_IsApplication_withoutPattern            44.80         23.31 00:00:00.0446440
Missing_EaIgnore   ExContext: GetCommandName_WithoutPattern_ReturnFull            38.21         27.32 00:00:00.0523393
Missing_EaContinue Get-Command: Kind: ApplicationInfo                           1029.71          1.00 00:00:00.0019423
Missing_EaContinue Get-Command: Kind: ApplicationInfo -All | Select -first 1     995.42          1.03 00:00:00.0020092
Missing_EaContinue Get-Command: Kind: ApplicationInfo -All                       852.51          1.21 00:00:00.0023460
Missing_EaContinue ExContext: GetCommand_QuitOnFirst                             651.21          1.58 00:00:00.0030712
Missing_EaContinue Get-Command: Kind: ApplicationInfo, TotalCount: 1             628.18          1.64 00:00:00.0031838
Missing_EaContinue Get-Command: Kind: ApplicationInfo | Select -first 1          186.06          5.53 00:00:00.0107494
Missing_EaContinue ExContext: GetCommandName_WithoutPattern_ReturnFull            48.59         21.19 00:00:00.0411579
Missing_EaContinue ExContext: GetCommands_IsApplication_withoutPattern            45.21         22.77 00:00:00.0442355
Missing_EaContinue ExContext: GetCommandName_WithoutPattern                       43.05         23.92 00:00:00.0464547


# all


GroupName          Technique                                                 Throughput RelativeSpeed Time
---------          ---------                                                 ---------- ------------- ----
Missing_EaIgnore   Get-Command: Kind: ApplicationInfo -All | Select -first 1    1044.06          1.00 00:00:00.0019156
Missing_EaIgnore   Get-Command: Kind: ApplicationInfo                           1003.01          1.04 00:00:00.0019940
Missing_EaIgnore   Get-Command: Kind: ApplicationInfo, TotalCount: 1             758.81          1.38 00:00:00.0026357
Missing_EaIgnore   Get-Command: Kind: ApplicationInfo -All                       734.05          1.42 00:00:00.0027246
Missing_EaIgnore   ExContext: GetCommand_QuitOnFirst                             613.40          1.70 00:00:00.0032605
Missing_EaIgnore   Get-Command: Kind: ApplicationInfo | Select -first 1          137.22          7.61 00:00:00.0145752
Missing_EaIgnore   ExContext: GetCommandName_WithoutPattern                       46.92         22.25 00:00:00.0426222
Missing_EaIgnore   ExContext: GetCommands_IsApplication_withoutPattern            44.80         23.31 00:00:00.0446440
Missing_EaIgnore   ExContext: GetCommandName_WithoutPattern_ReturnFull            38.21         27.32 00:00:00.0523393
Missing_EaContinue Get-Command: Kind: ApplicationInfo                           1029.71          1.00 00:00:00.0019423
Missing_EaContinue Get-Command: Kind: ApplicationInfo -All | Select -first 1     995.42          1.03 00:00:00.0020092
Missing_EaContinue Get-Command: Kind: ApplicationInfo -All                       852.51          1.21 00:00:00.0023460
Missing_EaContinue ExContext: GetCommand_QuitOnFirst                             651.21          1.58 00:00:00.0030712
Missing_EaContinue Get-Command: Kind: ApplicationInfo, TotalCount: 1             628.18          1.64 00:00:00.0031838
Missing_EaContinue Get-Command: Kind: ApplicationInfo | Select -first 1          186.06          5.53 00:00:00.0107494
Missing_EaContinue ExContext: GetCommandName_WithoutPattern_ReturnFull            48.59         21.19 00:00:00.0411579
Missing_EaContinue ExContext: GetCommands_IsApplication_withoutPattern            45.21         22.77 00:00:00.0442355
Missing_EaContinue ExContext: GetCommandName_WithoutPattern                       43.05         23.92 00:00:00.0464547
'@
h1 (Join-String -f 'File: {0}' -in $PSCommandPath)
function Measure.Group {
    [CmdletBinding()]
    param(
        [ValidateNotNullOrWhiteSpace()]
        [Alias('Label')]
        [string]$GroupName,

        [ValidateNotNullOrWhiteSpace()]
        [string]$CommandName,

        [int]$RepeatCount = 2,

        [Management.Automation.ActionPreference]$CommandErrorActionPref = 'Continue',
        [switch]$AsJob = $true
    )


    Measure-Benchmark -AsJob:$AsJob -ea 'ignore' -Group $GroupName -RepeatCount $RepeatCount -Technique @{
        'ExContext: GetCommand_QuitOnFirst' = {
            $ExecutionContext.InvokeCommand.GetCommand(
                <# commandName: #> $CommandName,
                <# type: #> 'Application' )
        }
        'ExContext: GetCommandName_WithoutPattern' = {
            $ExecutionContext.InvokeCommand.GetCommandName(
                <# name: #> $CommandName,
                <# nameIsPattern: #> $false,
                <# returnFullName: #> $false )
        }
    # }
    # Measure-Benchmark -Group B -ov 'ovResultsB' -RepeatCount 2 -Technique @{
        'ExContext: GetCommandName_WithoutPattern_ReturnFull' = {
            $ExecutionContext.InvokeCommand.GetCommandName(
                <# name: #> $CommandName,
                <# nameIsPattern: #> $false,
                <# returnFullName: #> $true )
        }
        # 'GetCommands_WithoutPattern_ReturnFull' = {
        'ExContext: GetCommands_IsApplication_withoutPattern' = {
            $ExecutionContext.InvokeCommand.GetCommands(
                <# name: #> $CommandName,
                <# commandTypes: #> 'Application',
                <# nameIsPattern: #> $false)
        }
        'Get-Command: Kind: ApplicationInfo' = {
            $getCommandSplat = @{ ErrorAction = $CommandErrorActionPref; CommandType = 'Application'; Name = $CommandName }
            Get-Command @getCommandSplat
        }

        'Get-Command: Kind: ApplicationInfo, TotalCount: 1' = {
            $getCommandSplat = @{ ErrorAction = $CommandErrorActionPref; CommandType = 'Application'; Name = $CommandName }
            Get-Command @getCommandSplat -CommandType Application $CommandName -TotalCount 1
        }
        'Get-Command: Kind: ApplicationInfo | Select -first 1' = {
            $getCommandSplat = @{ ErrorAction = $CommandErrorActionPref; CommandType = 'Application'; Name = $CommandName }
            Get-Command @getCommandSplat -CommandType Application $CommandName
                | Select -first 1
        }
        'Get-Command: Kind: ApplicationInfo -All' = {
            $getCommandSplat = @{ ErrorAction = $CommandErrorActionPref; CommandType = 'Application'; Name = $CommandName }
            Get-Command @getCommandSplat -CommandType Application $CommandName -All
        }
        'Get-Command: Kind: ApplicationInfo -All | Select -first 1' = {
            $getCommandSplat = @{ ErrorAction = $CommandErrorActionPref; CommandType = 'Application'; Name = $CommandName }
            Get-Command @getCommandSplat -CommandType Application $CommandName -All
                | Select -first 1
        }
    } | sort-Object Time -desc
}

'starting jobs...' | write-host -back 'blue'
$results =  @(
    # Measure.Group -AsJob -GroupName 'Exists' -CommandName 'pwsh' -CommandErrorActionPref 'Continue'
    Measure.Group -AsJob -GroupName 'Exists' -CommandName 'pwsh'
    Measure.Group -AsJob -GroupName 'Missing' -CommandName 'missing'

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
