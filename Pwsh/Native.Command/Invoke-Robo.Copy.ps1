
. (Get-Item -ea stop (Join-Path $PSScriptRoot 'Module.Robo.Copy.ps1'))

$Cfg = @{
    # Source = Get-Item -ea stop 'T:\Users\Public'
    # Source = Get-Item -ea stop 'H:\robo_root\root_T_oldClone'
    Source   = Get-Item -ea stop 'T:\Users\Public'
    Root     = Get-Item -ea 'ignore' 'H:\robo_root\Told_clone\foo'
    DestRoot = Get-Item -ea stop 'H:\robo_root\Told_clone'
    Log      = 'lastHuge.log'
    Using    = @{
        Tee             = $True
        WhatIf          = $false
        ETA             = $True
        RestartableMode = $true
    }
}
# Set-Location $PSScriptRoot
$Cfg | Format-Table -AutoSize

# Robo.Copy $Cfg
#Write-Host 'try: Robo.Copy $Cfg' -ForegroundColor orange -bg darkred
Write-Host 'try: Robo.Copy $Cfg' -ForegroundColor darkred -bg yellow

$robo_splat = @{    
    Recurse           = $true
    Verbose           = $true
    Debug             = $true
    InformationAction = 'continue'
    # WhatIf            = $false
    Options           = $Cfg
}

# Robo.Copy @robo_splat
Push-Location 't:\'
[object[]]$AllPaths = @(
    # '$Recycle.Bin'
    '0_videos created by jake'
    '2020_11_from_E'
    '2020-data-secondary'
    # 'acroldr'
    # 'AI_RecycleBin'
    # 'apps'
    'bin_nin'
    # 'cache'
    # 'Config.Msi'
    # 'data_from_2019'
    # 'davinci resolve db'
    # 'Documents and Settings'
    # 'ESD'
    'Games'
    'GoG Games'
    # 'NVIDIA'
    # 'PerfLogs'
    'Program Files'
    'Program Files (x86)'
    'ProgramData'
    'Programs'
    'Programs (x86)'
    # 'Python27'
    # 'Recovery'
    # 'spotify_buffer'
    # 'System Volume Information'
    'temp_delete_1month'
    # 'Use
    # 'Windows'
    #     '$Recycle.Bin'
    # '0_videos created by jake'
    # '2020_11_from_E'
    # '2020-data-secondary'
    # 'acroldr'
    # 'AI_RecycleBin'
    # 'apps'
    # 'bin_nin'
    # 'cache'
    # 'Config.Msi'
    # 'data_from_2019'
    # 'davinci resolve db'
    # 'Documents and Settings'
    # 'ESD'
    # 'Games'
    # 'GoG Games'
    # 'NVIDIA'
    # 'PerfLogs'
    # 'Program Files'
    # 'Program Files (x86)'
    # 'ProgramData'
    # 'Programs'
    # 'Programs (x86)'
    # 'Python27'
    # 'Recovery'
    # 'spotify_buffer'
    # 'System Volume Information'
    # 'temp_delete_1month'
    # 'Users'
    # 'Windows'
) | Get-Item

if ($false) {
    # before loop
    $Cfg.Source = 'T:\2020_11_from_E'
    # $Cfg.Dest = Join-Path $Cfg.DestRoot '2ls020_11_from_E'
    $Cfg.Dest = Join-Path $Cfg.DestRoot '2020_11_from_E'
    $Cfg.Log = Join-Path $Cfg.DestRoot 'robo.copy.log'
}
$AllPaths | ForEach-Object { 
    $curOuterPath = $_

    # $Cfg.Source = Join-Path 'T:' $curOuterPath
    $Cfg.Source = Get-Item $curOuterPath -ea stop 
    # $Cfg.Dest = Join-Path $Cfg.DestRoot '2ls020_11_from_E'
    $Cfg.Dest = Join-Path $Cfg.DestRoot $curOuterPath.BaseName #'2020_11_from_E'
    $Cfg.Log = Join-Path $Cfg.DestRoot 'robo.copy.log'

    Push-Location $Cfg.DestRoot

    # 'H:\robo_root\Told_clone\foo'
    $AllPaths | join.ul -Options @{ ULHeader = (hr 0) ; ULFooter = (hr 0); }

    if ($false) { 
        # Robo.Copy @robo_splat -CommandPassThru
        Robo.Copy @robo_splat -CommandPassthru
        # Robo.Copy @robo_splat
        # some non-text is emitting
        $render_args = Robo.Copy @robo_splat -WhatIf -infa Ignore -Debug:$false -Verbose:$false
        $render_args = Robo.Copy @robo_splat -WhatIf
        Robo.Copy @robo_splat -Recurse -LimitOutput
    }
    # Robo.Copy @robo_splat -WhatIf

    ToastIt -Title '🤖Robo.Copy' -Text '🟢 started'
    # Robo.Copy @robo_splat -Recurse -LimitOutput -Confirm
    # Robo.Copy @robo_splat -Recurse -WithoutWhatIf
    Robo.Copy @robo_splat -Recurse -WithoutWhatIf -LimitOutput
    ToastIt -Title '🤖Robo.Copy' -Text '🔴 completed'
}