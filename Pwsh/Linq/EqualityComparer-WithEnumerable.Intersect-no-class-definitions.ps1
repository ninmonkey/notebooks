using namespace System.Linq
using namespace System.IO
using namespace System.Collections.Generic

<#
For a newer version, see the file: './Variants of EqualityComparer with Generics types - Without implementing a comparable class implementation.ps1'
#>

$files1 ??= Get-ChildItem 'c:'
$files2 ??= Get-ChildItem 'c:' -Depth 2

# [1] either as typed parameters

[Linq.Enumerable]::Intersect(
    [FileSystemInfo[]] $files1,
    [FileSystemInfo[]] $files2,
    [EqualityComparer[System.IO.FileSystemInfo]]::Create(
        { param($x, $y) $x.FullName -eq $y.FullName },
        { param($x) [StringComparer]::OrdinalIgnoreCase.GetHashCode($x.FullName) })
)

# [2] or objects

[Linq.Enumerable]::Intersect(
    $files1,
    $files2,
    [EqualityComparer[object]]::Create(
        { param($x, $y) $x.FullName -eq $y.FullName },
        { param($x) [StringComparer]::OrdinalIgnoreCase.GetHashCode($x.FullName) })
)
