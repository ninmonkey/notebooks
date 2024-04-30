using namespace System.Collections.Generic
using namespace System.Collections

class ObjectComparer : IEqualityComparer[object] {
    [bool] Equals([object] $xObject, [object] $yObject) {
        $x = @($xObject.PSObject.Properties)
        $y = @($yObject.PSObject.Properties)

        if(-not $x.Count.Equals($y.Count)) {
            return $false
        }

        return ([IStructuralEquatable] $x.Name).Equals($y.Name, [StringComparer]::InvariantCultureIgnoreCase) -and
               ([IStructuralEquatable] $x.Value).Equals($y.Value, [StringComparer]::InvariantCultureIgnoreCase)
    }

    [int] GetHashCode([object] $xObject) {
        $x = $xObject.PSObject.Properties
        return ([IStructuralEquatable] $x.Name).GetHashCode([StringComparer]::InvariantCultureIgnoreCase) -bxor
               ([IStructuralEquatable] $x.Value).GetHashCode([StringComparer]::InvariantCultureIgnoreCase)
    }
}

$hash = [HashSet[object]]::new([ObjectComparer]::new())

$hash.Add([pscustomobject]@{
    foo = 'hello'; bar = 'World'; baz = 124 }) # true

$hash.Add([pscustomobject]@{
    foo = 'hello'; bar = 'World'; baz = 124 }) # false

$hash.Add([pscustomobject]@{
    foo = 'HELLO'; bar = 'World'; baz = 124 }) # false
