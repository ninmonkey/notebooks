    pushd $PSScriptRoot

    # Here's a basic splat use. You can repeat that over an array
    # $splat = @{ CommandType = 'Application' ; All = $true; Name = 'python' }
    # Get-Command @splat

    [object[]]$commands = @(
        @{ CommandType = 'Application' ; All = $true; Name = 'python' }
        @{ CommandType = 'Application' ; Name = 'ping' }
    )

    # Basically this is a "structured" [pscustomobject] . 
    # that allows you to enforce datatypes per-property.
    class CommandResult {
        [object]$CmdArgs
        [object]$Results
    }

    # it will be populated by [CommandResult]'s
    [Collections.Generic.List[Object]]$Script:CommandSummary = @()

    function processCommands {
        [CmdletBinding()]
        param(
            # invoke-commands, save results
            [object[]]$CommandList
        )

        $CommandList | ForEach-Object {
            $cur_splat = $_

            $jsonLog = $cur_splat | ConvertTo-Json -Depth 3 -Compress
            "Invoking 'processCommands' with `$curArgs = $jsonLog"  | Write-Verbose

            $cmd_result = Get-Command @cur_splat
            $cmd_result | Write-Information

            $summary = [CommandResult]@{
                CmdArgs = $cur_splat
                Results = $cmd_result
            }
            $CommandSummary.Add( $Summary )
        }
    }

    # processCommands $commands -Verbose -infa 'Continue' | out-null
    # hr
    write-warning 'run 1 as loud: -Infa and -Verbose'
    $out = processCommands $commands -Verbose -infa 'Continue' 
    
    write-warning 'run 2 as -Verbose'
    $out = processCommands $commands -Verbose #-infa 'Continue' 
    
    write-warning 'run 3 as -Silent'
    $out = processCommands $commands 
    'ran a total of {0} commands' -f @( $CommandSummary.Count )

<#
Example output

    Pwsh> processCommands $commands -Verbose    

    VERBOSE: Invoking 'processCommands' with $curArgs = {"Name":"python","All":true,"CommandType":"Application"}
    VERBOSE: Invoking 'processCommands' with $curArgs = {"CommandType":"Application","Name":"ping"}
#>