function Test-NumberInRange{
    <#
    .EXAMPLE
        Test-NumberInRange -in (0..4) -Start 2 -End 5
        0..4 | Test-NumberInRange -Start 2 -End 5
        0..4 | Test-NumberInRange 2 4

    #>
    [CmdletBinding(DefaultParameterSetName='FromPipe')]
    param(
        [Alias('InObj', 'Items')]
        [Parameter( Mandatory, ParameterSetName='FromPipe',  ValueFromPipeline )]
        [Parameter( Mandatory, ParameterSetName='FromParam', Position = 0 )]
        [ValidateNotNull()]
        [int32[]] $InputObject,

        [Alias('Start')]
        [Parameter( Mandatory, ParameterSetName='FromPipe',  Position = 0 )]
        [Parameter( Mandatory, ParameterSetName='FromParam', Position = 1 )]
        [ValidateNotNull()]
        [int32] $RangeStart,

        [Alias('End')]
        [Parameter( Mandatory, ParameterSetName='FromPipe',  Position = 1 )]
        [Parameter( Mandatory, ParameterSetName='FromParam', Position = 2 )]
        [ValidateNotNull()]
        [int32] $RangeEnd
    )
    process {
        # $PSBoundParameters | Json -Compress  | write-host -fg 'gray80' -bg 'gray50'
        foreach($Item in $InputObject) {
            if( $Item -ge $RangeStart -and $Item -le $RangeEnd ) {
                $Item
            }
        }
    }
}
