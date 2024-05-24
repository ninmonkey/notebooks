<#
about: using the ChatGPT Streaming API
from: NoahP @  <https://discord.com/channels/180528040881815552/447476117629304853/1238630446695317624>

see also:
- https://platform.openai.com/docs/api-reference/streaming
- https://developer.mozilla.org/en-US/docs/Web/API/Server-sent_events/Using_server-sent_events#event_stream_format#named_events

#>

$Message = "write a powershell script to send an email using graph API"
$webrequest = [System.Net.HttpWebRequest]::Create("https://api.openai.com/v1/chat/completions")
$Body = @{
    "model"       = "gpt-3.5-turbo"
    "top_p"       = 1
    "temperature" = 0.7
    "stream"      = $true
    "messages"    = @(
        @{
            role    = "user"
            content = $Message
        }
    )
} | ConvertTo-Json
$webrequest.Headers.Add("Authorization", "Bearer " + $Token )
$RequestBody = [byte[]][char[]]$body
$webrequest.Method = "POST"
$webrequest.ContentType = 'application/json'
$RequestStream = $webrequest.GetRequestStream()
$RequestStream.Write($RequestBody, 0, $RequestBody.Length)

$responseStream = $webrequest.GetResponse().GetResponseStream()
$streamReader = [System.IO.StreamReader]::new($responseStream)
do {
    $chunk = $streamReader.ReadLine()
    if ($chunk -notlike "*DONE*") {
        $word = ($chunk -replace "^data:" | ConvertFrom-Json).choices.delta.content
        Write-Host $Word -NoNewline
    }
    else {
        "`n"
    }
}
until ($chunk -like "*DONE*")
