[string[]]$x = 'a', 'b'

[string]$first, [Nullable[int]]$num, [string[]]$two, $last = @(
  'first', 4, 'a', 'b', 'more', 1234, 'end.'
)


$first, $num, $two, $last | %{ $_ | Js }
hr

[string]$first, [Nullable[int]]$num, [string[]]$two, $last = @(
  'first', $null, $null
)
$first, $num, $two, $last | %{ $_ | Js }
hr

[string]$first, [Nullable[int]]$num, [string[]]$two, $last = @(
  $Null
)
$first, $num, $two, $last | %{ $_ | Js }
throw 'some duplicate impl. in paste, check before commit' 


gcl | Add-Content -PassThru -Path [string[]]$x = 'a', 'b'

[string]$first, [Nullable[int]]$num, [string[]]$two, $last = @(
  'first', 4, 'a', 'b', 'more', 1234, 'end.'
)

function Js  {  
  $obj = $input
  $obj | Json | Dotils.String.Visualize.Whitespace
  Join-String -op "`nitems: "
}

[string[]]$x = 'a', 'b'

[string]$first, [Nullable[int]]$num, [string[]]$two, $last = @(
  'first', 4, 'a', 'b', 'more', 1234, 'end.'
)


$first, $num, $two, $last | %{ $_ | Js }
hr

$first, $num, $two, $last | Format-ShortTypeName


