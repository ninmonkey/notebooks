```ps1
function HandleStuff { 
   process { 
      if($_ -le 5) { 
        write-verbose 'was <= ?' -Verbose
        write-error 'invalid range' } 
   }
} 
function Test-WasOk { '👍' }
function GetFallback { 400 }
```
### Using `||` as a fallback ?

```sh
Can it run fallback when there's an error?
0,3,10 | HandleStuff || GetFallback
```
output
```
VERBOSE: was <= ?
HandleStuff: invalid range
VERBOSE: was <= ?
HandleStuff: invalid range
```

`GetFallback` is never called because the final value in the pipeline was not an error

### Using `&&` to run command2 only if command1 is successful?

0,3,10 | HandleStuff && Test-WasOk

```ps1
> 100 | HandleStuff && Test-WasOk
# 👍

> 3 | HandleStuff && Test-WasOk
VERBOSE: was <= ?
HandleStuff: invalid range
👍
```

```ps1
3, 10 | HandleStuff && Test-WasOk
VERBOSE: was <= ?
HandleStuff: invalid range
👍
Pwsh 7.4.1> [22] 🐒
10, 3 | HandleStuff && Test-WasOk
VERBOSE: was <= ?
HandleStuff: invalid range
👍
Pwsh 7.4.1> [23] 🐒
10, 3, 99 | HandleStuff && Test-WasOk
VERBOSE: was <= ?
HandleStuff: invalid range
👍
```
