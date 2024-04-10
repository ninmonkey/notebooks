import-module pansies
set-location $PSScriptRoot
$error.Clear()

function Goto-ItemLocation {
    <#
    .SYNOPSIS
        This sugar lets you pipe files or folders and it will `set-location`, automatically.
    .EXAMPLE
        see the bottom of this file for tests
    #>
    [CmdletBinding(DefaultParameterSetName = 'FromString')]
    # [CmdletBinding()]
    [Alias('mg', 'miniGoto')]
    param(
        # catch properties named Path, PsPath, etc
        [ValidateNotNull()]
        [Alias('FullName', 'PSPath', 'Path', 'InStr', 'Str')]
        # [Parameter( ParameterSetName = 'FromString', ValueFromPipelineByPropertyName, ValueFromRemainingArguments)]
        # [Parameter( Position = 0, ParameterSetName = 'FromString' )]
        [Parameter( Position = 0, ParameterSetName = 'FromString', ValueFromPipelineByPropertyName)]
        [string] $LiteralPath,

        [ValidateNotNull()]
        [Alias('InObj', 'Obj')]
        # [Parameter( ParameterSetName = 'FromObject', Position = 0 )]
        [Parameter( Position = 0, ParameterSetName = 'FromObject', ValueFromPipeline)]
        [object] $InputObject


        # files, items, maybe even functions
    )
    begin {
        function PushLoc {
            # silly wrapper of the final Push, it toggles verbose logging
            param( $target )
            if( $null -eq $target) {
                write-warning 'ShouldNeverReach: was null'
                throw 'ShouldNeverReach: was null'
            }
            "type: '{0}'`n  goto => '{1}'" -f @(
                $target.GetType()
                $target
            ) | New-Text -fg 'green' | write-verbose

            Push-Location $Target
        }
    }
    process {
        if( -not $PSBoundParameters.ContainsKey('LiteralPath') -and
            -not $PSBoundParameters.ContainsKey('InputObject') ) {
            throw 'Mandatory InputObject or Path is missing'
        }
        if($null -eq $InputObject -and $Null -eq $LiteralPath ) {
            throw 'ShouldNeverReach: InputObject is null '
        }
        $Target = [string]::IsNullOrEmpty( $LiteralPath ) ? $InputObject : $LiteralPath

        $Target.GetType().Name | Join-string -op ' => Proc: ' | Write-Debug
        if( $Item = Get-Item $Target -ea 'ignore' ) {
            $Item
                | Join-String -op '  Is: Item, Value: ' -sep ' ::: '
                | Write-verbose
                # | write-host -fg 'blue'
            if($Item -is [IO.FileInfo]) {
                PushLoc $Item.Directory
                return
            }
            PushLoc $Item
            return
        }
        $Target.GetType() | Join-String -op 'Was a: ' |  write-host -fg 'blue'

        wait-debugger
        'Unhandled Type: "{0}", value: {1}' -f @(
            $Target.GetType()
            $Target
        ) | write-error

    }
}
# test a few variations, verbose output
$PSDefaultParameterValues['Goto-ItemLocation:Verbose'] = $true
$PSDefaultParameterValues['Goto-ItemLocation:Debug'] = $true
mg (gi . )

return

mg $PSScriptRoot
mg $PSCommandPath
mg ..
gi .. | mg
'.' | mg
'..' | mg


# not yet working:
# the property Path isn't being passed as a name, it's the full object
(Get-process pwsh | select -First 1) | mg -ea 'break'

pushd $PSScriptRoot

$PSDefaultParameterValues['Goto-ItemLocation:Verbose'] = $false
$PSDefaultParameterValues['Goto-ItemLocation:Debug'] = $false
# Join-Path (gi $PSScriptRoot) '.' | mg
