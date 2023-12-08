
[hashtable]$script:___UserHasCommand = @{}
function Test-UserHasNativeCommand {
    <#
    .SYNOPSIS
        Tests if a native command is found, then caching results. const-time if it is cached
    .EXAMPLE
        Test-UserHasNativeCommand 'bat'
        Test-UserHasNativeCommand 'fd'

    .EXAMPLE
        Test-UserHasNativeCommand -All

    #>
    [Alias('HasNativeCmd')]
    [CmdletBinding(DefaultParameterSetName='FindOne')]
    param(
        [Parameter(Mandatory,parameterSetName='FindOne', Position=0)]
        [string]$CommandName,

        [Alias('All')]
        [Parameter(ParameterSetName='ListAll')]
        [switch]$PassThru
    )
    $state = $script:___UserHasCommand
    switch($PSCmdlet.ParameterSetName){
        'ListAll' {
            return $state
        }
        default {
            if( -not $state.ContainsKey( $CommandName )) {
                $state[ $CommandName ] =
                    [bool](Gcm -Name $CommandName -CommandType Application -ea 'ignore').count -gt 0
            }
            return $state[ $CommandName ]
        }
    }
}

@'
with this setup, these are all valid

    > HasNativeCmd -CommandName 'bat'
    > HasNativeCmd 'ls'
    > HasNativeCmd -ListAll

these are all invalid

    > HasNativeCmd -ListAll 'a'
    > HasNativeCmd 'a' -ListAll

'@
