@'
from: <https://github.com/PowerShell/PowerShell/issues/10982#issuecomment-549406751>
> As a fun side note, if you follow these steps interactively
>   (either use reflection manually with ImpliedReflection) you can see exactly when it's compiled.

0..40 | % { $sb.InvokeReturnAsIs() }

    Invoked!
    Invoked!
    Invoked!
    Invoked!
    Compiled!
    Invoked!
    Invoked!
'@
# Updated for new ImpliedReflection
Enable-ImpliedReflection -YesIKnowIShouldNotDoThis
$sb = { Write-Host Invoked! }
& $sb
$sb.EndBlock.Target.add_Compile{ Write-Host Compiled! }
0..40 | % { $sb.InvokeReturnAsIs() }