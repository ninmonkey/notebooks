$AutoRunGridViewSelect = $false 
@'
## About

Finding Collecting desktop Template Shell32 files

## core links:
- [Locating Redirect Registry Strings](https://learn.microsoft.com/en-us/windows/win32/intl/locating-redirected-strings)
- [Registry-String Formatting / schema](https://learn.microsoft.com/en-us/windows/win32/intl/using-registry-string-redirection#create-a-language-neutral-resource)

    @<PE-path>,-<stringID>[;<comment>]
    
- [Prepare Resources for a Shortcut Using INF Format](https://learn.microsoft.com/en-us/windows/win32/intl/using-registry-string-redirection#prepare-resources-for-a-shortcut-using-inf-format)

>  This syntax assumes the use of [StartMenuItems] support from Setup, similar to the syntax used in Syssetup.inf.

    [StartMenuItems]
    <description> = <binary>,<commandline>,<iconfile>,<iconnum>,<infotip>,<resDLL,resID>


> Use the syntax shown below when using INF to add items, for example, an Access Group folder, to the Start menu. This syntax assumes the use of [StartMenuItems] support from Setup, similar to the syntax used in Syssetup.inf.

    [CalcInstallItems]
    "Name" = %Calc_DESC%
    "CmdLine" = 11, calc.exe
    "SubDir" = %Access_GROUP%
    "WorkingDir" = 11

    "InfoTip" = "@%systemroot%\system32\shell32.dll,-22531"

    "DisplayResource" = "%systemroot%\system32\shell32.dll",22019

## ...


## Others / tangents

- maybe more: <https://learn.microsoft.com/en-us/windows/win32/msi/shortcut-table>
    - <https://learn.microsoft.com/en-us/windows/win32/msi/feature-table>
- [aux verbs](https://learn.microsoft.com/en-us/windows/win32/intl/using-registry-string-redirection#create-resources-for-verb-protocol-and-auxusertype-strings)

'@

$Cfg = @{
    DestRoot = gi 'G:\temp\shell32 templates'
}

$Query ??= @{ }
$Query.UserProfile3 ??= SearchForIni -PathRoot C:\Users\cppmo_000 -Depth 3
$Query.UserProfile_all3 ??= SearchForIni -PathRoot C:\Users\cppmo_000 -Depth 3 -All
if ($AutoRunGridViewSelect) { 

    if ( -not (gcm 'fzf' -ea ignore -CommandType Application )) {
        $Query.UserSelect ??= $Query.UserProfile_all3 | % Fullname | sort | fzf -m
    }
    else { 
        'is fzf not in path? '
        # $Query.UserSelect ??= $Query.UserProfile_all3 | % Fullname | sort | Out-GridView -PassThru
        $Query.UserSelect ??= $Query.UserProfile_all3 | sort | select Name, Directory | Out-GridView -PassThru | gi 
    }
}


function SearchForIni { 
    <#
    .SYNOPSIS
        search for directories paired with 'desktop.ini'
    .notes
    .future:
        make it stepp-able? currently it can't stream
    .example
        Ps> SearchForIni -PathRoot C:\Users\cppmo_000\SkyDrive\Documents\2021 -Depth 2

        Ps> searchForIni -PathRoot C:\Users\cppmo_000 -Depth 2 -Verbose | Ft Name, FullName
    #>
    [CmdletBinding()]
    param(
        [string]$PathRoot,
        [switch]$Recurse, [int]$Depth,
        # not only destkop but others
        [Alias('IncludeOtherFilenames')]
        [switch]$All
    )
    write-warning 'does not currently copy all folder attributes'
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

    $query = $query | ? Name -eq 'desktop.ini'
    return $query
}

$searchForIniSplat = @{
    PathRoot = 'C:\Users\cppmo_000\SkyDrive\Documents\2021\dotfiles_git'
}

SearchForIni @searchForIniSplat
function GetDesktopIni {
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
    
    Remove-Item -Path $new_iniName  -Force -Confirm -ea 'ignore'
    
    
    
    'Creating: file: label/desktop.ini' | write-verbose
    $__q = Copy-Item -Path $desktopIni? -Destination $new_iniName 
    # $new_destDir = New-Item -path (Join-Path $SourceItem $ExportLabel) -ItemType Directory -Pass
    # $new_deskItem = Join-Path
    # copy-item -Path $desktopIni? -Destination $NewDestFolder


    $desktopIni?.FullName
    if ($TestOnly) {
        return $dbg
    }
    
    
    $Dbg | ft -auto | oss | Write-Information


}
@'
cached queries, try:

    $targetDir = Get-Item $findDesktopIniSplat.Path
    $res = GetDesktopIni @findDesktopIniSplat -TestOnly -ea break 
    $res | ft -auto 
    hr
    gci $cfg.DestRoot -Recurse *
    hr

    $Query.Keys

'@ | write-warning 

# . { 
# run examples
SearchForIni -PathRoot ~ -Depth 1 | ft name, fullname

$findDesktopIniSplat = @{
    Path              = 'C:\Users\cppmo_000\SkyDrive\Documents\2022\dotfiles_git'
    Verbose           = $true
    InformationAction = 'Continue'
    # TestOnly          = $true
}
$findDesktopIniSplat.Path = 'C:\Users\cppmo_000\SkyDrive\Documents\2021\dotfiles_git\everythingSearch'

$targetDir = Get-Item $findDesktopIniSplat.Path
$res = GetDesktopIni @findDesktopIniSplat -TestOnly -ea break 
$res | ft -auto 
hr
gci $cfg.DestRoot -Recurse *
hr
# }
write-warning 'remove initial markdown, move to MD doc '


throw 'Left off:
- [ ] need to copy **Directory** so that attributes are preserved
'

