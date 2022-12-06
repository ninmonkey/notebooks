### Prerequisites

- [X] **Existing Issue:** Search the existing issues for this repository. If there is an issue that fits your needs do not file a new one. Subscribe, react, or comment on that issue instead.
- [X] **Descriptive Title:** Write the title for this issue as a short synopsis. If possible, provide context. For example, "Typo in `Get-Foo` cmdlet" instead of "Typo."
- [X] **Verify Version:** If there is a mismatch between documentation and the behavior on your system, ensure that the version you are using is the same as the documentation. Check this box if they match or the issue you are reporting is not version specific.

### Links

- 5.1 https://github.com/MicrosoftDocs/PowerShell-Docs/blob/03a1c6105aaa0660bcedd494d0fe59d75dd32d17/reference/5.1/Microsoft.PowerShell.Core/About/about_Functions_Advanced_Parameters.md#parameter-and-variable-validation-attributes
- 7.3 https://github.com/MicrosoftDocs/PowerShell-Docs/blob/03a1c6105aaa0660bcedd494d0fe59d75dd32d17/reference/7.3/Microsoft.PowerShell.Core/About/about_Functions_Advanced_Parameters.md#parameter-and-variable-validation-attributes
- other examples on the same page don't follow that requirement https://github.com/MicrosoftDocs/PowerShell-Docs/blob/03a1c6105aaa0660bcedd494d0fe59d75dd32d17/reference/7.3/Microsoft.PowerShell.Core/About/about_Functions_Advanced_Parameters.md#validaterange-validation-attribute

### Summary

The docs say it's a requirement that `type converters` are left of `attributes`. This seems incorrect.

> When you use a type converter along with a validation attribute, the type converter has to be defined before the attribute


### Details

Here's a sample test case
```ps1
[ValidateNotNull()][datetime]$When   # throws
[datetime][ValidateNotNull()]$When2 # throws
```
```ps1
class CCTest {
   [ValidateNotNull()][hashtable]$Config
   [int32]$Id
}

[CCTest]@{ Config = $null; Id =  4} # throws
[CCTest]@{ Config = @{}; Id =  4}   # ok

$inst.Config =  $Null # throws
```
```ps1
function testSB { 
    param(
          [ValidateNotNull()][hashtable]$Config
    )
    $null -eq $config
}

testSB @{ a = 2 } # ok
testSB 1235       # throws, not hashtable
```

<!-- 


class CCTest {
   [ValidateNotNull()][hashtable]$Config
   [int32]$Id
}
{ [CCTest]@{ Config = $null; Id =  4} } | Should -throw -Because 'has notnull attribute'
[CCTest]@{ Config = @{}; Id =  4} }   | Should -not -throw -beacuse 'notnull attribute'

#$inst = [CCTest]@{ Config = $null; Id =  4}

##$inst.Config =  $Null
-->
## Final, misleading, but not working version 

```ps1
## A
[ValidateNotNull()]
[datetime]$DateAfter  # throws 

## B
[datetime]
[ValidateNotNull()]$DateBefore  # doesn't throw but still bad
```
A throws.
B 
```ps1
$res[0] -is 'type'

$null -eq $res[1]

$null -eq $res[1] # true
```

### Suggested Fix

I tested more cases. It seems to never be a requirement as far as I can tell. 

 - class members
 - function parameters
 - variables with types and attribute
