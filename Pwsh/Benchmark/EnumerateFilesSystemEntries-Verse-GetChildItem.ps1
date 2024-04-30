h1 (Join-String -f 'File: {0}' -in $PSCommandPath)

function Measure.Group {
    [CmdletBinding()]
    param(
        # [ValidateNotNullOrWhiteSpace()]
        # [Alias('Label')]
        # [string]$GroupName,

        # [ValidateNotNullOrWhiteSpace()]
        # [string]$CommandName,

        [int]$RepeatCount = 1,

        [Management.Automation.ActionPreference]$CommandErrorActionPref = 'Continue',
        [switch]$AsJob = $true
    )


    Measure-Benchmark -AsJob:$AsJob -ea 'continue' -Group 'big' -RepeatCount $RepeatCount -Technique @{
        'gci' = {
            $gciSplat = @{
                Recurse     = $true
                # Depth       = 5
                ErrorAction = 0
                Path        = 'G:\2023-git'
            }

            gci @gciSplat
        }
        enumerateBasic = {
            $Options = [IO.EnumerationOptions]@{
                  AttributesToSkip      = [IO.FileAttributes]'System, Hidden'
                  RecurseSubdirectories = $true
                  IgnoreInaccessible    = $true

                MatchCasing = [System.IO.MatchCasing]::CaseInsensitive
                # BufferSize            = 1mb
                #   MaxRecursionDepth     = 5
            }
            foreach($i in (get-item 'G:\2023-git').EnumerateFileSystemInfos('*', $Options)) { $i }
            }
        enumerateBasic_MatchCase = {
            $Options = [IO.EnumerationOptions]@{
                  AttributesToSkip      = [IO.FileAttributes]'System, Hidden'
                  RecurseSubdirectories = $true
                  IgnoreInaccessible    = $true
                MatchCasing = [System.IO.MatchCasing]::CaseInsensitive
                # BufferSize            = 1mb
                #   MaxRecursionDepth     = 5
            }
            foreach($i in (get-item 'G:\2023-git').EnumerateFileSystemInfos('*', $Options)) { $i }
            }

    } | sort-Object Time -desc
    Measure-Benchmark -AsJob:$AsJob -ea 'continue' -Group 'small' -RepeatCount $RepeatCount -Technique @{
        'gci' = {
            $gciSplat = @{
                Recurse     = $true
                Depth       = 5
                ErrorAction = 0
                Path        = 'G:\2023-git\Pwsh📁'
            }

            gci @gciSplat
        }
        enumerateBasic = {
            $Options = [IO.EnumerationOptions]@{
                  AttributesToSkip      = [IO.FileAttributes]'System, Hidden'
                  RecurseSubdirectories = $true
                  IgnoreInaccessible    = $true
                    # MatchCasing           = $true
                # BufferSize            = 1mb\
                MatchCasing = [System.IO.MatchCasing]::CaseSensitive
                  MaxRecursionDepth     = 5
            }
            foreach($i in (get-item 'G:\2023-git\Pwsh📁').EnumerateFileSystemInfos('*', $Options)) { $i }
            }
        enumerateBasic_MatchCase = {
            $Options = [IO.EnumerationOptions]@{
                  AttributesToSkip      = [IO.FileAttributes]'System, Hidden'
                  RecurseSubdirectories = $true
                  IgnoreInaccessible    = $true
                MatchCasing = [System.IO.MatchCasing]::CaseInsensitive
                # BufferSize            = 1mb
                  MaxRecursionDepth     = 5
            }
            foreach($i in (get-item 'G:\2023-git\Pwsh📁').EnumerateFileSystemInfos('*', $Options)) { $i }
            }

    } | sort-Object Time -desc
}

'starting jobs...' | write-host -back 'blue'
$results =
    @( Measure.Group -AsJob )
        | Receive-Job -Wait -AutoRemoveJob

'$results = {0}' -f $Results.count

h1 'grouped'
$results | ft -AutoSize  GroupName, Technique, Throughput, RelativeSpeed, Time

h1 'all'
$results | ft -AutoSize  GroupName, Technique, Throughput, RelativeSpeed, Time
hr -fg magenta

h1 (Join-String -in $PSCommandPath -f "File: {0}")
h1 'sort: Technique, Group'
$results
    | sort Technique, Groupname
    | ft -AutoSize Technique, Time, RelativeSpeed, GroupName, Throughput

h1 'sort: Group, Technique'
$results
    | sort GroupName, Technique
    | ft -AutoSize Technique, Time, RelativeSpeed, GroupName, Throughput

h1 'sort: Time'
$results
    | sort Time, Technique
    | ft -AutoSize Technique, Time, RelativeSpeed, GroupName, Throughput
