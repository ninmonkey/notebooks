function RemoveAccents { 
    <#
    .synopsis
      Strip accents from text using cyrillic encoding
    .notes
        warning: this is a simple method, but does remove non-accented characters that weren't encodable
        it's a single-byte encoding
    #>
    param( [string] $Text )
    $enc = [Text.Encoding]::GetEncoding('iso-8859-5')
    $enc.GetString( $enc.GetBytes( $Text ) )
}

RemoveAccents 'foo bår'
    # output: foo bar 

RemoveAccents 'foo 🐒 bar'
    # output: foo ?? bar

<#
I'm not 100% this is the best cyrillic to use, there's a few 

Pwsh> [Text.Encoding]::GetEncodings() | ? displayname -Match 'cyr|cry'

CodePage Name           DisplayName
-------- ----           -----------
   20880 IBM880         IBM EBCDIC (Cyrillic Russian)
     866 cp866          Cyrillic (DOS)
   21866 koi8-u         Cyrillic (KOI8-U)
    1251 windows-1251   Cyrillic (Windows)
   10007 x-mac-cyrillic Cyrillic (Mac)
   28595 iso-8859-5     Cyrillic (ISO)
   20866 koi8-r         Cyrillic (KOI8-R)
     855 IBM855         OEM Cyrillic
   21025 cp1025         IBM EBCDIC (Cyrillic Serbian-Bulgarian)

#>
