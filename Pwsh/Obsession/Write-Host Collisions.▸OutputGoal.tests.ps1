#Requires -Version 7.0

BeforeAll { # compare output 2023-05-08
    # Push-Location $PSScriptRoot
    $global:Error.Clear()
    $Uni = @{
        NullStr = "`u{2400}"
    }
    Remove-Module 'Pipeworks', 'Pansies' -ea 'ignore'
    $Config = @{ DisplayEnvInfo = $true }
    function dumpEnvInfo {

        param(
            [string]$excludedModulesRegex = '(^microsoft.*)|(^PowerShellEditor(Services|suite))|^EditorServices|^ugit'
        )
        @(
            'about: Demonstrates how conditions render differently.'
            'Pwsh: {0}' -f $PSVersionTable.PSVersion.ToString()
            # 'PesterPreference: {0}' -f ( $PesterPreference ?? $Uni.NullStr )
            # 'global: PesterPreference: {0}' -f ( $global:PesterPreference ?? $Uni.NullStr )
            ''
            Get-Module
            | Where-Object Name -NotMatch $excludedModulesRegex
            | Sort-Object name
            | Join-String -sep ', ' { $_.Name, $_.Version -join ' = ' } #-single

        ) | Join-String -sep "`n" | Write-Host
    }

    if ($Config.DisplayEnvInfo) {
        dumpEnvInfo
    }


}
<#
    showing the variations that are output to console
#>
Describe 'ModuleA' {
    BeforeAll {
        $global:__originalPath = Get-Location
        Push-Location $PSScriptRoot -ea 'stop' -StackName 'npest'
        $PesterPreference = 'diagnostic' # not taking effect
        $PesterPreference = 'minimal' # not taking effect
        'PesterPreference: {0}' -f ( $PesterPreference ?? $Uni.NullStr )
        'global: PesterPreference: {0}' -f ( $global:PesterPreference ?? $Uni.NullStr )
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
    AfterAll {
        Pop-Location -StackName 'npest'
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
