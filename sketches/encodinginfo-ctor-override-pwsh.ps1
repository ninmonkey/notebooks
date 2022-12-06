# $b.paste2_nl = @'
# a
# b
# '@


function encinfo {
    param(
       $InputObject
    )
    throw 'demo wip, see whether Pwsh function can property coerce to the string and int or only string and object'
    [Text.Encoding]::GetEncoding( $InputObject )
}

[Text.Encoding]::GetEncoding(1252)
[Text.Encoding]::GetEncoding('utf-8')
[Text.Encoding]::GetEncoding('utf-16le')
[Text.Encoding]::GetEncoding('utf-16be')

# breaks
if($false) {
[Text.Encoding]::GetEncoding('1252')
[Text.Encoding]::GetEncoding('oem')
}