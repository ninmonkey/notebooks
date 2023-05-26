function Write.Log.AsA  {
    <#
    .SYNOPSIS
.EXAMPLE
    Write.Log.AsA PSCommandPath
    Write.Log.AsA CurrentLine
    Write.Log.AsA WriteFile 'fake/file.foo.json'
    Write.Log.AsA ReadFile (gi '.')
.EXAMPLE
    PS> Write.Log.AsA ReadFile (gi '.') -PassThru


    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)]
        [Alias('Kind', 'Format', 'Mode', 'Template')]
        [ValidateSet(
            'PSCommandPath',
            'WriteFile',
            'ReadFile',
            # 'PSScriptRoot',
            'CurrentLine'
        )]
        [string]$OutputFormat,

        [Parameter(Position = 1)]
        [Alias('File', 'Path')]
        [string]$TargetItem,

        # return rendered string but don't write to write-host
        [switch]$PassThru
    )
    $Config = @{
        # AlwaysAbbreviatePathNames = $true
        # AlwaysPrefixFuncName      = $true
        Color                     = @{
            # PSCommandPathFg = 'darkyellow'
            CurrentLineFg   = 'darkblue'
            DefaultFG       = 'darkblue'
            # PS5 version:# PSCommandPathFg = 'darkyellow'
            PSCommandPathFg = 'darkyellow'
            ReadFileFg      = 'darkmagenta'
            WriteFileFg     = 'darkgreen' #'darkblue'
        }
    }
    if ($OutputFormat -in @('WriteFile', 'ReadFile')) {
        if ( [string]::IsNullOrWhiteSpace($TargetItem)) {
            Write-Error 'missing $TargetItem parameter!'
            return
        }
    }

    switch ($OutputFormat) {
        'PSCommandPath' {
            # was: $render = Abbr.Path $PSCommandPath
            $render = Abbr.Path $PSCommandPath
            | Join-String -op '__in: ' -f '{0}'
            break
        }
        'WriteFile' {
            # was: $render = Abbr.Path $TargetItem
            $render = Abbr.Path $TargetItem
            | Join-String -f '::Write: <file:///{0}>'
            break
        }
        'ReadFile' {
            # was: $render = Abbr.Path $TargetItem
            $render = Abbr.Path $TargetItem
            | Join-String -f '::Read: <file:///{0}>'
            break
        }
        'CurrentLine' {
            $parentStack = (Get-PSCallStack)[1]
            $render = $parentStack
                | Join-String { $_.ScriptName, $_.ScriptLineNumber -join ':' }
                | Join-String -op '__at: ' -f '<file:///{0}>'
            break
        }
        default {
            Write-Error "UnhandledKind: $OutputFormat"
            return
        }

    }
    if ($PassThru) {
        return $render
    }
    switch ($OutputFormat) {
        'PSCommandPath' {
            # ps5 version:
            $render | Write-Host -fore $Config.Color.PSCommandPathFg
            # $PSStyle.Foreground($Config.Color.PSCommandPath )
            break
        }
        'WriteFile' {
            $render | Write-Host -fore $Config.Color.WriteFileFg
            break

        }
        'ReadFile' {
            $render | Write-Host -fore $Config.Color.ReadFileFg
            break

        }
        'CurrentLine' {
            $render | Write-Host -fore $Config.Color.CurrentLineFg
            break

        }
        default {
            $render | Write-Host -fore $Config.Color.DefaultFg
        }
    }
}
