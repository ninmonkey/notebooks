
$comparer = [System.Collections.Generic.EqualityComparer[System.IO.DirectoryInfo]]::Create(
    [System.Func[System.IO.DirectoryInfo, System.IO.DirectoryInfo, bool]] { Get-Random -Maximum 2 },
    [System.Func[System.IO.DirectoryInfo, int]] { $args[0].FullName.GetHashCode() })
$hash = [System.Collections.Generic.HashSet[System.IO.DirectoryInfo]]::new($comparer)
0..10 | ForEach-Object { $hash.Add((Get-Item .)) }

# https://discord.com/channels/180528040881815552/447476117629304853/1099090105492328489

using namespace System
using namespace System.Collections.Generic
using namespace System.IO

$files = [HashSet[FileSystemInfo]]::new(
    [EqualityComparer[FileSystemInfo]]::Create(
        { param($x, $y) $x.FullName -eq $y.FullName },
        { param($x) [StringComparer]::OrdinalIgnoreCase.GetHashCode($x.FullName) }))

$files.Add((gi .))
$files.Add((gi .))

# Technically doesn't use Linq, but, what are you gonna do?
