BeforeAll {
    Remove-Module 'Pipeworks', 'Pansies' -ea 'ignore'
    # $PesterPreference = 'minimal' # not currently taking effect

    @'
Demonstrate how each condition renders
'@

}
<#
    showing the variations that are output to console
#>
Describe 'ModuleA' {
    BeforeAll {
        $PesterPreference = 'diagnostic' # not taking effect
        $PesterPreference = 'minimal' # not taking effect
    }
    It 'Feature1' {
        $true | Should -Be $True
    }
    It 'Feature2' {
        $false | Should -Be $true
    }
    It 'Feature3' { # incl
        Set-ItResult -Inconclusive -Because 'reason3'
    }
    It 'Feature3-none' {
        Set-ItResult -Inconclusive
    }
    It 'Feature4' { # incl
        Set-ItResult -Pending -Because 'reason4'
    }
    It 'Feature4-none' {
        Set-ItResult -Pending
    }
    It 'Feature4' { # incl
        Set-ItResult -Skipped -Because 'reason5'
    }
    It 'Feature4-none' {
        Set-ItResult -Skipped
    }
}
Context 'Part2' {
    It 'True' {
        $true | Should -Be $True
    }
    It 'Should -BeExactly' {
        $now = Get-Date
        'a', 234, $now
        | Should -BeExactly @( 'a', 234, $now )
    }
    It 'Should -Be' {
        $now = Get-Date
        $now, $Now, 'a', 234, $now
        | Should -Be @( 'a', 234, $now )
    }
    It 'Should -BeIn' {
        'a', 234
        | Should -BeIn @( 'z', 'a', 100, 234)
    }
}
