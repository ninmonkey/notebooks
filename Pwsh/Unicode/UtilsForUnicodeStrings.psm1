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
$script:Enc16 = [Text.Encoding]::GetEncoding('utf-16le')

@'
## Try:

$enc8 and $enc16 are shorthand for using that specific encoding

$InputText = '🐒'
$bytes_As8 = $enc8.GetBytes( $InputText )
    # value:  240, 159, 144, 146

$str       =
    $enc8.GetString(
        $enc8.GetBytes( $InputText )
    )

$str -eq $InputText
    # true. it's around trip!

( When you remove module, it will remove the variables that were exported )

We care about two functions on [Text.Encoding]

GetBytes:
    input: String, output: Bytes
    this takes text, converting them to their bytes representation for this specific encoding
GetString:
    input: Bytes, Output: String
    this takes bytes and converts them back into strings

'@ | write-verbose -verbose


Export-ModuleMember -Function @( '*' ) -Alias @( '*') -Variable @('Enc*')
