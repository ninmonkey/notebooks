# from: <https://discord.com/channels/180528040881815552/447476117629304853/1052807446588043284>

$state = [Hashtable]::Synchronized(@{
    Counter = 1
    Lock = [System.Threading.Mutex]::new()
})

1..10 | ForEach-Object -Parallel {
    $state = $using:state
    
    Start-Sleep -Milliseconds (Get-Random -Minimum 10 -Maximum 50)
    
    [void]$state.Lock.WaitOne()
    try {
        $state.Counter = $state.Counter + 1
    }
    finally {
        $state.Lock.ReleaseMutex()
    }
}

$state.Counter

# The mutex allows only 1 thread to run inside that try/finally block at a time, ensuring that it has exclusive access to the counter to increment it