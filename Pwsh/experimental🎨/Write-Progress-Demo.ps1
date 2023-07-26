$script:limitSize = 4
$script:sleepMS = 100
function EnumerateItems1 {
     $Items = @( $Input  | Select -first $LimitSize)
     $Items.count
     $items
         | %{
              "iter: $_" | write-host -bg 'darkyellow'
              $_
              Write-Progress -id 0 -Activity "act $_"
              sleep -ms $SleepMS
         }

}
function EnumerateItems2 {
     $Items = @( $Input  | Select -first $LimitSize)
     $Items.count
     $items
         | %{
              $_
              Write-Progress -id 0 -Activity "act $_"
              sleep -ms $SleepMS
         }

}
function EnumerateItems3 {
     $Items = @( $Input  | Select -first $LimitSize)
     $Items.count
     $items
         | %{
              Write-Progress -id 0 -Activity "act $_"
              sleep -ms $SleepMS
         }

}

function RunDemo {
    <#
    .synopsis
        quickly view and test different write-progress functions, controlling delay
        RunDemo 3 -SleepMS 600
        RunDemo 3, 1
        RunDemo 1 -Max 30 -SleepMS 100
        RunDemo 1, 2, 3 -Max 30 -SleepMS 1
    #>
    [CmdletBinding()]
    param(
        # mode[s] to preview
        [ValidateSet(
            '1','2','3','4' )]
        [Parameter(Mandatory, Position=0)]
        [string[]]$OutputType,

        # Optionally pass your own inputs
        [Parameter(ValueFromPipeline)]
        [object[]]$InputObject,

        [ArgumentCompletions(
            '100', '150', '300', '500')]
        [Parameter()]
        [alias('MS')]
        [int]$SleepMS = 150,

        [ArgumentCompletions(
            '3', '8', '40')]
        [Parameter()]
        [alias('Max')]
        [int]$LimitMaxResults = 5
    )
    $script:limitSize = $LimitMaxResults
    $script:sleepMS = $SleepMS

    Join-String -op 'Running demos: ' -sep ', ' -Inp $OutputType

    # if( $MyInvocation.ExpectingInput

    # if($Null -eq $InputObject){
    #     $sample = Get-Module
    # } else {
        $sample = @(  $InputObject )
    # }

    switch($OutputType) {
        { $true } { hr -ExtraLines 2 -fg 'gray50' }
        '1' { $Sample | EnumerateItems1 }
        '2' { $Sample | EnumerateItems2 }
        '3' { $Sample | EnumerateItems3 }
        '4' { $Sample | EnumerateItems4 }
        default { }
    }
}

@'
Usage:
    RunDemo 3 -SleepMS 600
    RunDemo 3, 1
    RunDemo 1 -Max 30 -SleepMS 100
    RunDemo 1, 2, 3 -Max 30 -SleepMS 1
'@

# hr -fg Magenta
# Get-Module | EnumerateItems2
# hr -fg Magenta
# Get-Module | EnumerateItems3