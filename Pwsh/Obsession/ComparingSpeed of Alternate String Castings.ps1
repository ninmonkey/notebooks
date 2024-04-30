#Requires -Modules 'Benchpress'
Import-Module BenchPress -pass
$Config = @{
    RepeatCount = 2
}
$items = 0..999999
$items = 0..9999
$results = @() # forgive me

d
$results += bench -GroupName 'FromNumeric' -RepeatCount $Config.RepeatCount -Technique @{
#   '.ToString() outlier !!'              = { $items.ToString() }
  'Pipe¦ % ￫ Str'          = { $items | % tostring }
  'Pipe¦ % ￫ [string]_'      = { $items | %{ [string]$_ } }
# 'ToStr_%_Method'           = { $items | %{ $_.ToString() } }
  'Pipe¦ % ￫ _.ToString()'   = { $items | %{ $_.ToString() } }
  '.ForEach(¦   [string] )'  = { $items.ForEach([string]) }
  '.ForEach(¦{ [string]_ })' = { $items.ForEach({ [string]$_ }) }
  '&{¦ Join-Str $Inp }) }'   = { & { Join-String -in $items } }
  'Join-Str -In $Inp'        = { Join-String -in $items }
  '$Inp ¦ Join-String'                     = { $items | Join-String }
  #JoinStringParam           = { Join-String -inp $Items -sep ', '  }
  #JoinStringPipe            = { $Items | Join-String -sep ', '  }
  #JoinOperator              = { $items -join ', ' }
  #JoinStringPipeStr         = { $ItemsStr | Join-String -sep ', '  }
}


$itemsStr = $items.ForEach([string])

$results += bench -GroupName 'FromString' -RepeatCount $Config.RepeatCount -Technique @{
#   '.ToString() outlier !!'              = { $ItemsStr.ToString() }
  'Pipe¦ % ￫ Str'          = { $ItemStr | % tostring }
  'Pipe¦ % ￫ [string]_'      = { $ItemStr | %{ [string]$_ } }
# 'ToStr_%_Method'           = { $ItemStr | %{ $_.ToString() } }
  'Pipe¦ % ￫ _.ToString()'   = { $ItemStr | %{ $_.ToString() } }
  '.ForEach(¦   [string] )'  = { $ItemStr.ForEach([string]) }
  '.ForEach(¦{ [string]_ })' = { $ItemStr.ForEach({ [string]$_ }) }
  '&{¦ Join-Str $Inp }) }'   = { & { Join-String -in $ItemStr } }
  'Join-Str -In $Inp'        = { Join-String -in $ItemStr }
  '$Inp ¦ Join-String'                     = { $ItemStr | Join-String }
  #JoinStringParam           = { Join-String -inp $ItemStr -sep ', '  }
  #JoinStringPipe            = { $ItemStr | Join-String -sep ', '  }
  #JoinOperator              = { $ItemStr -join ', ' }
  #JoinStringPipeStr         = { $ItemStr | Join-String -sep ', '  }
}

$results | Ft -auto
