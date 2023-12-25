# using join string instead
$T = @{}
$T.Name = @'
    '\s{0}[\s_]' {{
'@
$T.Path = @'
        Join-Path $FOLDER '{0}' ; break
    }}
'@
$T.Suffix = @'
}
'@
$T.Prefix = @'
$folder = switch -Regex ($_.Name) {
'@

function Join.Prefix {
    param(
        [int]$Depth = 1
    )
    process {
        $Line = $_
        $prefix = '    ' * $depth -join ''
        Join-String -f "$Prefix{0}" -in $Line
    }
}
@(
    $T.Prefix
    $records | %{
        $Item = $_
        $T.Name -f $Item.Name
        $T.Path -f $Item.Path
    }
    $T.Suffix
) |



return
