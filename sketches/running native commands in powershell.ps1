# question was:
# ping -n 2 -w 200 www.google.com

@'
Notes

    When using tab-completions, [MenuComplete] is usually my preference.
    It includes all valid tab-completer values,
    so you don't have to hit tab multiple times when there's more matches


    Check it out, type this, then tab

        Write-Host -ForegroundColor <tab>

    verses this and <ctrl+space>

        Write-Host -ForegroundColor <ctrl+space>

    Ping displays suggested targets

        Ping <tab>
        Ping <ctrl+space>


        [ctrl+space]

        is so much cooler than

            [tab]
'@

function Invoke-NativePing {
    <#
   .SYNOPSIS
      a basic wrapper for ping, it's over kill
    .description
        it demonstrates a couple of useful features

    1] "Target" tab completes suggested values
    2] a safe way to declare args for a native command, then splat it
    3] All parameters are optional, and use default values
    4] except "Target" is mandatory
    5] Errors from missing native commands will error and stop, using "-ErrorAction Stop"
    6] Using aliases for parameter names, like "-ms 200"
    7] "-CommandType Application" ensures that you
        aliases and functions with the same name will not run accidentally
    8] [MenuComplete]
   #>
    [Alias('Ping')]  # this alias is what you type in the console
    [CmdletBinding()]
    param(
        # who to ping
        [Parameter(Mandatory)]
        [ArgumentCompletions(
            'www.google.com', 'www.reddit.com',
            '8.8.8.8', '1.1.1.1')]
        [string]$Target,

        # Number of times to ping
        [int]$Count = 2,

        # Timout in milliseconds
        [Alias('Ms')]
        [int]$TimeoutMilliseconds = 200,

        # Error if there's ever multiple native commands
        # that are found, otherwise continue using the first one
        [switch]$OneOrNone
    )

    $cmdList = Get-Command 'ping' -ea stop -CommandType Application
    if ($OneOrNone) {
        if ($cmdList.count -gt 1) {
            throw "Multiple matches found! $($BinCmd)"
        }
    }
    $binCmd = $cmdList | Select-Object -First 1


    # extra handling if you don't want ambigous results
    # very important with 'python', there's a million of them.
    if ($OneOrNone -and $binCmd.count -gt 1) {
    }

    $cmdArgs = @(
        '-n', $Count,
        '-w', $TimeoutMilliseconds,
        'www.google.com'
    )
    & $binCmd @cmdArgs
}

# usage
Ping www.google.com

Ping www.google.com -Count 1 -ms 2000
