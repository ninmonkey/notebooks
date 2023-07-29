Function test.Install-SqlServer {
    <#
    .SYNOPSIS
        how to pass arrays as both parameters and from the pipeline
    .DESCRIPTION
        How to support both of these:

        Install-SqlServer -ServerObject 'server1', 'server2'
        'server1', 'server2' | Install-SqlServer
    .notes
    Written to run on PS5 and 7
    The orignal question was from: <https://discord.com/channels/180528040881815552/447522509244465152/1134622818026401802>

    For details, see: "HowTo - Passing Arrays as both Parameters and ValueFromPipeline.md"

    #>
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'high')]
    param(
        # Your array of server names as a parameter or from the pipeline
        [ValidateNotNullorEmpty()]
        [Parameter(Mandatory, ParameterSetName = 'InstallByCollection', ValueFromPipeline)]
        [Alias('InputObject')]
        [string[]]$ServerObject,

        # filepath that contains a list of server names
        # note: did you want this to be exclusive of the other inputs?  if yes, use mandatory
        # if it would compliment the pipeline, don't set it as mandatory
        [Alias('Config')]
        [Parameter(Mandatory, ParameterSetName = 'InstallByConfigFile')]
        [string]$ServerConfig,

        [Parameter(ParameterSetName = 'InstallByParameters', ValueFromPipelineByPropertyName)]
        [bool]$InstallSSIS,

        # If not set, defaults to 1433
        [Parameter()]
        [int]$Port = 1433
    )

    begin {
        [Collections.Generic.List[Object]]$_servers = @()
        'Enter: -Begin' | Write-Verbose
        $PSBoundParameters | ConvertTo-Json -wa 0 -Depth 2 | Write-Debug

        '   ExpectingInput? {0}' -f $PSCmdlet.MyInvocation.ExpectingInput | Write-Verbose
        '   ParameterSetName = {0}' -f $PSCmdlet.ParameterSetName | Write-Verbose
        '   ServerObject[ {0} ] => [ {1} ]' -f @(
            $ServerObject.count
            $ServerObject -join ', '
        ) | Write-Verbose
        '   InstallSSIS? {0} ' -f $InstallSSIS | Write-Verbose



        switch ($PSCmdlet.ParameterSetName) {
            # Usually I set default to throw an exception, because it causes some errors
            # that otherwise a typo could silently go through without errors
            'InstallByConfigFile' {
                $names = Get-Item -ea 'stop' -LiteralPath $ServerConfig
                $_servers.AddRange(@(
                        $Names
                    ))
            }
            default {
                # here I'm testing if there's anything being piped, regardless of which parameterset I'm in
                if ( -not $PSCmdlet.MyInvocation.ExpectingInput) {
                    $_servers.addRange( $ServerObject )
                }
            }
            # note: did you want this to be exclusive of the other inputs?  if yes, use mandatory
            # default { throw "Warning: Unhandled parameterSet! $Switch"}
        }
    }
    process {
        'Enter: -Process' | Write-Verbose
        $PSBoundParameters | ConvertTo-Json -wa 0 -Depth 2 | Write-Debug
        '   ParameterSetName = {0}' -f $PSCmdlet.ParameterSetName | Write-Verbose
        '   ExpectingInput? {0}' -f $PSCmdlet.MyInvocation.ExpectingInput | Write-Verbose
        '   ServerObject[ {0} ] => [ {1} ]' -f @(
            $ServerObject.count
            $ServerObject -join ', '
        ) | Write-Verbose
        '   InstallSSIS? {0} ' -f $InstallSSIS | Write-Verbose

        if ($PSCmdlet.MyInvocation.ExpectingInput) {
            $_servers.addRange(@(
                    $ServerObject
                ))
        }
    }
    end {
        'Enter: -End' | Write-Verbose
        $PSBoundParameters | ConvertTo-Json -wa 0 -Depth 2 | Write-Debug
        '   ParameterSetName = {0}' -f $PSCmdlet.ParameterSetName | Write-Verbose
        '   ExpectingInput? {0}' -f $PSCmdlet.MyInvocation.ExpectingInput | Write-Verbose
        '   ServerObject[ {0} ] => [ {1} ]' -f @(
            $ServerObject.count
            $ServerObject -join ', '
        ) | Write-Verbose
        '   InstallSSIS? {0} ' -f $InstallSSIS | Write-Verbose

        $_servers | ForEach-Object {
            $ServerName = $_
            $record = [ordered]@{
                PSTypeName  = 'InstallSql.SummaryRecord.'
                ServerName  = $ServerName
                Port        = $Port
                InstallSSIS = $InstallSSIS
            }

            [pscustomobject]$record

        }
    }
}
'Using -Debug gives you a super verbose output of the parameters' | Write-Host -fore 'red'
$sharedSplat = @{
    Verbose = $true
    Debug   = $false
    # ea      = 'break'
}

'using a config' | Write-Host -fore 'blue'
test.Install-SqlServer -Config 'servers.txt' @sharedSplat -ea 'break'

'Passing as parameters' | Write-Host -fore 'blue'
test.Install-SqlServer -ServerObject 'server1', 'server2' @sharedSplat

'piping values' | Write-Host -fore 'blue'
'server1', 'server2' | test.Install-SqlServer @sharedSplat