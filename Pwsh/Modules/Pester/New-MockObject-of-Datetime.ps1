<#
context: <https://discord.com/channels/180528040881815552/447476910499299358/1202692541003079730>
But if you're using Pester 5 you can send a mock of DateTime. Pester will wire up a _<MethodName> properties which describes the calls to a mocked method:
#>
$c = New-PesterContainer -ScriptBlock {
    BeforeAll {
        function ConvertTo-UnixTime {
            [CmdletBinding()]
            [OutputType('System.TimeSpan')]
            param (
                [Parameter(Mandatory,
                        ValueFromPipeline)]
                [datetime] $Date
            )

            begin {
                [datetime] $epoch = '1/1/1970 00:00:00'
            }
            process {
                if ($Date.Kind -eq 'Local') {
                    $date = $Date.ToUniversalTime()
                }

                (New-TimeSpan -Start $epoch -End $date).TotalSeconds
            }
        }
    }

    Describe 'demo' {
        It 'Converts local to UTC' {
            $date = New-MockObject -Type DateTime -Properties @{
                Kind = [DateTimeKind]::Local
            } -Methods @{
                ToUniversalTime = {
                    $this
                 }
            }

            ConvertTo-UnixTime -Date $date

            $date._ToUniversalTime | Should -Not -BeNullOrEmpty
        }
    }
}
Invoke-Pester -Container $c -Output Detailed
