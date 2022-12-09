- [ ] verb group that uses where, for grouping conditions
- [ ] new verb for selecting `select -first 3` 
- [ ] select index `-1`

- [things that don't work](#things-that-dont-work)
  - [generics](#generics)
  - [members/methods](#membersmethods)
- [maybe not existing ideas](#maybe-not-existing-ideas)
- [color](#color)
- [encoding](#encoding)
- [misc](#misc)
- [ps](#ps)

## things that don't work

### generics
### members/methods

```ps1
& { New System.Collections.Generic.List[int] }
. { new $PSStyle.Background.FromRgb 200 3 4 }
getRandom 4 from (all $grads where { $_.X11ColorName -match 'dark.*' } )



```

## maybe not existing ideas

## color
```ps1
{ new-range 0..100 every 10 }

outputs 
    0, 10, 20, 30, 40, 50, 60, 70, 80, 90, 100




$purp_ish = Get-Gradient -StartColor 'purple' -EndColor 'gray30'  ; $purp_ish
hr
all $purp_ish Where { $_.X11ColorName -match 'gray' } are cGray
all $purp_ish Where { $_.Consolecolor -match 'dark' } are cDark

where FavColor = { $_ -match 'orange|red|4d4d4d'}
all $purp_ish are cDark
all $purp_ish are in cDark, cGray

where is <> can be predefined scriptblock

all $purp_ish Where { $_.X11ColorName in ( all $purp_ish where is FavColor  } are cGray


all $purp_ish Where is a FavColor

$randColors ??= ls bg: | get-random -Count 100
$allNames = $randColors | group ConsoleColor -NoElement | % Name | sort -Unique

all $randColors where ConsoleColor is black ?



$randColors = ls bg: | get-random -Count 100
all $randColors where { $_.X11ColorName -match 'gray\d+' } -ov 'q_gray'
hr
$q_gray | sort X11ColorName
hr
$q_gray | sort Hue



$purp_ish = Get-Gradient -StartColor 'purple' -EndColor 'gray30'  ; $purp_ish
hr
all $purp_ish Where { $_.X11ColorName -match 'gray' } are cGray
all $purp_ish Where { $_.Consolecolor -match 'dark' } are cDark

all $purp_ish when {
        $_.X11ColorName -match 'gray' are cGray
        $_.X11ColorName -match 'gray|purple' are cBlueish
        $_.X11ColorName -match 'dark' are cDark
    }



# all what? where ?
query where $cGray intersects $cDark

. { new $PSStyle.Background.FromRgb 200 3 4 }
# but this works
. { new rgbcolor 200 3 4 }
all (0..4) where { [math]::Pow(2, $_ ) -gt 7 } | Join-String -sep ', ' 

all (0..4) where { [math]::Pow($_, 2 )  } # transform 

$purp_ish = Get-Gradient -StartColor 'purple' -EndColor 'gray30'  ; $purp_ish
hr
$c2 =   all $purp_ish Where { $_.X11ColorName -match 'gray' } are gray



$purp_ish = Get-Gradient -StartColor 'purple' -EndColor 'gray30'
all $purp_ish where distinct { $_.Name } 

# set intersect operators?

```


```ps1
[rgbcolor]
```

## encoding

```ps1
& { new Text.Encoding 'utf-8' }
```
## misc
```ps1
& { new CultureInfo 'de-de' }

all functions where { $_.Source -eq 'pipescript' } | Select -first 3

# wip: sorting
all functions where { $_.Source -eq 'pipescript' } order by ... | select first 3
```

## ps

example converts PID id numbers, to colors. Colors are easier to remember/see patterns.
To genericalize to give unique fo
```ps1
Ps7┐ ps -Id 100336, 18104

 NPM(K)    PM(M)      WS(M)     CPU(s)      Id  SI ProcessName Pid Name
 ------    -----      -----     ------      --  -- ----------- --------
    105    72.10      77.94      20.55   18104   1 pwsh        orange
    149   148.66     260.39      29.44  100336   1 pwsh        green
```
```ps1
ps | fw
  pwsh.exe [18104 orange]
  pwsh.exe [100336 green]
```

example showing dot notation sugar
```ps1
$self = ps where Pid is $PID

$children = ps in all ps where parent.pid = $pid
```
