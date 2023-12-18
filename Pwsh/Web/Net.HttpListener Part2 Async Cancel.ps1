function Log {
    param(
        [ArgumentCompletions('Listener', 'Response', 'Context', 'Other', 'Task')]
        [Parameter()]
        $Who,
        [ArgumentCompletions('ctor', 'Close', 'Start', 'End', 'Wait', 'Sleep')]
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

    > irm http://localhost:9092
' | write-host -fore red

if( $listen.IsListening ) {
    throw 'nope'
    # or
    $Listen.Dispose()
    $Listen = $Null
}

[Net.HttpListener]$Listen = @{}
$listen.Prefixes.add('http://localhost:9098/')
$Listen.Start()

Log Task Start 'Async Wait'
$task = $Listen.GetContextAsync()
try {
    while ( -not $Task.AsyncWaitHandle.WaitOne(200)) {
        Log Task Sleep 'tick 200ms'
    }
    $ctx = $task.GetAwaiter().GetResult()
    $ctx.Response.StatusCode = 200
    $ctx.Response.ContentType = 'text/html'

    $message = 'hi world 🐒 !'
    $byte_str = [Text.Encoding]::UTF8.GetBytes( $message )
    $json = ($ctx.Response | ConvertTo-Json -wa 0 -Depth 0 -Compress)
    Log Response Write $json
    $ctx.Response.OutputStream.Write( $byte_str, 0, $byte_str.Length )

} finally {
    Log Response Close
    Log Listen Close
    $ctx.Response.Dispose()
    $listen.Dispose()
}
