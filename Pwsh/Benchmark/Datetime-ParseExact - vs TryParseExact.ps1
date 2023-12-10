# update-typedata -TypeName 'Timespan' -MemberType
function As.Ms { process { '{0:n2} ms' -f $_.TotalMilliseconds } }

$lines = 1..10e3 |ForEach-Object {
  if (9 -le (Get-Random -Maximum 30)) {
    "Random nonsense $(Get-Random)"
  }
  else {
    Get-Date -Format 'yyyy MM dd'
  }
}

Measure-Command {
  $lines |ForEach-Object {
    try { [datetime]::ParseExact($_,'yyyy MM dd', $null, 'None') }catch{ }
  }
} | As.Ms
$error.clear()

Measure-Command {
  $lines |ForEach-Object {
    $dt = [datetime]::MinValue
    if ([datetime]::TryParseExact($_, 'yyyy MM dd', $null, 'None', [ref]$dt)) { $dt }
  }
} | As.Ms
