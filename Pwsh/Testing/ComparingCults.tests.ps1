describe 'thing' {
    It '<Render> is <Expected>' -foreach @(
        @{
            In = 1000
            Expected = '1,000'
            FStr = 'n0'
            Cult = 'en-us'
        }
        @{
            In = 1000
            Expected = '1,000.00'
            FStr = 'n'
            Cult = 'en-us'
        }
        @{
            In = 1000
            Expected = '1.000,0'
            FStr = 'n1'
            Cult = 'de-de'
        }
    ) -Test {
        $cult = Get-Culture $Cult
        $In.ToString($FStr, $Cult) | Should -BeExactly $Expected
    }
}
