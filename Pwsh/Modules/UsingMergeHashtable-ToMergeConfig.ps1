Function MergeHash {
    <#
    .description
        Copy and append BaseHash with new values from UpdateHash
     #>
    [cmdletbinding()]
    [OutputType('System.Collections.Hashtable')]
    [Alias('nin.MergeHash')]
    param(
        # base hashtable
        [AllowNull()]
        [Parameter(Mandatory)][hashtable]$BaseHash,

        # New values to append and/or overwrite
        [AllowNull()]
        [Parameter(Mandatory)][hashtable]$OtherHash,

        # normal is to not modify left, return a new hashtable
        [Parameter()][switch]$MutateLeft
    )
    $BaseHash ??= @{}
    $OtherHash ??= @{}

    if (! $MutateLeft ) {
        $TargetHash = [hashtable]::new( $BaseHash, $newCompareType )
    } else {
        Write-Debug 'Mutate enabled'
        $TargetHash = $BaseHash
    }
    $OtherHash.GetEnumerator() | ForEach-Object {
        $TargetHash[ $_.Key ] = $_.Value
    }

    return $TargetHash
}

function WriteText {
    param(
        [string]$Label,
        [object]$Contents,
        [hashtable]$Options = @{}
    )

    $Config = nin.MergeHash -OtherHash $Options -BaseHash @{
        Prefix = "`n"
        Suffix = "`n"
        Separator = ", "
        Fg = '#fee091'
        Bg = '#333333'
    }
    $color = @(
        $PSStyle.Foreground.FromRgb( $Config.Fg )
        $PSStyle.Background.FromRgb( $Config.Bg )
    ) -join ''

    $joinStringSplat = @{
        Separator    = $Config.Separator
        OutputSuffix = $Config.Suffix
        OutputPrefix = $Config.Prefix
    }
    $Contents
        | Join-String @joinStringSplat
        | Join-String -op $Color -os $PSStyle.Reset
}

WriteText -Contents 'hi world'
WriteText -Contents 'hi world' -Options @{ Fg = '#7ca3bb' }
WriteText -Contents @('a'..'f') -Options @{ Separator = '-'  }

WriteText -Contents @('a'..'c') -Options @{
    Separator = "`n - "
    OutputPrefix = "`n - "
}

function WriteCsv {
    param(
        [Alias('InputObject')]
        $Content
    )
    WriteText -Contents $Content -Options @{
        Separator = ', '
    }
}
function WriteUL {
    param(
        [Alias('InputObject')]
        $Content
    )
    WriteText -Contents $Content -Options @{
        Separator = "`n • "
        Prefix    = "`n • "
    }
}

WriteUL -in  ( Get-Process | Select -first 5 | % Name )
WriteCsv -in ( Get-Process | Select -first 15 | % Name )
