$CommandName = 'pwsh'
@'
Outputs:

# grouped

GroupName                               Technique        Throughput RelativeSpeed Time
---------                               ---------        ---------- ------------- ----
Get-Command: Kind: ApplicationInfo -All Continue               1.09          1.00 00:00:01.8283344
Get-Command: Kind: ApplicationInfo -All Stop                   1.07          1.02 00:00:01.8650516
Get-Command: Kind: ApplicationInfo -All SilentlyContinue       1.03          1.06 00:00:01.9405555
Get-Command: Kind: ApplicationInfo -All Ignore                 1.03          1.06 00:00:01.9417052


# all


GroupName                               Technique        Throughput RelativeSpeed Time
---------                               ---------        ---------- ------------- ----
Get-Command: Kind: ApplicationInfo -All Continue               1.09          1.00 00:00:01.8283344
Get-Command: Kind: ApplicationInfo -All Stop                   1.07          1.02 00:00:01.8650516
Get-Command: Kind: ApplicationInfo -All SilentlyContinue       1.03          1.06 00:00:01.9405555
Get-Command: Kind: ApplicationInfo -All Ignore                 1.03          1.06 00:00:01.9417052
'@

function Measure.ErrorActionPrefs {
    [CmdletBinding()]
    param(
        # [ValidateNotNullOrWhiteSpace()]
        # [Alias('Label')]
        # [string]$GroupName,

        [Parameter(Mandatory)]
        [Alias('Name')]
        [ValidateNotNullOrWhiteSpace()]
        [string]$CommandName = 'pwsh_not_exist',

        [int]$RepeatCount = 2
        # [switch]$AsJob
    )

    Measure-Benchmark -RepeatCount:$RepeatCount -AsJob:$True -GroupName 'Get-Command: Kind: ApplicationInfo -All' @{

        'Continue' = {
            $getCommandSplat = @{
                CommandType = 'Application'
                All         = $true
                # Name        = $using:CommandName
                Name = 'pwsh'
            }
            # 0..50 | %{
                gcm @getCommandSplat -ea 'Continue'
            # }
        }
        'Ignore' = {
            $getCommandSplat = @{
                CommandType = 'Application'
                All         = $true
                # Name        = $using:CommandName
                Name = 'pwsh'
            }
            # 0..50 | %{
                gcm @getCommandSplat -ea 'Ignore'
            # }
        }

        'SilentlyContinue' = {
            $getCommandSplat = @{
                CommandType = 'Application'
                All         = $true
                # Name        = $using:CommandName
                Name = 'pwsh'
            }
            # 0..50 | %{
                gcm @getCommandSplat -ea 'SilentlyContinue'
            # }
        }
        'Stop' = {
            $getCommandSplat = @{
                CommandType = 'Application'
                All         = $true
                # Name        = $using:CommandName
                Name = 'pwsh'
            }
            # 0..50 | %{
                gcm @getCommandSplat -ea 'Stop'
            # }
        }
    }
    # skip ones that don't make sense
        # 'Suspend' = {
        #     $getCommandSplat = @{
        #         CommandType = 'Application'
        #         All         = $true
        #         Name        = $using:CommandName
        #     }
        #     gcm @getCommandSplat -ea 'Suspend'
        # }
         # 'Break' = {
        #     $getCommandSplat = @{
        #         CommandType = 'Application'
        #         All         = $true
        #         Name        = $using:CommandName
        #     }
        #     gcm @getCommandSplat -ea 'Break'
        # }
        # 'Inquire' = {
        #     $getCommandSplat = @{
        #         CommandType = 'Application'
        #         All         = $true
        #         Name        = $using:CommandName
        #     }
        #     gcm @getCommandSplat -ea 'Inquire'
        # }
}
if($false -and 'other samples' ) {

    # Measure-Benchmark -AsJob:$AsJob -ea 'ignore' -Group $GroupName -RepeatCount $RepeatCount -Technique @{

    #     Get-Command @getCommandSplat
    # }
    # Measure-Benchmark -AsJob:$AsJob -ea 'ignore' -Group $GroupName -RepeatCount $RepeatCount -Technique @{

    #     'Get-Command: Kind: ApplicationInfo' = {
    #         $getCommandSplat = @{ ErrorAction = $CommandErrorActionPref; CommandType = 'Application'; Name = $CommandName }
    #         Get-Command @getCommandSplat
    #     }

    #     'Get-Command: Kind: ApplicationInfo, TotalCount: 1' = {
    #         $getCommandSplat = @{ ErrorAction = $CommandErrorActionPref; CommandType = 'Application'; Name = $CommandName }
    #         Get-Command @getCommandSplat -CommandType Application $CommandName -TotalCount 1
    #     }
    #     'Get-Command: Kind: ApplicationInfo | Select -first 1' = {
    #         $getCommandSplat = @{ ErrorAction = $CommandErrorActionPref; CommandType = 'Application'; Name = $CommandName }
    #         Get-Command @getCommandSplat -CommandType Application $CommandName
    #             | Select -first 1
    #     }
    #     'Get-Command: Kind: ApplicationInfo -All' = {
    #         $getCommandSplat = @{ ErrorAction = $CommandErrorActionPref; CommandType = 'Application'; Name = $CommandName }
    #         Get-Command @getCommandSplat -CommandType Application $CommandName -All
    #     }
    #     'Get-Command: Kind: ApplicationInfo -All | Select -first 1' = {
    #         $getCommandSplat = @{ ErrorAction = $CommandErrorActionPref; CommandType = 'Application'; Name = $CommandName }
    #         Get-Command @getCommandSplat -CommandType Application $CommandName -All
    #             | Select -first 1
    #     }
    # } | sort-Object Time -desc
# }
}

'starting jobs...' | write-host -back 'blue'
$results =  @(
    Measure.ErrorActionPrefs -CommandName 'pwsh_not_existing' -RepeatCount 2
)
    | Receive-Job -Wait -AutoRemoveJob

'$results {0}' -f @( $Results.Count ) | write-host -back 'blue'
# return

h1 'grouped'
$results | ft -AutoSize  GroupName, Technique, Throughput, RelativeSpeed, Time

h1 'all'
$results | ft -AutoSize  GroupName, Technique, Throughput, RelativeSpeed, Time
