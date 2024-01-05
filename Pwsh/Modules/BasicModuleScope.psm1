$script:Cache = @{}
$script:DefaultUser = $Null
function Get-NinModules {
    # caches module listing
    param()
    $state = $script:cache
    if( -not $state.ContainsKey('AllModules') ) {
        'not cached, please wait....' | write-host -fore 'yellow'
        $state.AllModules = Get-Module -ListAvailable | Sort-Object
    }
    return $state.AllModules
}

function Set-NinUser {
    param( [string]$Username)
    $script:DefaultUser = $UserName
}

Export-moduleMember -Function @(
    '*-Nin*'
)
