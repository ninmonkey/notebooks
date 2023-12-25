write-warning 'not quite working without'
$EventId = 104
Unregister-Event $eventId
$GitPromptSettings.DefaultPromptSuffix = ' $($PSStyle.Foreground.BrightCyan)[$(Get-date -f "HH:mm:ss")]$($PSStyle.Reset)' +
    '-suffix'
    # ( $GitPromptSettings)?.DefaultPromptSuffix.Text
$timer = [System.Timers.Timer]::new()
$timer.Interval = 1000
$timer.AutoReset = $true
$action = {
    [Microsoft.PowerShell.PSConsoleReadLine]::GetOptions().
    PromptText = Invoke-Expression (
        '"{0}"' -f @(
            'otherSuffix'
            # ($GitPromptSettings)?.DefaultPromptSuffix.Text ?? '.'
        )
    )
}
$start = Register-ObjectEvent -InputObject $timer -SourceIdentifier $EventId -EventName Elapsed -Action $action
$timer.start()
