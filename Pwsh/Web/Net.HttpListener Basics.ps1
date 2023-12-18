function Log {
    param(
        [ArgumentCompletions('Listener', 'Response', 'Context', 'Other')]
        [Parameter()]
        $Who,
        [ArgumentCompletions('ctor', 'Close', 'Start', 'End')]
        [Parameter()]
        $What,
        [Parameter()]
        $Message = ''
    )
    $Color = switch ($Who) {
        'Listener' { 'lightblue' }
        'Context' { 'lightgreen' }
        'Response' { 'orange' }
        default { 'darkyellow' }
    }
    "${Who}::${What} ${Message}" | Write-Host -bg $Color -fg black
}

'tip: Open a new window and run

    > irm http://localhost:9090
' | write-host -fore red


Log Listener ctor
[Net.HttpListener]$Listen = @{}

$listen.Prefixes.add('http://localhost:9090/')

Log Listener Start
$Listen.Start()

Log Context ctor
$ctx = $Listen.GetContext()
$ctx.Response.StatusCode = 200
$ctx.Response.ContentType = 'text/html'
$message = 'hi world 🐒 !'
$byte_str = [Text.Encoding]::UTF8.GetBytes( $message )
$json = ($ctx.Response | ConvertTo-Json -wa 0 -Depth 0 -Compress)

Log Response Other $Json
Log Context Write $byte_str.Length
$ctx.Response.OutputStream.Write( $byte_str, 0, $byte_str.Length )

Log Response Close
$ctx.Response.close()

Log Listener Close
$listen.Close()

<#
for async,
    $task = $httpListener.GetContextAsync()
    while (-not $task.AsyncWaitHandle.WaitOne(200)) { }
    $context = $task.GetAwaiter().GetResult()
#>
