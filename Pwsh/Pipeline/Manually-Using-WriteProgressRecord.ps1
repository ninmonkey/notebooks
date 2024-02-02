using namespace System.Collections.Generic
using namespace System.Management.Automation
using namespace System.Text


[ProgressRecordType]|fime
[ProgressRecord]::new( 9099, 'nin', 'desc' ) | Ft -auto

function DoProg {
    [cmdletBinding()]
    param(

    )
    process {
        $ActivityId = 9099
        $activity = 'ninList'
        $statusDescription = 'Doing Item stuff'
        $pr = [ProgressRecord]::new(
            <# activityId: #> $activityId,
            <# activity: #> $activity,
            <# statusDescription: #> $statusDescription)
        $pr.RecordType  = [ProgressRecordType]::Processing
        $PSCmdlet.WriteProgress($pr)
        sleep 0.6


        $pr.RecordType  = [ProgressRecordType]::Completed
        $PSCmdlet.WriteProgress($pr)

    }
    end {

    }
}

DoProg
