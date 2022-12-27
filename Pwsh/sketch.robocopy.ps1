$Paths = @{ SourceRootDir = Get-Item 'G:/temp/robocopy/src' -ea 'stop'
    DestRootDir           = 'G:/temp/robocopy/dest'
    LogLast = 'G:/temp/robocopy/lastInvoke.log'
}

$Paths | Format-Table -auto
function test.Build.Examples {
    # cleanup destination
    '-> cleanup old /dest/'
    Remove-Item -Path $Paths.DestRootDir -Force -Recurse
    New-Item -ItemType Directory -Force -Path $Paths.DestRootDir

    '-> generate new /src'
    New-Item -ItemType File -Force -Path (Join-Path $Paths.SourceRootDir 'logs/main.log')
    New-Item -ItemType Directory -Force -Path (Join-Path $Paths.SourceRootDir 'logs/main.log')
}

function __main.iter1verbose {
    test.Build.Examples

    # state
    test.Gci Src
    hr
    test.Gci Dest
    hr

    h1 'copy'
    robocopy @(
        $Paths.SourceRootDir
        $Paths.DestRootDir
        # '/L' # -WhatIf
    )

    hr
    $ErrorActionPreference = 'break'
    # state
    test.Gci Src
    hr
    test.Gci Dest
    hr
    $ErrorActionPreference = 'continue'
}

function __main { # iter2, short
    test.Build.Examples

    # # state
    # test.Gci Src
    # hr
    # test.Gci Dest
    # hr

    test.Gci -Where Dest
    h1 'copy'
    & 'robocopy' @(
        $Paths.SourceRootDir
        $Paths.DestRootDir
        # '/L' # -WhatIf
    ) *>&1 | Set-content -path $Paths.LogLast -PassThru
    sleep 1
    test.Gci -Where Dest

    # hr
    # $ErrorActionPreference = 'break'
    # # state
    # test.Gci Src
    # hr
    # test.Gci Dest
    # hr
    # $ErrorActionPreference = 'continue'
}

function test.Gci {
    param(
        [ValidateSet('Src', 'Dest')]
        [String]$Where = 'Src'
    )
    h1 "Where: $Where"
    $Target = switch ($Where) {
        'Src' { $Paths.SourceRootDir }
        'Dest' { $Paths.DestRootDir }
        default { "UnhandledSetName: $_" }
    }

    & 'fd' @('--search-path', (Get-Item $Target )) #-ea stop) )
}


__main