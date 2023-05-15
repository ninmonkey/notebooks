#Requires -Version 7.0

BeforeAll { # cleanup examples 2023-05-08
    Remove-Module 'Pipeworks', 'Pansies' -ea 'ignore' # -Force # -ea ignore
    # $PesterPreference = 'Diagnostic' #  'Detailed', 'Diagnostic', 'Minimal', 'None', 'Normal'
    $PesterPreference = 'Minimal'
}
Describe 'Write-Host overlapping features' {
    BeforeEach {
        # redundant probably, but it's pester scoping so I don't know for sure.
        Remove-Module 'Pipeworks', 'Pansies' -ea 'ignore' # -Force # -ea ignore
    }
    It 'VersionTest' {
        { Import-Module -PassThru 'pansies' | Write-Host -ea 'stop' } | Should -Not -Throw
        { Import-Module -PassThru 'Pipeworks' | Write-Host -ea 'stop' } | Should -Not -Throw

    }

    Context 'm.p.u\Write-Host' {
        BeforeAll {
            # redundant probably, but it's pester scopes so beware
            Remove-Module 'Pipeworks', 'Pansies' -ea 'ignore' # -Force # -ea ignore
        }
        It 'Pipe: DoesNotThrow' {
            { 'hi world' | Microsoft.PowerShell.Utility\Write-Host -ea stop | Out-Null } | Should -Not -Throw #-Because 'implicit match else guard would be nice.'
        }
        It 'NicerErrorLog: Param: -FgColor: Orange' {
            try {
                'hi world' | Microsoft.PowerShell.Utility\Write-Host -fg orange -ea stop
                Set-ItResult -Because 'Parameterset does not (currently) have a matching parameterset in 7.3'
            }
            catch {
                Set-ItResult -Pending -Because 'Parameterset does not (currently) have a matching parameterset in 7.3'
            }
            $true
        }
        It 'Param: -FgColor: Orange' {
            { 'hi world' | Microsoft.PowerShell.Utility\Write-Host -fg orange -ea stop } | Should -Not -Throw # -Because 'implicit match else guard would be nice.'
            Set-ItResult -Pending -Because 'Parameterset does not (currently) have a matching parameterset in 7.3'


        }

    }

    Context 'Pansies\Write-Host' {
        BeforeAll {
            # redundant probably, but it's pester scopes so beware
            Remove-Module 'Pipeworks', 'Pansies' -ea 'ignore' # -Force # -ea ignore
            Import-Module Pansies
        }
        It 'Pipe: DoesNotThrow' {
            { 'hi world' | pansies\Write-Host -ea stop } | Should -Not -Throw #-Because 'implicit match else guard would be nice.'
        }
        It 'Param: -FgColor: Orange' {
            { 'hi world' | pansies\Write-Host -fg orange -ea stop } | Should -Not -Throw # -Because 'implicit match else guard would be nice.'
        }

    }

    Context 'pipeworks\Write-Host' {
        BeforeAll {

            Remove-Module 'Pipeworks', 'Pansies' -ea 'ignore' # -Force
            Import-Module Pipeworks -PassThru
        }
        It 'Pipe: DoesNotThrow' {
            { 'hi world' | Pipeworks\Write-Host -ea stop } | Should -Not -Throw #-Because 'implicit match else guard would be nice.'
        }
        It 'Param: -FgColor: Orange' {
            { 'hi world' | Pipeworks\Write-Host -fg orange -ea stop } | Should -Not -Throw # -Because 'implicit match else guard would be nice.'
        }

    }

}