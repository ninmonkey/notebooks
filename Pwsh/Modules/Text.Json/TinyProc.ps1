using namespace System.Linq
using namespace System.IO
using namespace System.Collections.Generic

goto $PSScriptRoot
return
class TinyProc {
    [string]$Name
    [datetime]$When

    TinyProc () {
        $this.When = Get-date
    }
    TinyProc ( [object]$Other ) {
        [Linq.Enumerable]::Intersect( $This.PSobject.Properties.Name, $Other.PSObject.Properties.Name )
        $selected = [Linq.Enumerable]::Intersect( $This.PSobject.Properties.Name, $Other.PSObject.Properties.Name )

        [List[Object]]$Props = $this.PSObject.Properties.Name
        [string[]]$intersect = $Other.PSObject.Properties.Name -in $Props
        $intersect -join ', ' | write-host -fore 'red'


        $this.Psobject.Properties | json | write-host -fg 'orange'
        @( $Other )[0].psobject.properties.Name
    }
}


[Linq.Enumerable]::Intersect(
    <# first: #> $first,
    <# second: #> $second)

$comparer = [Func[object,bool]]{}
[Linq.Enumerable]::Intersect(
    <# first: #> $files1,
    <# second: #> $files2,
    <# comparer: #> $comparer)


return
$ps = Get-Process pwsh | Select -first 1

return
try { [TinyProc]$Ps } catch { '😿' }

[TinyProc]@{}
[TinyProc]::new()
[TinyProc]$Ps
