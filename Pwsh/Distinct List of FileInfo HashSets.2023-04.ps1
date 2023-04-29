using namespace System
using namespace System.Collections.Generic
using namespace System.IO

$files = [HashSet[FileSystemInfo]]::new(
    [EqualityComparer[FileSystemInfo]]::Create(
        { param($x, $y) $x.FullName -eq $y.FullName },
        { param($x) [StringComparer]::OrdinalIgnoreCase.GetHashCode($x.FullName) }))

$files.Add((gi .))
$files.Add((gi .))