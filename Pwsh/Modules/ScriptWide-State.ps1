[hashtable]$script:CachedValue = @{}
[hashtable]$script:AppConfig = @{
    Log = Join-Path 'temp:' 'foo.log'
    # ... other app-wite properties
}
function CachedGetCommand {
    [CmdletBinding()]
    param( [string]$CommandName, [switch]$Force )
    $state =  $script:CachedValue
    $start = [Datetime]::Now

    if($Force -or ( -not $state.ContainsKey( $CommandName ) )) {
        'fetching....' | write-verbose -verbose
        $query = Get-Command -CommandType Application -Name $CommandName -TotalCount 1
        if( -not $query) {  return }
        $state[ $CommandName ] = $query
    }

    $delta = [Datetime]::Now - $Start
    'Lookup {0} took {1}' -f @(
        $CommandName
        [Datetime]::Now - $Start | Join-string -f '{0:n2} ms' TotalMilliseconds
    ) | Write-Verbose

    $state[ $CommandName ]
}
function LogIt {
    param(
        $InputObject,

        [ArgumentCompletions('Error', 'Warning', 'Info')]
        [string]$Severity,

        [switch]$PassThru
    )
    process {
        $Now = Get-Date
        $InputObject
            | ConvertTo-JSon -depth 4 -compress
            | Join-String -f "${now}: ${Severity}: "
            | Add-Content -Path $Script:AppConfig.Log -PassThru:$PassThru
    }
}


    CachedGetCommand 'pwsh' -Verbose -Force
    CachedGetCommand 'pwsh' -Verbose
    CachedGetCommand 'pwsh' -Verbose

###
LogIt -in 'App Init...' -Severity Info

#
gc (gi $script:AppConfig.Log)
