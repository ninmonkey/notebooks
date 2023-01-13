$Cfg = @{
    Using = @{
        Tee             = $True
        ETA             = $True
        RestartableMode = $true
        BackupMode      = $null # omission is not equal to false
    }
}
$Source = 'g:\temp'; $Dest = 'g:\temp\robo'

# [source] [dest] <options> 
# Source must exist
[Collections.Generic.List[Object]]$roboArgs = @(
    $Source | Get-Item -ea stop | Join-String -DoubleQuote
    $Dest | Join-String -DoubleQuote

    $Config.Using.RestartableMode ? '/z' : $null
    $Config.Using.BackupMode ? '/b' : $null
    $Config.Using.RestartableBackupMode ? '/zb' : $null
    ($Config.Using.WhatIf -or $Whatif ) ? '/L' : $null
)

$colorSplat = @{
    BackgroundColor = 'blue'
    ForegroundColor = 'red'
}
$colorSplat.BackgroundColor = '#61a7f3'
$colorSplat.BackgroundColor = '#578a48'
$colorSplat.BackgroundColor = '#998377'
function Bg {
    [OutputType('String')]
    param(
        [Alias('Name')]
        [string]$Rgb
    )
    "#${rgb}" -replace '^\#{1,}', '#'
    # $rgb -replace '^\#{1,}', '#'
    return $PSStyle.Background.FromRgb($Color)
}
function Fg {
    [OutputType('String')]
    param(
        [Alias('Name')]
        [string]$Rgb
    )
    "#${rgb}" -replace '^\#{1,}', '#'
    # $rgb -replace '^\#{1,}', '#'
    return $PSStyle.Foreground.FromRgb($Color)
}
function colorReset {    
    return $PSStyle.Reset # aka "`e[0m"
}

$roboArgs
| Join-String -sep ' ' -op ( $PSStyle.Background.FromRgb('#998377')) -os ( $PSStyle.Reset )
| Join-String -op 'robocopy: '

# $roboArgs | Join-String -sep ' ' -op 'robocopy =>' | write-host @colorSplat