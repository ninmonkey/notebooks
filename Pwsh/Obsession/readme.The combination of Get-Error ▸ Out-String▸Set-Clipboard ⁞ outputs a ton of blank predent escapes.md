## About

the question isn't why are there colors, I have ansi toggled on.
the curious part is **why it redundantly sets** the same color multiple times for a single line. 
maybe it's done on purpose to align text more consistently. 


## Final command

- all helper functions are in the code: [The combination of Get-Error ▸ Out-String▸Set-Clipboard ⁞ outputs a ton of blank predent escapes.ps1](./The%20combination%20of%20Get-Error%20▸%20Out-String▸Set-Clipboard%20⁞%20outputs%20a%20ton%20of%20blank%20predent%20escapes.ps1)

```ps1
(($serr | Get-Error | out-string) -split '\r?\n').where({$_}, 'first', 6) 
    | Join-String -sep (Hrr) -p { $_ | HShowEscape } | ShowEmojiRepeats

🐈Exception             : 🦎
---------------------------------------------------------------------------------------------------------------------------------------------
🐈🦎    🐈Type       : 🦎System.FormatException🦎
---------------------------------------------------------------------------------------------------------------------------------------------
🐈🦎🐈🦎    🐈TargetSite : 🦎
---------------------------------------------------------------------------------------------------------------------------------------------
🐈🦎🐈🦎🐈🦎        🐈Name          : 🦎ThrowFormatInvalidString🦎
---------------------------------------------------------------------------------------------------------------------------------------------
🐈🦎🐈🦎🐈🦎🐈🦎        🐈DeclaringType : 🦎System.ThrowHelper, System.Private.CoreLib, Version=8.0.0.0, Culture=neutral, PublicKeyToken=7cec
---------------------------------------------------------------------------------------------------------------------------------------------
🐈🦎🐈🦎🐈🦎🐈🦎🐈🦎        🐈MemberType    : 🦎Method🦎
```
## short example

```ps1
(($serr | Get-Error | out-string) -split '\r?\n').where({$_}, 'first', 6) | Join-String -sep (hr 1) -p { $_ | fcc }

$outStr_lines| HShowEscape | Join-string -sep (Hrr 1)
␛[32;1mException             : ␛[0m
----------------------------------------------------------------------------------------------------
␛[32;1m␛[0m    ␛[32;1mType       : ␛[0mSystem.FormatException␛[0m
----------------------------------------------------------------------------------------------------
␛[32;1m␛[0m␛[32;1m␛[0m    ␛[32;1mTargetSite : ␛[0m
----------------------------------------------------------------------------------------------------
␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m        ␛[32;1mName          : ␛[0mThrowFormatInvalidString␛[0m
----------------------------------------------------------------------------------------------------
␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m        ␛[32;1mDeclaringType : ␛[0mSystem.ThrowHelper, S
----------------------------------------------------------------------------------------------------
␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m        ␛[32;1mMemberType    : ␛[0mMethod␛[0m
```

## easier to visualize repeats using cats and lizards

```ps1

(($serr | Get-Error | out-string) -split '\r?\n').where({$_}, 'first', 6) | Join-String -sep (hr 1) -p { $_ | fcc }
| %{
    $_ -replace
        [Regex]::Escape( '␛[32;1m' ), '🐈' -replace
        [Regex]::Escape('␛[0m'), '🦎'  
}

🐈Exception␠␠␠␠␠␠␠␠␠␠␠␠␠:␠🦎
-------------------------------------------------------------------------------------------------------------------
🐈🦎␠␠␠␠🐈Type␠␠␠␠␠␠␠:␠🦎System.FormatException🦎
-------------------------------------------------------------------------------------------------------------------
🐈🦎🐈🦎␠␠␠␠🐈TargetSite␠:␠🦎
-------------------------------------------------------------------------------------------------------------------
🐈🦎🐈🦎🐈🦎␠␠␠␠␠␠␠␠🐈Name␠␠␠␠␠␠␠␠␠␠:␠🦎ThrowFormatInvalidString🦎
-------------------------------------------------------------------------------------------------------------------
🐈🦎🐈🦎🐈🦎🐈🦎␠␠␠␠␠␠␠␠🐈DeclaringType␠:␠🦎System.ThrowHelper,␠System.Private.CoreLib,␠Version=8.0.0.0,␠Culture=ne
-------------------------------------------------------------------------------------------------------------------
🐈🦎🐈🦎🐈🦎🐈🦎🐈🦎␠␠␠␠␠␠␠␠🐈MemberType␠␠␠␠:␠🦎Method🦎
```

