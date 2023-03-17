
<#
I have a tendancy to make examples convoluted, so take the use with a grain of salt.
#>

function Join-EncodedText {
    param(
        # note: join-string filters nulls
        [Parameter(ValuefromPipeline)]
        [string]$InputText,

        [Parameter(position = 0)]
        [ArgumentCompletions('utf-8', 'Unicode', 'utf-16-le')]
        [string]$EncodingName
    )
    begin {
        $encInfo = [System.Text.Encoding]::GetEncoding( $EncodingName )
        # $encUnicode
        # $enc.GetString( $enc.GetBytes('sdf') )
    }
    process {
        $InputText | Join-string -op 'Input: ' |  Write-Host #-ForegroundColor yellow
        $InputText.EnumerateRunes().Value | Join-string -op 'Runes: ' -sep ' ' |  Write-Host -ForegroundColor yellow
        $InputText.EnumerateRunes().Value | Join-string -op 'Codepoint: ' -sep ' ' -form '0x{0:x4}'  |  Write-Host -ForegroundColor red

        $bytes = $encInfo.GetBytes( $InputText )
        $bytes | Join-String -sep ' ' -FormatString '{0:x2}' -op "<${EncodingName}>: " | Write-Host -ForegroundColor green
        $bytes | ConvertTo-Base64 |  Join-String -op "<${EncodingName} as Base64>: "  | Write-Host -ForegroundColor blue
        ''|out-host
        return $bytes | ConvertTo-Base64
    }

}

$OutObj = 'Hi World', '🐧' | Join-EncodedText -EncodingName utf-8
$OutObj = 'Hi World', '🐧' | Join-EncodedText -EncodingName Unicode

# return
write-warning  'finish me. 2023-03-17'

Get-ChildItem ~ -file
| Select-Object -First 7
| Join-String { '[{0}]({1})' -f @(
        $_.Name
        $_.FullName
    ) } -sep "`n"

Get-ChildItem ~ -file
| Select-Object -First 7
| Join-String { '[{0}](file:///{1})' -f @(
        $_.Name
        $_.FullName
    ) } -sep "`n- " | sc -path 'temp:\render.md' -passthru