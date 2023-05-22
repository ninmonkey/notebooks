BeforeAll {
    $PSStyle.OutputRendering = 'ansi'

    $Src = $PSCommandPath -replace '\.tests\.ps1', '.ps1'
    . (Get-Item -ea stop $Src)
    '::imported' | Write-Host -fore green
}

Describe 'ValidateIntStringFlat <Value>' -ForEach @(
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