<#
Original question: <https://discord.com/channels/180528040881815552/447522509244465152/1134622818026401802>
    The core question was how do you write a function that allows you to pass as parameters or from the pipeline, like

    Install-SqlServer -ServerObject 'server1', 'server2'
    'server1', 'server2' | Install-SqlServer


notes:

When using arrays, if you want to add items one at a time, this

    $list.AddRange( $InputList )

is short for

    foreach($item in $InputList) {
        $list.Add( $item )
    }

if you include @() you can throw expressions in there, like

    $list.AddRange(@(
        Get-ChildItem -Path c:\ -depth 2  | Select -first 10  | Sort Name
    ))

- if a parameter like $Port should be valid in both parameter sets,
    don't set a parameterSetName so it's valid in both
- instead of [array] either use @() or [object[]]
- if you want a changeable array use [List[Object]]
- for parameters when you use 'Mandatory', it's $true by default
- if the flag isn't defined, it's false implicitly, or use Foo = $false
- if a parameter is a [bool] you want to use [switch] instead
- a [switch] parameter is implicity false if it's not an argument
- If you're using Pwsh, you could rewrite some of the logging
    using 'Join-String'
    and null operators like '??'

when passing by pipeline, like:

    ... | Install-SqlServer

    $ServerObject will be $null when you're in the begin {} block, it doesn't exist yet

- setting the right DefaultParameterSetName, like the from the pipline,
    can fix some parametersetname issues. Or at least it can make positional parameters
    resolve easier, meaning autocomplete easier

#>
Function test.Install-SqlServer {
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
        [Parameter(Mandatory, ParameterSetName = 'InstallByConfig')]
        [string]$ServerConfig,

        [Parameter(ParameterSetName = 'InstallByParameters', ValueFromPipelineByPropertyName)]
        [bool]$InstallSSIS,

        # If not set, defaults to 1433
        [Parameter()]
        [int]$Port = 1433
    )

    begin {
        [Collections.Generic.List[Object]]$_servers = @()
        'Enter: -Begin' | write-verbose
        $PSBoundParameters | ConvertTo-Json -wa 0 -Depth 2 | Write-Debug

        '   ExpectingInput? {0}' -f $PSCmdlet.MyInvocation.ExpectingInput | Write-Verbose
        '   ParameterSetName = {0}' -f $PSCmdlet.ParameterSetName | write-verbose
        '   ServerObject[ {0} ] => [ {1} ]' -f @(
            $ServerObject.count
            $ServerObject -join ', '
        ) | Write-Verbose
        '   InstallSSIS? {0} ' -f $InstallSSIS | Write-Verbose

        # here I'm testing if there's anything being piped, regardless of which parameterset I'm in
        if($PSCmdlet.MyInvocation.ExpectingInput) {
            $_servers.addRange( $ServerObject )
        }

        switch($PSCmdlet.ParameterSetName) {
            # Usually I set default to throw an exception, because it causes some errors
            # that otherwise a typo could silently go through without errors
            'InstallByConfigFile' {
                $names = Get-Item -ea 'stop' -LiteralPath $Config
                $_servers.AddRange(@(
                    $Names
                ))
            }
            default { write-debug "no special Switch logic was used for '$Switch'"  }
            # default { throw "Warning: Unhandled parameterSet! $Switch"}
        }

        $PSBoundParameters.ContainsKey('ServerObject')
        # you can include $PSCmdlet.ParameterSetName

        return

        switch ($PSCmdlet.ParameterSetName) {
            'InstallByCollection' { foreach ($object in $ServerObject) { $_servers += $object } }
            'InstallByConfigFile' {
                $_servers += $ServerConfigFile
            }
            'InstallByParameters' {
                $_servers += [ordered]@{
                    ServerName        = $ServerName
                    InstanceName      = $InstanceName
                    Port              = $Port
                    Version           = $Version
                    Edition           = $Edition
                    ManagedAccont    = $ManagedAccount
                    InstallSSIS       = $InstallSSIS
                    InstallPrometheus = $InstallPrometheus
                }
            }
            default { throw "'Invalid ParameterSet detected of '$($PSCmdlet.ParameterSetName)'. " }
        }
        'servers start'
        # "`t$($_servers)"-+

        foreach ($s in $_servers) { "`t$s" }
        'servers end'
        'begin end'
    }
    process {
        'Enter: -Process' | Write-Verbose
        $PSBoundParameters | ConvertTo-Json -wa 0 -Depth 2 | Write-Debug
        '   ParameterSetName = {0}' -f $PSCmdlet.ParameterSetName | write-verbose
        '   ExpectingInput? {0}' -f $PSCmdlet.MyInvocation.ExpectingInput | Write-Verbose
        '   ServerObject[ {0} ] => [ {1} ]' -f @(
            $ServerObject.count
            $ServerObject -join ', '
        ) | Write-Verbose
        '   InstallSSIS? {0} ' -f $InstallSSIS | Write-Verbose
        # '-Begin: ServerObject[ {0} ] => { {1} }' -f @(
        #     $ServerObject.count
        #     ($ServerObject -join ', ')
        # ) | Write-Verbose

        # $PSCmdlet.MyInvocation.ExpectingInput
        #     | Join-String -op '-Process: ExpectingInput?' | Write-Verbose
        # $ServerObject
        #     | Join-String -op '-Process: ServerObject' -sep ', ' | write-verbose
        return


    }
    end {
        'Enter: -End' | Write-Verbose
        $PSBoundParameters | ConvertTo-Json -wa 0 -Depth 2 | Write-Debug
        '   ParameterSetName = {0}' -f $PSCmdlet.ParameterSetName | write-verbose
        '   ExpectingInput? {0}' -f $PSCmdlet.MyInvocation.ExpectingInput | Write-Verbose
        '   ServerObject[ {0} ] => [ {1} ]' -f @(
            $ServerObject.count
            $ServerObject -join ', '
        ) | Write-Verbose
        '   InstallSSIS? {0} ' -f $InstallSSIS | Write-Verbose
    }
}
'Using -Debug gives you a super verbose output of the parameters' | write-host -fore 'red'
$sharedSplat = @{
    Verbose = $true
    Debug = $false
}

'using a config' | Write-host -fore 'blue'
test.Install-SqlServer -Config 'servers.txt' @sharedSplat -ea 'break'
return

'Passing as parameters' | Write-host -fore 'blue'
test.Install-SqlServer -ServerObject 'server1', 'server2' @sharedSplat

'piping values' | Write-host -fore 'blue'
'server1', 'server2' | test.Install-SqlServer @sharedSplat