
Remove-Variable 'tom', 'jen' -ea 0 # as close to a clean true state
[System.Nullable[datetime]]$tom = $Null
$tom = $null
$null -eq $tom      # true

@{ TomIsDateTime = $tom -is 'datetime'
   TomIsInt = $tom -is 'int' } | Json

$tom = 1234         # instance
$tom -is 'int'      # False
$tom -is 'datetime' # True

<# do stuff
 $tom
#>

@{  Tom = $Tom
    Type = ($Tom)?.GetType().Name ?? '<null>'
    TomIsDateTime = $tom -is 'datetime'
    TomIsInt = $tom -is 'int' } | Json

$tom = Get-Date

@{  Tom = $Tom
    Type = ($Tom)?.GetType().Name ?? '<null>'
    TomIsDateTime = $tom -is 'datetime'
    TomIsInt = $tom -is 'int' } | Json

@'
$tom
    > Tom is 1/1/0001 12:00:00 AM

$tom.GetType().FullName -eq 'System.Datetime'
    > true
'@
Get-Variable 'tom'

[datetime]$Jen = Get-Date
$Jen = $null
$null -eq $Jen      # true
$Jen = 1234         # instance
$Jen -is 'int'      # False
$Jen -is 'datetime' # True
hr
$Nobody = Get-Date
$Nobody = $null
$null -eq $Nobody      # true
$Nobody = 1234         # instance
$Nobody -is 'int'      # False
$Nobody -is 'datetime' # True



Get-Variable 'jen', 'tom'