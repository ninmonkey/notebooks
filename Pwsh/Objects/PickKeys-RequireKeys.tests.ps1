BeforeAll {
    $ModPath = $PSCommandPath -replace '\.tests.ps1$', '.psm1'
    Import-Module -Force -PassThru $ModPath
    | Join-String | out-host
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