<# https://discord.com/channels/180528040881815552/1168058421115883600/1168393538308939896 #>
# 2023-11-16

$i = 0 # this goes down, 1 line at a time
while($true) {
  $i++
  sleep 0.2
  @(
  "`e[G",
  "`e[2A" * 2
  "`n" * 4
  "is {0}" -f @( $i )
  ) -join ''
}

$i = 0 ### this stays on the same line
while($true) {
  $i++
  sleep 0.2
  @(
  "`e[G",
  "`e[2A" * 2
  "`n" * 3
  "is {0}" -f @( $i )
  ) -join ''
}