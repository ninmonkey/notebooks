# <https://discord.com/channels/180528040881815552/447476117629304853/1052807762343641119>
$counter = @(0)
0..50 | ForEach-Object -Parallel {
    $counter = $using:counter
    Start-Sleep 1
    [Threading.Monitor]::Enter($counter.SyncRoot)
    $counter[0]++
    [Threading.Monitor]::Exit($counter.SyncRoot)
} -ThrottleLimit 51
$counter

# Not sure whether this is verified.

$counter = @(0)
$semaphore = [System.Threading.SemaphoreSlim]::new(1, 1)
0..50 | ForEach-Object -Parallel {
    $counter = $using:counter
    $semaphore = $using:semaphore
    Start-Sleep 1
    $semaphore.Wait()
    $counter[0]++
    $null = $semaphore.Release()
} -ThrottleLimit 51
$counter



