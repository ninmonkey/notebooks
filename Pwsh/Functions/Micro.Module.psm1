$script:ModConfig = @{
    ExitEarly = $True
}
function Private.Init {
    'module::Init' | write-verbose -verbose
    'toggle exitting early by setting: $ENV:ModConfigDisableEarlyExit = 1' | Write-Verbose -verbose

    $Script:ModConfig.StartTime = Get-Date

    if( $ENV:ModConfigDisableEarlyExit ) {
        $Script:ModConfig.ExitEarly = $false
    }

}
function Mod.Status {
    'module::Status' | write-verbose -verbose

    'elapsed: {0}' -f @(
        (get-date) - $script:ModConfig.StartTime
    )
}


Export-ModuleMember -Function @(
    'Mod.Status'
)

Private.Init

if( $script:ModConfig.ExitEarly ) {
    write-verbose -verbose 'Module::exit early'
    return
}

write-verbose -verbose 'Module::ReachedEnd'

