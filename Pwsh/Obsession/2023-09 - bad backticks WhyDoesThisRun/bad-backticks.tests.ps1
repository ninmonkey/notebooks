BeforeAll {
    $PSStyle.OutputRendering = 'ansi'

    $SrcAsLiteral = @'
        Microsoft.PowerShell.Management\`Get-Item .
        Microsoft.PowerShell.Management`\Get-Item .
        Microsoft.PowerShell.Management\`Get-Item .
        Microsoft.PowerShell.Management\Get-Item .
        Microsoft.PowerShell.Management\`Get-Item .
        Micros``oft.PowerShell.Management`\Get-Item .
        M`icrosoft.`PowerShell.Management\`Get-Item .
        Microsoft.PowerShell.Management\Get-Item .
'@
    h1 'All of these commands run without errors in the console. Even the one with two escapes' | Out-Host
    $SrcAsLiteral | write-host -back darkGreen -fore Blue
    hr | out-host
}

Describe 'Fully Resolved With Backticks Break' {
    It 'TryOne Should Break' -ForEach @(
        { Microsoft.PowerShell.Management\`Get-Item . }
        { Microsoft.PowerShell.Management`\Get-Item . }
        { Microsoft.PowerShell.Management\`Get-Item . }
        { Microsoft.PowerShell.Management\Get-Item . }
        { Microsoft.PowerShell.Management\`Get-Item . }
        { Micros``oft.PowerShell.Management`\Get-Item . }
        { M`icrosoft.`PowerShell.Management\`Get-Item . }
        { Microsoft.PowerShell.Management\Get-Item . }
    ) -Test {
        "Item: Item"
         { $_ } | Should -Throw
        # $_ | Should -NotThrow
        # $Null -eq $_.GetType()
        # | SHould -Be $null

    }
}