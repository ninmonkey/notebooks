# lift better version from ninmonkey.console?

function md.Write-Table {
    [CmdletBinding()]
    param(
        # takes an object, outputs as a markdown table
        [Parameter(Mandatory, ValueFromPipeline, position = 0)]
        [object[]]$InputObject,

        # kwargs
        [hashtable]$Options
        # [string]$Path = $pwd
    )
    begin {
        [Collections.Generic.List[Object]]$Items = @()
    }
    process {
        $items.AddRange(@(
            $InputObject
        ))
    }
    end {
        $Items
        | Sort -Descending
        | %{
            $obj = $_
            $col_names = $Obj.Psobject.Properties.Name | sort -unique
            $num_cols = $col_names.count

            $as_TableRow = @{
                OutputPrefix = '| '
                OutputSuffix = ' |'
                Separator = ' | '
            }

            $col_Names | Join-String @as_TableRow
            ' ' * $NumCols | Join-String @as_TableRow
        }
        # sorts per-object
        # then sorts per-property.
        # More useful with later config
    }
}

class measureSbResult {
    hidden [scriptBlock]$ScriptBlock
    [timespan]$Elapsed
    [string]$Label
    [double]$Sec # should be a getter. does pwsh have one? a scriptproperty without update-typedata
    [double]$Ms
    [int]$Order
    # [long]$Ticks

    measureSbResult( [ScriptBlock]$ScriptBlock, [Timespan]$Elapsed, [string]$Label, [int]$Order ) {
        $this.ScriptBlock = $ScriptBlock
        $this.Elapsed = $Elapsed
        $this.Label = $Label ?? ''
        $this.Sec = $elapsed.TotalSeconds
        $this.Ms = $elapsed.TotalMilliseconds
        $this.Order = $Order
        # $this.Ticks = 0
    }
}

function Measure-BaseScriptBlock {
    <#
    .synopsis
        gives a very rough measure of time taken to execute. use another function if precision matters. This is for sugar.
    .example
        0..3 |  %{ nb.TimeIt -ScriptBlock { sleep 0.2 } -Label 'bob' }|ft

        Elapsed          Label  Sec     Ms Order
        -------          -----  ---     -- -----
        00:00:00.2146765 bob   0.21 214.68     0
        00:00:00.2017461 bob   0.20 201.75     1
        00:00:00.2011267 bob   0.20 201.13     2
        00:00:00.2001124 bob   0.20 200.11     3
    #>
    [Alias('nb.TimeIt', 'nb.MeasureScriptBlockExecution')]
    [CmdletBinding()]
    param(
        # scriptblock to execute and measure
        [Alias('SB', 'InputObject')]
        [Parameter(Mandatory, ValueFromPipeline, position = 0)]
        [ScriptBlock[]]$ScriptBlock,

        [string]$Label
        # ,
        # # number of times to execute the scriptblock
        # [int]$Iterations = 1
    )
    begin {
        $script:__measureOrder ??= 0
        [Collections.Generic.List[measureSbResult]]$Results = @()
    }
    process {
        foreach ($Sb in $ScriptBlock) {

            $sw = [System.Diagnostics.Stopwatch]::StartNew()
            # $sb.Invoke() # ?
            & $sb #
            $sw.Stop()

            $Results.add(
                [measureSbResult]::new(
                    $sb, $sw.Elapsed,
                    $Label, (
                    ($script:__measureOrder++)
                ))
            )
                # [measureSbResult]@{
                #     ScriptBlock = $sb
                #     Elapsed     = $sw.Elapsed
                #     Sec         = $sw.Elapsed.TotalSeconds
                #     Ms          = $sw.Elapsed.TotalMilliseconds
                #     Label       = $Label
                # })
        }
    }
    end {
        return $results
    }

}

function ps.Gci.FilesOfType {
    #
    <#
    .synopsis
    .example
        ps.Gci.FilesOfType -Extensions png, gif, jpeg, jpg -BaseDirectory ..
    .example
        # sometimes GI needs absolute path or cwd-prefix etc

        ps.Gci.FilesOfType -Extensions png, gif, jpeg, jpg, svg -BaseDirectory .. -OptionalConfig AbsolutePath
| gi
    #>
    [CmdletBinding()]
    param(
        # image extension types
        [Parameter(Mandatory, position = 0)]
        [ArgumentCompletions(
            ''
        )]
        [string[]]$Extensions,
        [string]$BaseDirectory,
        [int]$MaxDepth,

        [ValidateSet(
            'AbsolutePath',
            # 'RelativePath'
            'Color',
            'FullPath',
            'PathForward',
            'PathStripPrefix',
            'CaseInsensitive'
        )][string[]]$OptionalConfig,
        [string]$Path
    )
    $binFd = Get-Command -CommandType application -Name 'fd' -ea stop

    [Collections.Generic.List[Object]]$FdArgs = @(
        $Extensions | ForEach-Object {
            '-e', $_
        }
        if ($true -or 'PathForward' -in $OptionalConfig) {
            '--path-separator', '/'
        }

        if ($BaseDirectory) {
            '--base-directory'
            (Get-Item $BaseDirectory )
        }
        if ('PathStripPrefix' -in $OptionalConfig) {
            '--strip-cwd-prefix'
        }
        if ('AbsolutePath' -in $OptionalConfig) {
            '--absolute-path'
        }
        if ('CaseInsensitive' -in $OptionalConfig) {
            '--ignore-case'
        }
        if ('FullPath' -in $OptionalConfig) {
            '--full-path'
        }
        if ('Color' -in $OptionalConfig) {
            '--color'
            'always'
        }

        if ($MaxDepth) {
            '--max-depth'
            $MaxDepth
        }
    )

    $FdArgs | Join-String -sep ' ' -op 'invoke=> fd '
    | Write-Information -infa Continue

    & $binFd @FdArgs
}

