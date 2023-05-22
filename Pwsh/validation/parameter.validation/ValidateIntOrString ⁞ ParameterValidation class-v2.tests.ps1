<#
 New settings in
    5.2: <https://pester.dev/docs/commands/New-PesterConfiguration>
        old config: <https://pester.dev/docs/usage/configuration>
    5.3: <https://pester.dev/docs/usage/output#stacktraceverbosity>
    5.4: <https://pester.dev/docs/usage/output#rendermode>

Stack Verbosity
    None, FirstLine, Filtered (default), Full

CIFormat

    None, Auto (default), AzureDevops, GithubActions

RenderMode
    Auto (default), ANSI, ConsoleColor, PlainText


#>


$pref = $PesterPreference = [PesterConfiguration]::Default
$PesterPreference.Debug.WriteDebugMessages = $false
$PesterPreference.Output.Verbosity = 'None'



BeforeAll {
    $PSStyle.OutputRendering = 'ansi'

    # share the same class name, stripping revisions off.
    $Src = $PSCommandPath -replace '-v\d+\.tests\.ps1', '.ps1'
    . (Get-Item -ea stop $Src)
    '::imported' | Write-Host -fore green
}

Context 'Parent' {
    Describe 'ValidatingIntOrString <Value> as <ExpectType>' -ForEach @(
        @{
            Exp         = { [ValidateStringOrInt()]$SomeInt = 123; $SomeInt }
            ExpectType  = 'int'
            Value       = 123
            ShouldThrow = $false
        }
        @{
            Exp         = { [ValidateStringOrInt()]$someKind = 123 ; $someKind }
            ExpectType  = 'int'
            Value       = 123
            ShouldThrow = $false
        }
        @{
            Exp         = { [ValidateStringOrInt()]$someKind = '123' ; $someKind }
            ExpectType  = 'string'  #  can I auto-assert as int
            Value       = '123'
            ShouldThrow = $false
        }
        @{
            Exp         = { [ValidateStringOrInt()]$someKind = '123.4' ; $someKind }
            ExpectType  = 'string'
            Value       = '123.4'
            ShouldThrow = $false
        }
        @{
            Exp         = { [ValidateStringOrInt()]$someKind = $null ; $someKind }
            ShouldThrow = $true
        }
        @{
            Exp         = { [ValidateStringOrInt()]$someKind = ''; $someKind }
            ExpectType  = 'string'
            Value       = ''
            ShouldThrow = $false # unless I want blanks. for now allow it.
        }
    ) {
        It 'is <Value>' {
            & $Exp | Should -Be $Value
        }

        It 'If ShouldThrow <ShouldThrow> and isType <Value>' {
            if ($ShouldThrow) {
                Set-ItResult -Skipped -Because 'WouldHaveThrown, ie: no value.'
                return # appears to ignore later Should statements, so, maybe redundant?
            }
            & $Exp | Should -BeOfType $ExpectType
        }

    }
}