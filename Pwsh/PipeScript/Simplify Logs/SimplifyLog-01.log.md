
## cleaned log

## To do

```ps1
Step1 until nextline match 'cacheevent'
$events = all lines in step1 where match 'cacheevent'
$rest =  all remaining lines 
until nextline -notmatch 'cacheevent'
#
```
- [ ] move dates to the end
- [ ] write to HTML tree, for nested trees
- [ ] truncate an lines at 140
    or maybe strip dates, truncate right 140, then append date column at the end
- [ ] use `…` codepoint for line continuations, making later parsing easier


### Input

```log
2022-12-06 15:13:17Z: Error: FullyQualifiedId, Details = 'foo' 'bvar', blue brown pink crimson beige magenta violet brown violet violet white crimson khaki brown blue amber green indigo gray khaki magenta crimson beige.
```

```ps1
$fullLine = 'Error: FullyQualifiedId, Details = foo var, blue brown pink crimson beige magenta violet brown violet violet white crimson khaki brown blue amber green indigo gray khaki magenta crimson beige.'

($fullLine -join "`n" ).Substring( 0, 100 )
| Join-String -os '… 2022-12-06 15:13:17Z'
```

### Output

```log
Error: FullyQualifiedId, Details = foo var, blue brown pink crimson beige magenta violet brown viole… 2022-12-06 15:13:17Z

## or 
Error: FullyQualifiedId
    Details = 
    foo var, blue brown pink crimson beige magenta violet brown viole… 2022-12-06 15:13:17Z

## or 
Error: FullyQualifiedId                               2022-12-06 15:13:17Z
    Details = 
    foo var, blue brown pink crimson beige magenta violet brown viole… 2022-12-06 15:13:17Z

Error                                  2022-12-06 15:13:17Z
    FullyQualifiedId,
    Details = foo var, blue brown pink crimson beige magent…
```


```log
2022-12-06 20:13:17Z: ModuleEvent: loading: always_first.ps1:
2022-12-06 20:13:17Z: ModuleEvent: [53120]--> enter always_first.ps1: ["2:13 PM"]
2022-12-06 20:13:17Z: ModuleEvent: --> enter {Always_first: ["2:13 PM"]
2022-12-06 20:13:17Z: ModuleEvent: <-- exit  :
2022-12-06 20:13:17Z: ModuleEvent: loading: aws_utils.ps1:
2022-12-06 20:13:17Z: ModuleEvent: loading: foo.ps1:
2022-12-06 20:13:17Z: ModuleEvent: loading: mapping.ps1:
2022-12-06 20:13:17Z: ModuleEvent: loading: BDG.JC.User.ps1:
2022-12-06 20:15:57Z: CacheEvent: PayloJsonCache::LoadFromFile: g:\nin\pwsh\JsonCache.json:
2022-12-06 20:15:59Z: CacheEvent: LoadEmployeeNumbers: loaded cache: g:\nin\pwsh\env\employeeList.json: [{"EmpCount_C0":58,"EmpCount_C1":2168}]
2022-12-06 20:15:59Z: CacheEvent: LoadFromFile: Added: ["armando.mcclure@fakename.com"]
2022-12-06 20:15:59Z: CacheEvent: LoadFromFile: Added: ["brenton.stephens@fakename.com"]
2022-12-06 20:15:59Z: CacheEvent: LoadFromFile: Added: ["danielle.horne@fakename.com"]
2022-12-06 20:15:59Z: CacheEvent: LoadFromFile: Added: ["ella.church@fakename.com"]

2022-12-06 20:15:59Z: CacheEvent: LoadFromFile: Added: ["giancarlo.holland@fakename.com"]
2022-12-06 20:15:59Z: CacheEvent: LoadFromFile: Added: ["giovani.morales@fakename.com"]
2022-12-06 20:15:59Z: CacheEvent: LoadFromFile: Added: ["guillermo.silva@fakename.com"]
2022-12-06 20:15:59Z: CacheEvent: LoadFromFile: Added: ["jaylen.gilmore@fakename.com"]
2022-12-06 20:15:59Z: CacheEvent: LoadFromFile: Added: ["joslyn.pace@fakename.com"]
2022-12-06 20:15:59Z: CacheEvent: LoadFromFile: Added: ["jovan.salazar@fakename.com"]
```
<? Inline pwsh generated: >  inline code?