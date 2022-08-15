## current

```ps1
$Nums = 0,6,22 | PassThru -Csv
# output
0, 6, 22

$Nums *= -1

Label -Name 'Nums' $Nums
```

## final invoke one of

```ps1
Label $Nums
$nums | Label $Nums

# hopefully not
$nuns | Label { $Nums }
# or

```