## Helper functions 

```ps1
(($serr | Get-Error | out-string) -split '\r?\n').where({$_}, 'first', 6) | Join-String -sep (Hrr) -p { $_ | HShowEscape }
␛[32;1mException             : ␛[0m
---------------------------------------------------------------------------------------------------------------------------
␛[32;1m␛[0m    ␛[32;1mType       : ␛[0mSystem.FormatException␛[0m
---------------------------------------------------------------------------------------------------------------------------
␛[32;1m␛[0m␛[32;1m␛[0m    ␛[32;1mTargetSite : ␛[0m
---------------------------------------------------------------------------------------------------------------------------
␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m        ␛[32;1mName          : ␛[0mThrowFormatInvalidString␛[0m
---------------------------------------------------------------------------------------------------------------------------
␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m        ␛[32;1mDeclaringType : ␛[0mSystem.ThrowHelper, System.Private.CoreLib, 
---------------------------------------------------------------------------------------------------------------------------
␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m        ␛[32;1mMemberType    : ␛[0mMethod␛[0m


```

## Ways to render

Both give the same results. So it's not an artifact of Set-Clipboard itself. 

```ps1
$serr | Get-error | code - 
```
```ps1
# then paste into vs code
$serr | Get-Error | Out-string | Set-ClipBoard
```
```log
␛[32;1mException␠␠␠␠␠␠␠␠␠␠␠␠␠:␠␛[0m
␛[32;1m␛[0m␠␠␠␠␛[32;1mType␠␠␠␠␠␠␠:␠␛[0mSystem.FormatException␛[0m
␛[32;1m␛[0m␛[32;1m␛[0m␠␠␠␠␛[32;1mTargetSite␠:␠␛[0m
␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␠␠␠␠␠␠␠␠␛[32;1mName␠␠␠␠␠␠␠␠␠␠:␠␛[0mThrowFormatInvalidString␛[0m
␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␠␠␠␠␠␠␠␠␛[32;1mDeclaringType␠:␠␛[0mSystem.ThrowHelper,␠System.Private.CoreLib,␠Version=8.0.0.0,␠Culture=neutral,␠PublicKeyToken=7cec85d7bea7798e␛[0m
␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␠␠␠␠␠␠␠␠␛[32;1mMemberType␠␠␠␠:␠␛[0mMethod␛[0m
␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␠␠␠␠␠␠␠␠␛[32;1mModule␠␠␠␠␠␠␠␠:␠␛[0mSystem.Private.CoreLib.dll␛[0m
␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␠␠␠␠␛[32;1mMessage␠␠␠␠:␠␛[0m␛[31;1mInput␠string␠was␠not␠in␠a␠correct␠format.␠Failure␠to␠parse␠near␠offset␠1.␠Expected␠an␠ASCII␠digit.␛[0m
␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[31;1m␠␠␠␠␛[32;1mSource␠␠␠␠␠:␠␛[0mSystem.Private.CoreLib␛[0m
␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[31;1m␛[32;1m␛[0m␠␠␠␠␛[32;1mHResult␠␠␠␠:␠␛[0m-2146233033␛[0m
␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[31;1m␛[32;1m␛[0m␛[32;1m␛[0m␠␠␠␠␛[32;1mStackTrace␠:␠␛[0m
␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[31;1m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␠␠␠at␠System.Text.StringBuilder.AppendFormatHelper(IFormatProvider␠provider,␠String␠format,␠ReadOnlySpan`1␠args)␛[0m
␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[31;1m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␠␠␠at␠Microsoft.PowerShell.Commands.Utility.JoinStringCommand.ProcessRecord()␛[0m
␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[31;1m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␠␠␠at␠System.Management.Automation.CommandProcessor.ProcessRecord()␛[0m
␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[31;1m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1mCategoryInfo␠␠␠␠␠␠␠␠␠␠:␠␛[0mNotSpecified:␠(:)␠[Join-String],␠FormatException␛[0m
␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[31;1m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1mFullyQualifiedErrorId␠:␠␛[0mSystem.FormatException,Microsoft.PowerShell.Commands.Utility.JoinStringCommand␛[0m
␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[31;1m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1mInvocationInfo␠␠␠␠␠␠␠␠:␠␛[0m
␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[31;1m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␠␠␠␠␛[32;1mMyCommand␠␠␠␠␠␠␠␠:␠␛[0mJoin-String␛[0m
␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[31;1m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␠␠␠␠␛[32;1mScriptLineNumber␠:␠␛[0m6␛[0m
␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[31;1m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␠␠␠␠␛[32;1mOffsetInLine␠␠␠␠␠:␠␛[0m33␛[0m
␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[31;1m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␠␠␠␠␛[32;1mHistoryId␠␠␠␠␠␠␠␠:␠␛[0m65␛[0m
␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[31;1m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␠␠␠␠␛[32;1mScriptName␠␠␠␠␠␠␠:␠␛[0mH:\data\2023\pwsh\notebooks\Pwsh\Obsession\The␠combination␠of␠Get-Error␠▸␠Out-String▸Set-Clipboard␠⁞␠outputs␠a␠ton␠of␠blank␠predent␠escapes.ps1␛[0m
␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[31;1m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␠␠␠␠␛[32;1mLine␠␠␠␠␠␠␠␠␠␠␠␠␠:␠␛[0m'ssdf'.EnumerateRunes().value␠|␠Join-string␠-f␠'{x}'␠-sep␠'␠'␛[0m
␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[31;1m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␠␠␠␠␠␠␠␠␠␠␠␠␠␠␠␠␠␠␠␠␠␠␠␛[0m
␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[31;1m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␠␠␠␠␛[32;1mStatement␠␠␠␠␠␠␠␠:␠␛[0mJoin-string␠-f␠'{x}'␠-sep␠'␠'␛[0m
␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[31;1m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␠␠␠␠␛[32;1mPositionMessage␠␠:␠␛[0mAt␠H:\data\2023\pwsh\notebooks\Pwsh\Obsession\The␠combination␠of␠Get-Error␠▸␠Out-String▸Set-Clipboard␠⁞␠outputs␠a␠ton␠of␠blank␠predent␠escapes.ps1:6␠char:33␛[0m
␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[31;1m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␠␠␠␠␠␠␠␠␠␠␠␠␠␠␠␠␠␠␠␠␠␠␠+␠'ssdf'.EnumerateRunes().value␠|␠Join-string␠-f␠'{x}'␠-sep␠'␠'␛[0m
␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[31;1m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␠␠␠␠␠␠␠␠␠␠␠␠␠␠␠␠␠␠␠␠␠␠␠+␠␠␠␠␠␠␠␠␠␠␠␠␠␠␠␠␠␠␠␠␠␠␠␠␠␠␠␠␠␠␠␠␠␛[31;1m~~~~~~~~~~~~~~~~~~~~~~~~~~~~~␛[0m
␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[31;1m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[31;1m␠␠␠␠␛[32;1mPSScriptRoot␠␠␠␠␠:␠␛[0mH:\data\2023\pwsh\notebooks\Pwsh\Obsession␛[0m
␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[31;1m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[31;1m␛[32;1m␛[0m␠␠␠␠␛[32;1mPSCommandPath␠␠␠␠:␠␛[0mH:\data\2023\pwsh\notebooks\Pwsh\Obsession\The␠combination␠of␠Get-Error␠▸␠Out-String▸Set-Clipboard␠⁞␠outputs␠a␠ton␠of␠blank␠predent␠escapes.ps1␛[0m
␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[31;1m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[31;1m␛[32;1m␛[0m␛[32;1m␛[0m␠␠␠␠␛[32;1mInvocationName␠␠␠:␠␛[0mJoin-string␛[0m
␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[31;1m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[31;1m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␠␠␠␠␛[32;1mCommandOrigin␠␠␠␠:␠␛[0mInternal␛[0m
␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[31;1m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[31;1m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1mScriptStackTrace␠␠␠␠␠␠:␠␛[0mat␠<ScriptBlock>,␠H:\data\2023\pwsh\notebooks\Pwsh\Obsession\The␠combination␠of␠Get-Error␠▸␠Out-String▸Set-Clipboard␠⁞␠outputs␠a␠ton␠of␠blank␠predent␠escapes.ps1:␠line␠6␛[0m
␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[31;1m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[31;1m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␛[32;1m␛[0m␠␠␠␠␠␠␠␠␠␠␠␠␠␠␠␠␠␠␠␠␠␠␠␠at␠<ScriptBlock>,␠<No␠file>:␠line␠1␛[0m
```

Note: I manually converted escapes into their graphical symbol for this markdown
```ps1
function Format-VisualizeEscapes { 
   ($Input) -replace '\x1b', '␛'
}

$serr | Get-error | Out-string | Set-Clipboard
Get-Clipboard | Format-VisualizeEscapes
# this doesn't cleanup other control chars, but it's a short snippet
# I have a longer wrapper in  'Ninmonkey.Console\Format-ControlChar'
```