
remove-Variable 'x', 'y' -ea ignore
[ValidateNotNull()][int]$x= $Null

remove-Variable 'x', 'y' -ea ignore
[int][ValidateNotNull()]$y = $Null


get-variable 'x', 'y'
hr
@{ 
   'x.isNull?' = $Null -eq $x ; 'y.IsNull?' = $null -eq $y
   'x.exist?' = (get-variable 'x' -ea ignore).count -gt 0
   'y.exist?' = (get-variable 'y' -ea ignore).count -gt 0
   '∴therefore.because∵ x? Yes ∃ . No = ∄ ' = 3
} | ft -AutoSize
https://github.com/MicrosoftDocs/PowerShell-Docs/issues/9480
