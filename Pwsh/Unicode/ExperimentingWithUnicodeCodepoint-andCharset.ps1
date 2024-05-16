# preview a list of possible Encoding class names
[Text.Encoding]::GetEncodings().ForEach({ $_.GetEncoding().GetType() }) | Sort-object -Unique FullName|ft

# Grab the windows ones
( $enc_winX =
    [Text.Encoding]::GetEncodings().
        Where({ $_.CodePage -match '125\d+' }) )
| ft

$enc_winX.GetEncoding()|Ft



$Rune = 'ë  '
# return an object of before and after encoding the character for ervery encoding


# $_      -is [EncodingInfo]
# $curEnc -is [Encoding]
$query = $enc_winX.ForEach({
    $curEnc = $_.GetEncoding()
    $Bytes  = $curEnc.GetBytes( $Rune )

    $info   = [ordered]@{
        Enc_Codepage = $_.CodePage
        Enc_Name     = $_.Name
        Enc_Display  = $_.DisplayName
        Bytes        = $Bytes
        BytesHex     = $Bytes
            | Join-String -f '{0:x}' -sep ' '

        Before      = $Rune
        Enc_TypeName = $curEnc.GetType().FullName
    }

    [pscustomobject]$info
})

$query
| Ft -auto
