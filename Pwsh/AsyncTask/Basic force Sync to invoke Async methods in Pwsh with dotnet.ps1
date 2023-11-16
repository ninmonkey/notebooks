<#
seeminglyscience> you can use 'em but you have to force it to be synchronous
e.g.

$task = $loader.LoadDatabaseAsync($dbName)
while (-not $task.AsyncWaitHandle.WaitOne(200)) { }
$db = $task.GetAwaiter().GetResult()
(the above is recommended over other methods you might see because: it throws unwrapped exceptions rather than the generic "One or more errors occurred" exception, and it responds to ctrl + c)

https://discord.com/channels/180528040881815552/447476117629304853/1144314174617428029

#>
$task = $loader.LoadDatabaseAsync($dbName)
while (-not $task.AsyncWaitHandle.WaitOne(200)) { }
$db = $task.GetAwaiter().GetResult()