'event prompttest, context here and earlier: <https://discord.com/channels/180528040881815552/447476117629304853/1177138420615745637>'
| write-verbose -Verbose
$eventId = 'UpdatePrompt'

try {
    Unregister-Event $eventId
}
catch {}

$timer = New-Object Timers.Timer -Property @{
    Interval = 1000
    Enabled = $true
    AutoReset = $true
}
$timerArgs = @{
    InputObject = $timer
    EventName = 'Elapsed'
    SourceIdentifier = $eventId
    Action = {
        param($e)
        $date = [DateTime]::Now.ToString("MM/dd/yyyy HH:mm:ss")
        $function:prompt = { "$date> " }.GetNewClosure()
        $Date | Dotils.Write-DimText | Infa
    }
}
$event = Register-ObjectEvent @timerArgs
$timer.Start()
