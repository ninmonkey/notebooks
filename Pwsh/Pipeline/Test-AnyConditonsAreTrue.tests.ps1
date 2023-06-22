BeforeAll {
    . (Get-Item -ea 'stop' ($PSCommandPath -replace '\.tests\.ps1$', '.ps1'))
    Get-Command 'Test-Any*' | Sort-Object | Format-Table -auto
}

Describe 'Test-AnyTrueCommands' {
    Context 'Test-AllTrue' {
        It '<Inputs> is <Expected>' -ForEach @(
            @{
                Inputs = $true, $true, $false
                Expected = $false
            }
            @{
                Inputs = ''
                Expected = $false
            }
            @{
                Inputs = $false, $null, $true
                Expected = $false
            }
            @{
                Inputs = @()
                Expected = $false
            }
        ) {
            $Inputs | Test-AllTrue | Should -Be $Expected
        }
    }
    Context 'Test-AnyTrue' {
        It '<Inputs> is <Expected>' -ForEach @(
            @{
                Inputs = $true, $true, $false
                Expected = $true
            }
            @{
                Inputs = ''
                Expected = $false
            }
            @{
                Inputs = $false, $null, $true
                Expected = $true
            }
            @{
                Inputs = @()
                Expected = $false
            }
        ) {
            $Inputs | Test-AnyTrue | Should -Be $Expected
        }
    }
    Context 'Test-AnyFalse' {
        It '<Inputs> is <Expected>' -ForEach @(
            @{
                Inputs = $true, $true, $false
                Expected = $true
            }
            @{
                Inputs = ''
                Expected = $false
                Because = 'depends on how you want to coerce it'
            }
            @{
                Inputs = $null, $true
                Expected = $false
                Because = 'depends on how you want to coerce it'
            }
            @{
                Inputs = @()
                Expected = $false
                Because = 'depends on how you want to coerce it'
            }
        ) {
            $Inputs | Test-AnyFalse | Should -Be $Expected
        }
    }
}