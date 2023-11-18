BeforeAll {
    $ModPath = $PSCommandPath -replace '\.tests.ps1$', '.psm1'
    Import-Module -Force -PassThru $ModPath
       | Join-String -Prop { $_.Name, $_.Version -join ': ' }| out-host
    $ErrCountStart = $Error.Count
    $Error.Count
        | Join-String -f 'ErrCountStart: {0}'
        | write-host -back 'darkyellow'
}
AfterAll {
    'ErrCountEnd: {0} [ +{1} ]' -f @(
        $Error.Count
        $Error.Count - $ErrCountStart
    )
        | write-host -back 'darkyellow'
}

Describe 'Assert.Truthy' {
    it '<In> Test.Truthy <ShouldThrow> and IsTrue <IsTrue>' -foreach  @(
        @{
            In = @{} # empty is true
            ShouldThrow = $false
            IsTrue = $true
        }
        @{
            In = [ordered]@{} # empty is true
            ShouldThrow = $false
            IsTrue = $true
        }
        @{
            In = @() # empty is false
            ShouldThrow = $false
            IsTrue = $false
        }
        @{
            In = [Collections.Generic.List[object]]::new() # empty is false
            ShouldThrow = $false
            IsTrue = $false
        }
        @{
            In = $null
            ShouldThrow = $false
            IsTrue = $false
        }
        @{
            In = ''
            ShouldThrow = $false
            IsTrue = $False
        }
        @{
            In = ' '
            ShouldThrow = $false
            IsTrue = $true
        }

    ) {
        if($ShouldThrow) {
            { pk.Assert.Truthy -InputObject $In }
                | Should -Throw

        } else {
            { pk.Assert.NotTrueNull -InputObject $In }
                | Should -Not -Throw

        }

    }
}
Describe 'Assert.NotTrueNull' {
    it '<In> throws <ShouldThrow>' -foreach  @(
        @{
            In = @{}
            ShouldThrow = $false
        }
        @{
            In = $null
            ShouldThrow = $true
        }
        @{
            In = ''
            ShouldThrow = $false
        }
    ) {
        if($ShouldThrow) {
            { pk.Assert.NotTrueNull -InputObject $In }
                | Should -Throw

        } else {
            { pk.Assert.NotTrueNull -InputObject $In }
                | Should -Not -Throw

        }

    }
    it '<In> Alias is Bool and not throws <ShouldThrow>' -foreach  @(
        @{
            In = @{}
            ShouldThrow = $false
            Expected = $false
        }
        @{
            In = $null
            ShouldThrow = $false
            Expected = $true
        }
        @{
            In = ''
            ShouldThrow = $false
            Expected = $false
        }
    ) {
        if($ShouldThrow) {
            { pk.Test.NotTrueNull -InputObject $In }
                | Should -Throw
        } else {
            { pk.Test.NotTrueNull -InputObject $In }
                | Should -Not -Throw
        }
        $result = pk.Test.NotTrueNull -InputObject $In
        $result
            | Should -BeOfType ([bool])
        $result
            | Should -BeExactly $Expected



    }
}