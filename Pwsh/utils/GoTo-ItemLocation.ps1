import-module pansies
set-location $PSScriptRoot

function Goto-ItemLocation {
    <#
    .SYNOPSIS
        This sugar lets you pipe files or folders and it will `set-location`, automatically.
    .EXAMPLE
        see the bottom of this file for tests
    #>
    [CmdletBinding()]
    [Alias('mg', 'miniGoto')]
    param(
        # files, items, maybe even functions
        [ValidateNotNullOrEmpty()]
        [Alias('FullName', 'PSPath', 'Path', 'InObj', 'Obj')]
        [Parameter( ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [object]
        $InputObject
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
        if($null -eq $InputObject) {
            throw 'ShouldNeverReach: InputObject is null '
        }
        $InputObject.GetType().Name | Join-string -op ' => Proc: ' | Write-Debug
        if( $Item = Get-Item $InputObject -ea 'ignore' ) {
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
        'Unhandled Type: "{0}", value: {1}' -f @(
            $InputObject.GetType()
            $InputObject
        ) | write-error

        $InputObject.GetType() | Join-String -op 'Was a: ' |  write-host -fg 'blue'
    }
}
# test a few variations, verbose output
$PSDefaultParameterValues['Goto-ItemLocation:Verbose'] = $true
$PSDefaultParameterValues['Goto-ItemLocation:Debug'] = $true
mg (gi . )
mg .
mg $PSScriptRoot
mg $PSCommandPath
mg ..
gi .. | mg
'.' | mg
'..' | mg

# not yet working:
# the property Path isn't being passed as a name, it's the full object
(Get-process pwsh | select -First 1) | mg -ea 'break'

$PSDefaultParameterValues['Goto-ItemLocation:Verbose'] = $false
$PSDefaultParameterValues['Goto-ItemLocation:Debug'] = $false
# Join-Path (gi $PSScriptRoot) '.' | mg
