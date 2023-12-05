


$records = @(
    [pscustomobject]@{
        Name = 'POST JURY FEE'
        Path = '\PLEADINGS'
    }
    [pscustomobject]@{
        Name = 'MTS'
        Path = '\PLEADINGS\DEMURRER-STRIKE\STRIKE'

    }
)
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

$T.Prefix
$records | %{
    $Item = $_
    $T.Name -f $Item.Name
    $T.Path -f $Item.Path
}
$T.Suffix
