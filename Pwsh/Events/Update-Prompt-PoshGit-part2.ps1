@'
from: @DR (Szeraax)
context: <https://discord.com/channels/180528040881815552/447476117629304853/1177149737321893938>
'@
$GitPromptSettings.DefaultPromptSuffix = '$($global:pos = [console]::GetCursorPosition()) $((Get-History -Count 1).Duration.ToString() -replace "^(00:)+" -replace "^0" -replace "(?<=\.\d{2}).*")$($PSStyle.Foreground.BrightCyan)[$(Get-date -f "HH:mm:ss")]$($PSStyle.Reset)' + $GitPromptSettings.DefaultPromptSuffix.Text
$timer = [System.Timers.Timer]::new()
$timer.Interval = 1000
$timer.AutoReset = $true
$action = {
    $currentPos = [console]::GetCursorPosition()
    if ($global:lastupdatetime -lt (Get-Date).AddSeconds(-2)) {
        $global:pos = [console]::GetCursorPosition()
    }
    $global:lastupdatetime = get-date
    [console]::SetCursorPosition(0,$Global:pos.item2)
    [console]::Write((prompt))
    [console]::SetCursorPosition($currentPos.Item1, $currentPos.Item2)
}
$start = Register-ObjectEvent -InputObject $timer -SourceIdentifier 100 -EventName Elapsed -Action $action
$timer.start()
