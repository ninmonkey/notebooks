BeforeAll {
    $PSStyle.OutputRendering = 'ansi'

    $Src = $PSCommandPath -replace '\.tests\.ps1', '.ps1'
    . (Get-Item -ea stop $Src)
    '::imported' | Write-Host -fore green
}

Describe 'ValidateIntString' {
    It 'SafeTest' {
        { [ValidateStringOrInt()]$chars = 'abcd' } | Should -Not -Throw
    }
    It 'Expected <Value> as <ExpectType> where throwing is <IsThrow>' -ForEach @(
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