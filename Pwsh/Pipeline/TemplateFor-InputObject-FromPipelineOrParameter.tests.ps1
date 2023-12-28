beforeAll {
    $DotPath = $PSCommandPath -replace '\.tests\.ps1', '.ps1'
    . $DotPath
}
Describe 'ParameterBindingDoesNotThrow' {
    it 'x | CollectList -Name Arg' {
        { 'a'..'e' | CollectList  -Label 'Arg' } | Should -Not -Throw
    }
    it 'x | CollectList Arg' {
        { 'a'..'e' | CollectList 'Arg' } | Should -Not -Throw
    }
    it 'x | CollectList' {
        { 'a'..'e' | CollectList } | Should -Not -Throw
    }

    # it 'stuff' -ForEach @(
    #     # $gci = Gci . |select -first 2| CollectList
    #     # $gci = CollectList -InputObject (gci . | select -First 1)
    #     # ' ', "`n", '', $null |   CollectList
    #     # 'a'..'e' | CollectList  'Arg'
    #     # 'a'..'e' | CollectList
    #     # CollectList -In ('a'..'e')
    #     # CollectList -In ('a'..'e') 'Arg'
    #     # CollectList -In ('a'..'e') -Label Stuff
    # ) -Test {

    # }

}
