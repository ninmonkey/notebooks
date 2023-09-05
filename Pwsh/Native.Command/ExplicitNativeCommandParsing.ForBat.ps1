function bp4 {
    <#
    .SYNOPSIS
        demonstrate native invoking native command breaks passed paths with Pwsh7.3.6 unless you set legacy
    .NOTES
        the filename of the command changes some automatic behavior. Like using 'git' vs 'git.exe' causes the same binary to act differently
    #>
    param(
        [switch]$UsingLegacy
        #, [Management.Automation.NativeArgumentPassingStyle]$UsingStyle
    )
    if($UsingLegacy) {
        $LastPSNative = $PSNativeCommandArgumentPassing
        $PSNativeCommandArgumentPassing
            | Join-string -f 'was {0}' | write-verbose -verb
        # ....
        $PSNativeCommandArgumentPassing =
            [System.Management.Automation.NativeArgumentPassingStyle]::Legacy
        $PSNativeCommandArgumentPassing
            | Join-string -f 'was {0}' | write-verbose -verb
    }
    $items = @( $input )
    $items ??= gci . -name -depth 2 -File

    $items
        | Where-Object { $null -ne $_ } # Where-IsNotBlank
        | fzf.exe -m --preview 'bat --style=snip,header,numbers --line-range=:200 "{}"'

    if($UsingLegacy) {
        $PSNativeCommandArgumentPassing = $LastPSNative
    }
    $PSNativeCommandArgumentPassing
        | Join-string -f 'was {0}' | write-verbose -verb
}

function tryExplicit {
    gci . -name -depth 2 -File | bp4 -UsingLegacy
}
function tryImplicit {
    gci . -name -depth 2 -File | bp4
}

@'
to test: run commands, or try the alias:

    tryExplicit
    gci . -name -depth 2 -File | bp4 -UsingLegacy

    tryImplicit
    gci . -name -depth 2 -File | bp4

I am able to reproduce the broken piping using tryImplicit using no profile

> pwsh -nop
> . 'ExplicitNativeCommandParsing.ForBat.ps1'
> tryImplicit
    # filepath errors when bat is invoked by fzf itself

> tryImplicit
    # same paths are now valid

'@