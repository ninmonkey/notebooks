Describe 'stuff' {
    BeforeAll {
        # $files = ls c:\nin_temp -file -d 2
        # $folders = ls c:\nin_temp -folder -d 2
        $Samples = @(
            @{ Text = 'abc' ; Expected = 3}
            @{ Text = 'a' ; Expected = 1}
            @{ Text = 'a' ; Expected = 3}
        )
        # $law_rgname = $General.resource_group_name
        # $ResourceGroups = Get-AzResourceGroup
        # $ex = ($ResourceGroups | where ResourceGroupName -eq $law_rgname).ResourceGroupName
    }

    it 'sdf' -foreach @() {
        $_ | iot2 | write-host
        throw "fail"
    }

    Context "Resource Group tests" {
        BeforeAll {
            $Samples = @(
                @{ Text = 'z' ; Expected = 1}
                @{ Text = 'z' ; Expected = 9}
            )
        }

        it "Name <Text> Should be <Expected>" -foreach $samples {
            $Expected ??= 34
            # $_ | should -be 34
            $Text.length | Should -be $Expected

        }
    }
}

#     #Region LAW Resource Group Tests
#     It "The LAW resource Group [$law_rgname] created should be equal to: $($ResourceGroups[0].ResourceGroupName)" -foreach @(
#         @{
#             GroupName = $law_rgname
#         }
#     ) {
#     }

#     It "Tahe LAW resource Group [$law_rgname] created should be equal to: $($ResourceGroups[0].ResourceGroupName)" {
#         $ResourceGroups | where ResourceGroupName -eq $law_rgname | Should -Not -BeNullOrEmpty
#     }

#     It "The LAW resource Group [$law_rgname] created should be equal to: $($ResourceGroups[0].ResourceGroupName)"  {
#         $ResourceGroups[0].ResourceGroupName |  Should -be "some"
#     }
#     #EndRegion LAW Resource Group Tests
# }