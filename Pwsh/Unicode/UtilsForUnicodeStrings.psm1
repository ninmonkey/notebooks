function UnicodeLength {
    <#
    .SYNOPSIS
     this gives the "length" of a string in terms of codepoints (aka runes)
    .EXAMPLE
        > UnicodeLength '🐒'
        1

        > '🐒'.Length
        2

        > UnicodeLength 'a🐒c'
        3

    #>
   param( [string]$String )
   ( $String.EnumerateRunes().Value ).count
}

function ShowHex {
    <#
    .SYNOPSIS
        converts numbers to hex
    #>
    [OutputType( [string] )]
    param()

    $input | join-string -f ' {0,4:x}' -sep ''
    # $Input | join-string -f ' {0,-4:x}'

    # or for the ToString('x') equivalent:
    # $Input | join-string -f '{0:x}'
}

$script:Enc8  = [Text.Encoding]::GetEncoding('utf-8')
$script:Enc16 = [Text.Encoding]::GetEncoding('utf-8')

Export-ModuleMember -Function @( '*' ) -Alias @( '*') -Variable @('Enc*')
