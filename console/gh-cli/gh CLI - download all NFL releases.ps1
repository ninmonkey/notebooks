$nativeGH = Get-Command -CommandType Application -Name 'gh' -ea ignore
if(-not $NativeGH) {
    throw "Required 'gh' command not installed, see: <https://cli.github.com/>"
}

function find_releaseNames {
    # autodetect rleases
    $q = & $nativeGH release list --repo nflverse/nflverse-data
    $q | %{ $_ -split '\s+' | s -First 1 }
}

function Hr {
    # horizontal rule
    $w = $host.ui.RawUI.WindowSize.Width
    $chars = '-' * $w -join ''
}

function collect_NFLRelease {
    [CmdletBinding()]
    param(
        <#
        .SYNOPSIS
            sugar to invoke 'gh release download's
        .LINK
            https://cli.github.com/manual/gh_release
        .LINK
            https://stedolan.github.io/jq/manual/v1.6/
        #>
        # 4oot directory, will create subdirectories
        [Alias('Path')][Parameter(Mandatory)]$BasePath
    )
    if( -not (Test-Path $BasePath)) {
        mkdir -path $BasePath
    }

    Set-Location $BasePath

    $items = find_releaseNames
    $items | %{
        $name = $_
        'writing "{0}" from nflverse/nflverse-data release to "{1}"' -f @(
            $name
            Join-Path '.' $Name
        ) | Write-Information
        & $nativeGH release download $name --dir $name --repo nflverse/nflverse-data
    }
}

collect_NFLRelease -infa 'continue' -path 'C:\nin_temp\nfl-src'