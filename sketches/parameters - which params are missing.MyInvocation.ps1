
function testParam {
    param(
        [Parameter()]
        [string]$Name,

        $NoType,
        $NoType_def = 'abc',

        [switch]$Stuff,
        [switch]$Stuff_def = 123,


        [hashtable]$Kwargs
    )
}

throw 'test params that are not passed, include PSDefaultParameters in the test'
$MyInvocation.MyCommand.Parameters.Keys | Where-Object { -not $PSBoundParameters.ContainsKey($_) }