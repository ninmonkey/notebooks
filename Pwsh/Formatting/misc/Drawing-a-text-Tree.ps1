@'
├── dots_psmodules
│   ├── Dotils
│   │   ├── Dotils.psm1
│   │   ├── builld.ps1
'@


$Rune = @{
    Bar_UpRightDown = '├'
    Bar_UpDown = '│'
    Bar_RightLeft = '─'
}

function Dotils.Format.RenderTextTree.Line.Basic {
    <#
    .SYNOPSIS
        Dotils.Format.RenderTextTree 'dots_psmodules'
        Dotils.Format.RenderTextTree 'Dotils' -Depth 1
        Dotils.Format.RenderTextTree 'Dotils' -Depth 2
    .EXAMPLE
        $cmd_groups = gcm -m ImportExcel | group verb | sort Name  -Descending
        $cmd_groups | %{
            $verb = $_.Name
            if($Verb -eq ''){
                $Verb = '[empty]' # '␀'
            }
            $group = $_.Group
            Dotils.Format.RenderTextTree.Line $verb -d 0
            $group | Sort Name | %{
                $item = $_
                Dotils.Format.RenderTextTree.Line $item.Name -d 1
            }
            # | Join-String -sep ', '
        }

    #>
    param(
        [ALias('Text')][string]$Token,
        [int]$Depth = 0
    )
    $Rune = @{
        Bar_UpRightDown = '├'
        Bar_UpDown = '│'
        Bar_RightLeft = '─'
    }
    $prefix_Continue =
        $Rune.Bar_UpRightDown, ($Rune.Bar_RightLeft * 2), ' ' -join ''

    $prefix_Down =
        $Rune.Bar_UpRightDown, ($Rune.Bar_RightLeft * 2), ' ' -join ''

    $prefix_spaced =
        $Rune.Bar_UpDown, (' ' * 3) -join ''

    @(
        $prefix_spaced * $Depth -join ''
        $prefix_Continue
        $Token ) -join ''
}

$cmd_groups = gcm -m ImportExcel | group verb | sort Name  -Descending

h1 'display csv as one list'
$cmd_groups | %{
    $x = $_.Group.Name
    | Join-String -sep ', '
    Dotils.Format.RenderTextTree.Line.Basic $_.Name
    Dotils.Format.RenderTextTree.Line.Basic $x 1
}
h1 'display csv as sublist'
$cmd_groups = gcm -m ImportExcel | group verb | sort Name  -Descending
$cmd_groups | %{
    $verb = $_.Name
    if($Verb -eq ''){
        $Verb = '[empty]' # '␀'
    }
    $group = $_.Group
    Dotils.Format.RenderTextTree.Line.Basic $verb -d 0
    $group | Sort Name | %{
        $item = $_
        Dotils.Format.RenderTextTree.Line.Basic $item.Name -d 1
    }
    # | Join-String -sep ', '
}

# $_.Group.Name
#    | %{  Dotils.Format.RenderTextTree.Line.Basic $_ }
#    | Join-String -f "`n    {0}" -op 'title'


# return
# h1 'new'
# @(
#     $prefix_Continue,
#     'dots_psmodules'
# ) -join ''
# @(
#     ($prefix_spaced * 1 -join '')
#     $prefix_Continue
#     'Dotils'
# ) -join ''
# @(
#     ($prefix_spaced * 2 -join ''),
#     $prefix_Continue
#     'Dotils'
# ) -join ''
$c1 = "${fg:gray40}"
$c2 = "${fg:gray95}"
$c3 = "${fg:gray65}"
hr
@"
${c1}├──${c2} Update
${c1}│   ├── ${c3}Update-FirstObjectProperties
"@