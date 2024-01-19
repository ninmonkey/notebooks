using namespace System.Linq
using namespace System.IO
using namespace System.Collections.Generic


<#

Is this an example of what you *should* do? No.
Is this overly complex for no reason? Yes.
At least the Linq part

#>

class TinyProc {
    [string]$Name
    [datetime]$When

    TinyProc () {
        $this.When = Get-date
    }
    TinyProc ( [object]$Other ) {
        $WantedProps = [Linq.Enumerable]::Intersect(
            [string[]]$This.PSObject.Properties.Name,
            [string[]]$Other.PSObject.Properties.Name )

        $This.When = Get-Date

        foreach($PropName in $WantedProps) {
            $This.$PropName = $Other.$PropName
        }
    }
}

$Ps = get-process pwsh | Select -first 1
$testCoerce = [TinyProc]$Ps

$records = @(
    [TinyProc]@{}
    [TinyProc]::new()
    [TinyProc]$Ps
)
$records

<#
variations you could also use:
#>

@( get-process) -as [TinyProc[]]
    | Out-Null

[TinyProc[]]@(get-process)
    | Out-Null
