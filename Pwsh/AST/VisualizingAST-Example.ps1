$raw1 = "@( foo  --cwd wdddw ; stuff )"
$raw2 = 'foo  --cwd wdddw'

$Doc = [Parser]::ParseInput( $raw2, [ref] $null, [ref] $null )


$doc.FindAll({ param( $X ) $true }, $true )
$query = $doc.FindAll({ param( $X ) $true }, $true )
# using OutGridView, count types of each element
$query
    | group { $_.GetType() }
    | out-gridview

# try summaring as labels

$config = @{
    WrapLines = $true
}

$summary = $query | %{
    $cur = $_
    $TinfoProps = $cur.gettype() | ClassExplorer\Fime -MemberType Property

    $renderPropNames =
    if($Config.WrapLines) {
        $TinfoProps | Join-String -sep ",`n" -p Name
    } else {
        $TinfoProps | Join-String -sep ", " -p Name
    }

    $info = [ordered]@{
        ShortTypeName = $Cur.GetType().Name
        StrConstType = $Cur.StringConstantType ?? ''
        PropsDefined = $renderPropNames
        # PropsDefined = $TinfoProps | Join-String -sep ', ' -p Name
        Tinfo        = $cur.GetType()
        Object       = $cur
    }
    $cur | Add-Member -NotePropertyMembers $info -Force -PassThru -ea Ignore
}

$summary | out-gridview
