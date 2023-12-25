using namespace System.Diagnostics
using namespace System.Timers
using namespace System.Collections.Generic


'event prompttest, context here and earlier: <https://discord.com/channels/180528040881815552/447476117629304853/1177138420615745637>'
| write-verbose -Verbose
$eventId = 'UpdatePrompt'

try {
    Unregister-Event $eventId
}
catch {
    $_ | Join-String -op 'UnregisterEvent: ' | Write-warning
}

[Stopwatch]$W = @{}
[Timer]$Timer = @{
    Interval = 1000
    Enabled = $True
    AutoReset = $true
}

$timerArgs = @{
    InputObject = $timer
    EventName = 'Prompt.TimerCallback'
    SourceIdentifier = $eventId
    Action = {
        param( $e)
        $date = [DateTime]::Now.ToString("MM/dd/yyyy HH:mm:ss")
        $function:prompt = { "$date> " }.GetNewClosure()
        $Date | Dotils.Write-DimText | Infa
    }
}
$event = Register-ObjectEvent @timerArgs
$timer.Start()
