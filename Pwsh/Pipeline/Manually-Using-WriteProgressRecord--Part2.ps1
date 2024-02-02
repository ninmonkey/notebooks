using namespace System.Collections.Generic
using namespace System.Management.Automation
using namespace System.Text


# [ProgressRecordType]|fime
# [ProgressRecord]::new( 9099, 'nin', 'desc' ) | Ft -auto
# 'see more:
# - <https://learn.microsoft.com/en-us/dotnet/api/system.management.automation.progressrecord?view=powershellsdk-7.4.0>
# '

$script:DbgInfo = @{}
function Test.ResetState {
    # reset to 0
    $state = $script:DbgInfo
    $State.CurNum   = 0
    $State.TotalNum = 1
}
function Test.State {
    # get it
    $state = $Script:DbgInfo
    return $state
}
function Test.RandomAdds {
    # add several to total
    param( [int]$Min =  3, [int]$Max = 8 )
    $state  = $script:DbgInfo
    $offset = Get-random -min $Min -max $Max
    $state.TotalNum += $Offset
}
function Test.IncrementCurrent {
    # add one to current
    $state = $script:DbgInfo
    $state.CurNum++
}
Test.ResetState
function Test.Work {
    param( $SleepSecs = 0.3 )
    Sleep -Seconds $SleepSecs
}

function DoProg {
    [cmdletBinding()]
    param(
        [Parameter()]
        $SecsDuration = 0.1, [hashtable]$Options = @{}
    )
    begin {
        $Config = nin.MergeHash -OtherHash $Options -BaseHash @{
            ActivityId                = 9099
            CompleteBeforeEnd         = $false
            IncrementMax              = 7
            IncrementWhileLooping     = $true
            Label                     = '[whoami]'
            WriteFinalCompletedRecord = $true
        }

        Test.ResetState
        Test.RandomAdds
    }
    process {
        # $PSCmdlet.MyInvocation.InvocationName
        #     | New-Text -fg 'orange'
        #     | write-information -infa 'continue'


        function HandleOne {
            param()
            $ActivityId = $Config.ActivityId
            # $activity = '{0} [whoami]' -f $PSCmdlet.MyInvocation.InvocationName
            #     # | New-text -fg 'gray80' -bg 'gray60'
            #     | New-text -fg 'gray60' -bg 'gray40'

            # blink is potentially getting stripped
            $activity = '{0} {1}' -f @(
                   $PSCmdlet.MyInvocation.InvocationName
                   $Config.Label
                )
                # | New-text -fg 'gray60' -bg 'gray40'
                # | Join-String -op $PSStyle.Blink
                # | Join-String -os $PSStyle.Reset

            $statusDescription = 'Cur: {0} of {1}' -f @(
                (Test.State).CurNum
                (Test.State).TotalNum
            )
            # $statusDescription = "Doing Item stuff`n`tsdfsdf`n"
            $pr = [ProgressRecord]::new(
                <# activityId: #> $activityId,
                <# activity: #>   $activity,
                <# statusDescription: #> $statusDescription)

            $pr.RecordType  = [ProgressRecordType]::Processing
            $PSCmdlet.WriteProgress($pr)

            Test.Work -SleepSecs $SecsDuration

            if($Config.CompleteBeforeEnd) {
                $pr.RecordType  = [ProgressRecordType]::Completed
                $PSCmdlet.WriteProgress($pr)
            }
        }

        Test.ResetState
        Test.RandomAdds -min 2 -Max 4

        while( (Test.State).CurNum -lt (Test.State).TotalNum ) {
                HandleOne
                Test.IncrementCurrent

                if(
                    ( (Test.State).TotalNum -lt $Config.IncrementMax) -and
                    ( (Get-Random -Minimum 0 -Maximum 3) -gt 0)
                ) {

                    Test.RandomAdds -min 1 -max 3
                }
                sleep $SecsDuration
        }

         if($Config.WriteFinalCompletedRecord) {
                # simplified
                $ActivityId = $Config.ActivityId; $Activity = ' ';  $StatusDescription = ' '
                $pr = [ProgressRecord]::new(<# activityId: #> $activityId)
                $pr.RecordType  = [ProgressRecordType]::Completed
                $PSCmdlet.WriteProgress($pr)

                # 'final clean'
                if($false) {
                    $ActivityId = $Config.ActivityId; $Activity = ' ';  $StatusDescription = ' '
                    $pr = [ProgressRecord]::new(
                        <# activityId       : #> $activityId,
                        <# activity         : #> $activity,
                        <# statusDescription: #> $statusDescription)

                    $pr.RecordType  = [ProgressRecordType]::Completed
                    $PSCmdlet.WriteProgress($pr)
                }
            }
    }
    end {

    }
}
# hr
# DoProg -sec .1
DoProg -sec .1 -Options @{
    CompleteBeforeEnd = $false
    Label = 'basic'
}

# this is flashy
DoProg -sec .1 -Options @{
    CompleteBeforeEnd = $true
    Label = 'flash'
}

# not flash
DoProg -sec .1 -Options @{
    CompleteBeforeEnd = $false
    Label = 'noflash'
}
