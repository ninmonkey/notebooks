Import-Module Pester

BeforeAll {
    Import-Module -Force (Join-Path $PSScriptRoot '../Mintils.psm1')
    throw 'finish tests'
}

Describe 'Test-IsBlank' {
    Context 'TrueNull' {
        It '"<Sample>" should be <Expected>' -ForEach @(
            @{
                Sample   = ''
                Expected = $true
                Strict   = $false
            }
            @{
                Sample   = ''
                Expected = $true
                Strict   = $true
            }
            @{
                Sample   = @()
                Expected = $true
                Strict   = $false
            }
            @{
                Sample   = @()
                Expected = $false
                Strict   = $true
            }
        ) {
            Test-IsBlank $Sample
                | Should -Be $Expected
        }
    }
}