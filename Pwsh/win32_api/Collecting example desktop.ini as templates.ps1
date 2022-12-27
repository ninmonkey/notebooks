# Collecting desktop Template Shell32 files

$Cfg = @{
    DestRoot = gi 'G:\temp\shell32 templates'
}

function SearchForIni { 
    <#
    .SYNOPSIS
        local possible desktopini files
    #>
    [CmdletBinding()]
    param(
        [string]$PathRoot,
        [switch]$Recurse, [int]$Depth,
        # not only destkop but others
        [Alias('IncludeOtherFilenames')]
        [switch]$All
    )
    
    $lsSplat = @{
        Force  = $true
        Path   = gi -ea 'stop' $PathRoot  
        Filter = '*.ini'
    }
    if ($lsSplat.ContainsKey('Recurse') -and $lsSplat.Contains('Depth')) { 
        $lsSplat.Remove('Recurse') # it's implicitly depth, otherwise it would be nonsensical
    }
    if ($Recurse) { $lsSplat.Recurse = $true }
    if ($Depth) { $lsSplat.Depth = $Depth }
    
    $lsSplat | ft -auto | oss | write-debug
    
    $query = ls @lsSplat
    $query | Join-String -sep ', '  Name -op ('Found {0} files:... ' -f $query.count )
    | Write-verbose
    if ( $All ) {
        return $query
    }

    $query = $query | ? Name -eq 'desktop.init'
    return $query
}

$searchForIniSplat = @{
    PathRoot = 'C:\Users\cppmo_000\SkyDrive\Documents\2021\dotfiles_git'
}

SearchForIni @searchForIniSplat
function FindDesktopIni {
    <#
    .SYNOPSIS
        grabs a directory, and the desktop.ini file it uses
    .notes
        related info: getting icons used by *.lnk files (not  folders)
    #>
    [CmdletBinding()]
    param(
        [Alias('InputObject')]
        [string]$Path,
        [string]$DestRoot = ${script:Cfg.DestRoot},

        # can return a resolved path, but does not modify or mutate any states
        [ALias('PassThru')]
        [switch]$TestOnly
    )

    $SourceItem = Get-Item -ea stop $Path
    $ExportLabel = $SourceItem | Split-Path -Leaf    
    if ( [string]::IsNullOrWhiteSpace( $ExportLabel  )) {
        throw "Export Label was invalid whitespace"
    }

    # [Nullable[PSObject]]$desktopIni? 
    
    $desktopIni? = Get-Item -force -ea 'continue' -path (Join-Path $SourceItem 'desktop.ini' )
    
    $Dbg = @{
        Source           = $SourceItem
        Label            = $ExportLabel
        isDir            = $SourceItem.PsIsContainer
        SpecialChildList = gci $SourceItem -Force *.ini | join-string -sep ', ' -DoubleQuote -op 'list inis: = '        
        'Found Ini?'     = $Null -ne $desktopIni?
        Obj              = $desktopIni? ?? $null 
        # 'desktopIni?' = Get-Item -ea 'continue' -path (Join-Path $SourceItem 'desktop.ini' )

    }
    $new_dirName = Join-path $Cfg.DestRoot $ExportLabel    
    $new_iniName = Join-path $Cfg.DestRoot $ExportLabel 'desktop.ini'
    
    $dbg += @{
        newDirName = $new_dirName
        newIniName = $new_iniName
    }
    $Dbg | ft -auto | oss | Write-Information

    'Adding Label = {0}, Dir = {1}' -f @( 
        $ExportLabel
        $new_dirName
    ) | write-verbose
    mkdir -Path $new_dirName -ea 'ignore'
    
    Remove-Item -Path $new_iniName  -Force -Confirm
    
    
    
    'Creating: file: label/desktop.ini' | write-verbose
    Copy-Item -Path $desktopIni? -Destination $new_iniName 
    # $new_destDir = New-Item -path (Join-Path $SourceItem $ExportLabel) -ItemType Directory -Pass
    # $new_deskItem = Join-Path
    # copy-item -Path $desktopIni? -Destination $NewDestFolder


    $desktopIni?.FullName
    if ($TestOnly) {
        return $dbg
    }
    
    
    $Dbg | ft -auto | oss | Write-Information


}

$findDesktopIniSplat = @{
    Path              = 'C:\Users\cppmo_000\SkyDrive\Documents\2022\dotfiles_git'
    Verbose           = $true
    InformationAction = 'Continue'
    # TestOnly          = $true
}

$targetDir = Get-Item $findDesktopIniSplat.Path
$res = FindDesktopIni @findDesktopIniSplat -TestOnly -ea break 
$res | ft -auto 
hr
gci $cfg.DestRoot -Recurse *
hr