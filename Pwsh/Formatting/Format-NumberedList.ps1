

function Format.NumberedList {
    <#
    .SYNOPSIS
        Like the linux command 'nl' with property support
    .EXAMPLE
        Pwsh🐒> 'a'..'d' | Format.NumberedList

        Pwsh🐒> Get-process pwsh | Fmt.NL -PropertyName id | Join-String -sep ', '

            1: 2544, 2: 5584, 3: 12068, 4: 17584, 5: 19916, 6: 25344, 7: 25664, 8: 32328

    .EXAMPLE
        Pwsh🐒> 'a'..'d' | Format.NumberedList

            1: a
            2: b
            3: c
            4: d
    .example
        Pwsh🐒> Get-Process  pwsh | Format.NumberedList Id
            1: 11692
            2: 17584
            3: 25664

        Pwsh🐒> Get-Process  pwsh | Format.NumberedList Name
            1: pwsh
            2: pwsh
            3: pwsh

        Pwsh🐒> Get-Process  pwsh | Format.NumberedList

            1: System.Diagnostics.Process (pwsh)
            2: System.Diagnostics.Process (pwsh)
            3: System.Diagnostics.Process (pwsh)
    #>
    [OutputType('System.String')]
    [Alias('Fmt.NL', 'NL')]
    param(
        [ArgumentCompletions('Name', 'FullName', 'Extension', 'Path')]
        [string]$PropertyName
    )
    $Input | Foreach-Object {
        $LineNo++

        $Value = if($PropertyName) {
            $_.$PropertyName
        } else { $_ }

        "${lineNo}: {0}" -f $Value
    }
}

'a'..'d' | Format.NumberedList
# hr
Get-process pwsh | Fmt.NL -PropertyName id | Join-String -sep ', '
# hr
Get-Process  pwsh | Fmt.NL Id

# hr
gci . -File | select -first 6 | Fmt.NL -PropertyName Name
# hr
gci . -File | select -first 6 | Fmt.NL -PropertyName Extension
# hr

# Silly example that outputs a numbered list of numbered strings

Get-Process
    | Group-Object Name | Sort-Object Count
    | ?{ $_.count -gt 1 }
    | %{ @(
        $_.Name
        $_.Group
            | Fmt.NL id
            | Join-String #-sep '' -SingleQuote
    ) | Join-String -sep ' => ' } | Fmt.NL
