Write-Warning 'mostly written,finish'
function Excel.JoinOn.OwnProperty {
    <#
.SYNOPSIS
    takes an object, cartesian join the expanded property, ex: simplify exports when data expands.
.Description
    Name              : ImportExcel
    Path              : E:\PSModulePath_2022\ImportExcel\7.6.0\ImportExcel.psm1
    Description       :
    ModuleType        : Script
    Version           : 0.0
    PreRelease        :
    NestedModules     : {}
    ExportedFunctions : {Test-Integer, Enable-ExcelAutoFilter, ColumnChart, Get-ExcelShe
    ExportedCmdlets   :
    ExportedVariables :
    ExportedAliases   : {New-ExcelChart, Set-Column, Export-ExcelSheet, Use-ExcelData…}
#>
    [CmdletBinding()]
    param(
        [string[]]$ExplodePropertyName
    )


    Write-Warning @'
Partial NYI: the gist is 'ExportedCommands' is nested, but you want a dimension table

instead of
    $allMods[0] | s -ExpandProperty ExportedFunctions


    Excel -ExplodeProp ExportedFunctions, ExportedAliases
        ... expanding table rows


'@


}

$allMods ??= Get-Module ImportExcel -All -ListAvailable -SkipEditionCheck -Verbose
$allMods.count


$me = Get-Process -Id $pid
$parent = $me.Parent
# @(
#     $me
#     $parent
#     $parent.Parent
#     $parent.Parent.Parent
#     $parent.Parent.Parent.Parent
#     $parent.Parent.Parent.Parent.Parent
# ) | Join-String -sep ' ' -SingleQuote 'ProcessName'


function render.ProcessTree {
    <#
    .SYNOPSIS
        pretty print a process's parents, up the tree N-times
    .EXAMPLE
        render.ProcessTree -Pid $pid -FormatTemplate Color
    #>
    [CmdletBinding()]
    param(
        [Alias('Process')]
        [Parameter()]
        [object]$InputTargetProcess,

        [Alias('Pid')]
        [Parameter()]
        [int]$TargetProcessPid,

        [ArgumentCompletions('Basic', 'WithPid', 'Color')]
        [Parameter()]$FormatTemplate = 'Color'
    )
    if (-not $InputTargetProcess -and -not $TargetProcessPid) {
        throw 'requires Pid or name'
    }
    # @{
    #     Proc = $InputProcess.Name
    #     Pid  = $TargetProcessPid
    # } | to->Json | Write-Verbose
    # :( hack but because of null, and join-strings behavior
    # this is actually cleaner than recursion
    $t = $TargetProcess
    if (-not $T) {
        $t = Get-Process -Id $TargetProcessPid
    }
    if (-not $t) {
        throw 'InvalidData from Parameters'
    }


    [object[]]$procList = @(
        $t
        $t.Parent
        $t.Parent.Parent
        $t.Parent.Parent.Parent
        $t.Parent.Parent.Parent.Parent
        $t.Parent.Parent.Parent.Parent.Parent
        $t.Parent.Parent.Parent.Parent.Parent.Parent
        $t.Parent.Parent.Parent.Parent.Parent.Parent.Parent
    )

    switch ($FormatTemplate) {
        'Basic' {
            $procList | Join-String -sep ' ' -SingleQuote 'ProcessName'
        }
        'WithPid' {
            $procList | Join-String { '{0} [{1}]' -f @(
                    $_.ProcessName
                    $_.Id
                ) } -sep ' ▹ '
            # $procList | Join-String -sep ' ' -SingleQuote 'ProcessName'

        }
        'Color' {
            $C = @{
                Fg = @{
                    Gray80 = $PSStyle.Foreground.FromRgb( .8 * 255, 0.8 * 255, .8 * 255 )
                    Gray85 = $PSStyle.Foreground.FromRgb( .85 * 255, 0.85 * 255, .85 * 255 )
                    Gray65 = $PSStyle.Foreground.FromRgb( .65 * 255, 0.65 * 255, .65 * 255 )
                    Gray45 = $PSStyle.Foreground.FromRgb( .45 * 255, 0.45 * 255, .45 * 255 )
                }
                Bg = @{
                    Gray80 = $PSStyle.Background.FromRgb( .8 * 255, 0.8 * 255, .8 * 255 )
                    Gray85 = $PSStyle.Background.FromRgb( .85 * 255, 0.85 * 255, .85 * 255 )
                    Gray65 = $PSStyle.Background.FromRgb( .65 * 255, 0.65 * 255, .65 * 255 )
                    Gray45 = $PSStyle.Background.FromRgb( .45 * 255, 0.45 * 255, .45 * 255 )
                }

            }
            # $PSStyle.Foreground.FromRgb( $
            $procList | Join-String {
                '{0} [{1}]' -f @(
                    @(
                        $C.Fg.Gray80
                        $_.ProcessName
                        $C.Fg.Gray45
                    ) -join ''
                    @(
                        # $C.Fg.Gray65
                        $_.Id
                        # $C.Fg.Gray45
                        $PStyle.Reset

                    ) -join ''
                )
                # } -Separator ', '
            } -Separator ' ▹ '
            # $procList | Join-String -sep ' ' -SingleQuote 'ProcessName'

        }
        default { throw "NoValidTemplateFound: $_" }
    }

}

$meta_summary = @{
    PwshVersion                        = $PSVersionTable.PSVersion.ToString()
    LastRan                            = (Get-Date).ToString('o')
    Parent                             = render.ProcessTree -FormatTemplate 'WithPid' -Pid $Pid
    Host                               = Get-Host | ForEach-Object Name
    HostJsonInfo                       = Get-Host | ConvertTo-Json -Depth 0 -Compress -wa ignore

    [Collections.Generic.List[object]] = @(
        & {
            $env:PSModulePath -split ';'
            | ForEach-Object {
                [pscustomobject]@{
                    Path      = $_
                    LoadOrder = ($i++)
                    # Instance  = $_ | Get-Item -ea 'ignore'
                }

            }
            # $i = 0
            # $env:PSModulePath -split ';' | Get-Item | ForEach-Object {
            #     $_ | Add-Member -NotePropertyName PathOrder -NotePropertyValue ($i++) -Force -ea Ignore -PassThru

        }
    )
}
if ($false -and 'exportMetaTab to be merged in the same sheet') {
    @( [pscustomobject]$meta_summary ) | out-xl
}
# usage
hr
render.ProcessTree -Pid $pid -FormatTemplate WithPid
render.ProcessTree -Pid $pid -FormatTemplate Basic
hr
render.ProcessTree -Pid $pid -FormatTemplate Color