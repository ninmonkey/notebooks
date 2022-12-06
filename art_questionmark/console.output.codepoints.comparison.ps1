

while($true) { 
$iter++
$max = $fam.Length - 1
$min = 0
if($iter % 5 -eq 0) { 
    hr 2
#   $max = $Min; $Min = $max
}
$min..$Max | %{
  [Console]::Write(
       ($fam.ToCharArray() | select -First $_ | Join-String)
  )
     sleep 0.02
 }
  sleep 0.01
}
