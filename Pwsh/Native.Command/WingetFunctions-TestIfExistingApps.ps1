function WinGet.GetList {
    <#
    .SYNOPSIS
        gets the list of all currently installed apps, exports as json
    #>
    param(
        # [Parameter()]$x
        [switch]$IncludeVersion,
        [string]$ExportPath = 'g:\temp\winget.export.json',
        [switch]$OpenLogs,
        [switch]$EnableInteractive,
        [switch]$VerboseLogs,
        [switch]$Wait,
        [switch]$Cached
    )
    $WingetArgs = @(
        'export'
        '-o'
        $ExportPath
        if( $IncludeVersion ) { '--include-versions' }
        if( $OpenLogs ) { '--open-logs' }
        if( -not $EnableInteractive ) { '--disable-interactivity' }
        if( $VerboseLogs ) { '--verbose-logs' }
        if( $Wait ) { '--wait' }

    )
    if( -not $Cached ) {
        winget @wingetArgs
    }
    "wrote: '$ExportPath'" | write-host
}

function ListApps {
    <#
    .SYNOPSIS
        List apps. defaults to using a cached list, use force to override
    #>
    param(
        [string]$Path = 'g:\temp\winget.export.json',
        # Do you want to force the reload?
        [switch]$ForceLoad
    )
    if( $ForceLoad ) {
        WinGet.GetList -ExportPath $Path -Cached:$false
    }
    $data = get-content 'g:\temp\winget.export.json' | ConvertFrom-Json
    $rawNames = $Data.Sources.Packages.PackageIdentifier | Sort-Object -Unique
    return $rawNames
}

function FindAppsToRemove {
    <#
    .synopsis
        which of the apps that are wanted, are actually installed?
    #>
    param(
        [string[]]$AppsToRemove,
        [switch]$ForceLoad
    )
    $existing = ListApps -ForceLoad:$ForceLoad
    $installed = $AppsToRemove | ?{
        $curName = $_
        $curName -in @( $existing )
    }
    return $installed
}
# code -g 'g:\temp\winget.export.json'
# code -g 'g:\temp\winget2.json'

$ToRemoveList = @(
    '7zip.7zip'
    'Microsoft.PowerToys'
    'Microsoft.SQLServer2012NativeClient'
    'Microsoft.SQLServer2023NativeClient'
)
return

# example use
ListApps
FindAppsToRemove $toRemoveList




WinGet.GetList -IncludeVersion -ExportPath 'g:\temp\winget2.json' -OpenLogs -EnableInteractive -VerboseLogs -Wait
