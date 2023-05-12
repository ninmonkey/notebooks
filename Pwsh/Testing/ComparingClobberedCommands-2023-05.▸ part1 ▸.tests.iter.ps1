BeforeAll {
    $requiredImport = @{
        DisableNameChecking = $true
        ErrorAction         = 'stop'
        PassThru            = $true
        SkipEditionCheck    = $true
    }
    <# expected:

    CommandType Name       Version  Source
    ----------- ----       -------  ------
    Function    Write-Host 1.9.9.41 pipeworks
    Cmdlet      Write-Host 2.6.0    pansies
    Cmdlet      Write-Host 7.0.0.0  Microsoft.PowerShell.Utility
    #>
    # Import-Module @requiredImport -Name Pester
    @(
        Import-Module @requiredImport -Name Pipeworks
        Import-Module @requiredImport -Name Pansies
    ) | Format-Table -AutoSize | oss | Out-Host
}
Describe 'Testing ClobberingWriteHost...' {
    BeforeAll {
        # future, do all permutations of which order each module is loaded
        $whost = Get-Command 'write-host' -All
        $Terror = @{ 'errorAction' = 'Stop' }
    }

    It 'Module <ModuleName> Should Not Throw' -ForEach @(
        @{
            Func     = Get-Command @Terror -Name 'Microsoft.PowerShell.Utility\Write-Host'
            InputObj = 'hi world'
            Params   = @{
                Fg = 'blue'
            }
        }
        @{
            Func     = Get-Command @Terror -Name 'Pipeworks\Write-Host'
            InputObj = 'hi world'
            Params   = @{
                Fg = 'blue'
            }
        }
    ) {
        {

            'hi world' | Write-Host

            # 'world' | & $whost[0] -fore green
            # 'world' | & $whost[1] -fore green
            # 'world' | & $whost[2] -fore green

            # 'world' | & $whost[0] -fg blue
            # 'world' | & $whost[1] -fg green
            # throw 'bad'
            # 'world' | & $whost[2] -fg green
        } | Should -Not -Throw


    }
}