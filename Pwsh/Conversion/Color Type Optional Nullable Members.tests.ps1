BeforeAll {
    '::PSCommandPath: {0}' -f (Get-Item $PSCommandPath ) | Write-Host -fg orange
    $Src = $PSCommandPath -replace '\.tests\.ps1$', '.ps1'
    Write-Warning "Try $Src"
    # . (Get-Item -ea 'continue' $Src)
    # . (Get-Item -ea 'stop' $Src)
}

Describe 'nb.ColorRGBA' {
    BeforeAll {
        '::PSCommandPath: {0}' -f (Get-Item $PSCommandPath ) | Write-Host -fg orange
        '::PSCommandPath: {0}' -f ($PSCommandPath ) | Write-Host -fg orange
        '::PSCommandPath: {0}' -f (Get-Item $Src ) | Write-Host -fg orange
        $Src = $PSCommandPath -replace '\.tests\.ps1$', '.samples.ps1$'
        [Collections.Generic.List[Object]]$Samples = @(
            # . (Get-Item -ea 'continue' $Src) | CountOf -CountLabel 'samples count'
        )

    }
    It 'c-tor runs' -ForEach @(

    ) {
        [ColorRGBA]::new()
    }
    It 'HasAlpha' {}
}
