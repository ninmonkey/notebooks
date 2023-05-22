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

    $Src = $PSCommandPath -replace '\.tests\.ps1', '.ps1'
    . (Get-Item -ea stop $Src)
    '::imported' | Write-Host -fore green
}

Describe 'ValidateIntString <Value> is <ExpectType>' -ForEach @(
    @{
        Exp         = { [ValidateStringOrInt()]$SomeInt = 123 }
        ExpectType  = 'int'
        Value       = 123
        ShouldThrow = $false
    }
    @{
        Exp         = { [ValidateStringOrInt()]$SomeInt = '123' }
        ExpectType  = 'int'  #  can I auto-assert as int
        Value       = '123'
        ShouldThrow = $false
    }
    @{
        Exp         = { [ValidateStringOrInt()]$SomeInt = '123.4' }
        ExpectType  = 'string'
        Value       = '123.4'
        ShouldThrow = $false
    }
    @{
        Exp         = { [ValidateStringOrInt()]$SomeInt = $null }
        ShouldThrow = $true
    }
    @{
        Exp         = { [ValidateStringOrInt()]$SomeInt = '' }
        ExpectType  = 'string'
        Value       = ''
        ShouldThrow = $false # unless I want blanks. for now allow it.
    }
) {
    It '<Value> is throwing? <ShouldThrow>' {
        $Exp | Should -Throw -Not:$(-not $ShouldThrow)
    }
    It 'NonThrow is like <Value> and -not <ShouldThrow>' {
        if ($ShouldThrow) {
            Set-ItResult -Skipped -Because 'WouldThrow'
            return # optional? Set result appears to ignore later asserts?
        }
        & $Exp | Should -Be $Value
    }
    It 'IsType? <ExpectType>' {
        $result = & $Exp
        $result | Should -BeOfType $ExpectType
    }
}


Describe 'ValidateIntStringFlat' {
    It 'SafeTest' {
        { [ValidateStringOrInt()]$chars = 'abcd' } | Should -Not -Throw
    }
    # It 'A Expected <Value> Exactly <ExpectType>' -ForEach @( Samples ) {
    It 'Expected <Value> as <ExpectType> where throwing is <ShouldThrow>' -ForEach @(
        @{
            Exp         = { [ValidateStringOrInt()]$someKind = 123 ; $someKind }
            ExpectType  = 'int'
            Value       = 123
            ShouldThrow = $false
        }
        @{
            Exp         = { [ValidateStringOrInt()]$someKind = '123' ; $someKind }
            ExpectType  = 'int'  #  can I auto-assert as int
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
        if ($ShouldThrow) {
            $Exp | Should -Throw
        }
        else {
            $Exp | Should -Not -Throw
        }
        # $Result = & $Exp
        # $Result | Should -BeExactly $Value
        # $Result | Should -BeOfType $ExpectType


    }


}

Describe 'Minipest <Value>' -ForEach @(
    # @{
    #     Exp         = { [ValidateStringOrInt()]$SomeInt = 123; $SomeInt }
    #     ExpectType  = 'int'
    #     Value       = 123
    #     ShouldThrow = $false
    # }
    @{
        Exp         = { [ValidateStringOrInt()]$someKind = 123 ; $someKind }
        ExpectType  = 'int'
        Value       = 123
        ShouldThrow = $false
    }
    @{
        Exp         = { [ValidateStringOrInt()]$someKind = '123' ; $someKind }
        ExpectType  = 'int'  #  can I auto-assert as int
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
