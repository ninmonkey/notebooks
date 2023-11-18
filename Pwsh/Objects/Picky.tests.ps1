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
}