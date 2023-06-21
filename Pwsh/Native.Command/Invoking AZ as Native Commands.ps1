
<# examples  #>
invokeCosmoDBRoleEtc -TestOnly

Get-Item 'H:\data\2023\pwsh\pipescript-export-errors.json'
    | Format-AzJsonParam -OutputFormat Pwsh

Format-AzJsonParam -OutputFormat WindowsPowershell -InputJsonPath 'foo.bar.json'

<# begin #>
function Format-AzJsonParam {
    <#
    .EXAMPLE
        Pwsh> Get-Item 'foo.json' | Format-AzJsonParam
        Pwsh> Format-AzJsonParam -InputJsonPath 'foo.json'
    .notes
        - [discord thread with Chris's answers](https://discord.com/channels/180528040881815552/1120675761553166376/1120676412844679230)
        - [The important link for az specific quoting](https://learn.microsoft.com/en-us/cli/azure/use-cli-effectively?tabs=bash%2Cbash2#use-quotation-marks-in-parameters)

    see also:
        https://learn.microsoft.com/en-us/azure/cosmos-db/how-to-setup-rbac#using-the-azure-cli
        https://learn.microsoft.com/en-us/cli/azure/use-cli-effectively?tabs=bash%2Cbash2#use-quotation-marks-in-arguments
        https://learn.microsoft.com/en-us/cli/azure/cosmosdb/sql/role/definition?view=azure-cli-latest#az-cosmosdb-sql-role-definition-create
        https://github.com/Azure/azure-cli/blob/dev/doc/quoting-issues-with-powershell.md


    #>
    [CmdletBinding()]
    [OutputType('String')]
    param(
        [Alias('PSPath', 'FullName')]
        [Parameter(Mandatory, Position=0, ValueFromPipelineByPropertyName, ValueFromPipeline)]
        $InputJsonPath,

        # I *think* the docs are saying Pwsh and Bash are the same
        [Parameter(Mandatory)]
        [ValidateSet('Bash', 'Pwsh', 'WindowsPowershell')]
        [Alias('ShellType')][string]$OutputFormat
    )
    process {
        $Json = Get-Item -ea 'stop' $InputJsonPath
        $Contents = Get-Content -Path $Json -Raw # -Encoding utf8
        $Accum = $Contents

        switch($OutputFormat) {
            # final value wrapped as single quote
            # verses WinPs which is enclosed in double
            { $_ -in 'Pwsh', 'Bash' } {
                $Accum =
                    # "'`n{0}`n'" -f @( $Accum )
                    "'{0}'" -f @( $Accum )
                break
            }
            'WindowsPowerShell' {
                $Accum =
                    $Accum -replace '"', '\"'
                break
            }
            default { throw "UnhandledOutputMode: $OutputFormat"}
        }
        $Accum =
            $Accum -replace '@', '\@'

        return $Accum
    }
}

function InvokeCosmoDBRoleEtc {
    param(
        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory)]
        [string]$AccountName,

        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory)]
        [string]$resourceGroupName,

        [Alias('WhatIf')][switch]$TestOnly
    )

    $Path = Get-Item -ea 'stop' 'temp:\source.json'
    $contents = Get-Content $Path -raw
        | Join-String -SingleQuote

    [Collections.Generic.List[Object]]$AzArgs = @(
        'cosmosdb'
        'sql'
        'role'
        'definition'
        'create'
        '--account-name'
        $accountName
        '--resource-group'
        $resourceGroupName
        '--body'
        Format-AzJsonParam -InputJsonPath $Path -OutputFormat Pwsh
    )

    # previewing args before and after
    $AzArgs | Join-String -sep ' ' -op 'az: '
    $AzArgs.Add($Contents)
    $AzArgs | Join-String -sep ' ' -op 'az: '
    if($TestOnly) { return }

    # actual invoke
    & 'az' @AzArgs
}

