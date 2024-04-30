#requires -Version 7.0
using namespace System.Collections.Generic
using namespace System.Collections
using namespace System.Linq

$all_files  = @( gci 'c:\' -depth 0 -File )
$some_files = @( $all_files | Get-random -count 4 )

# if you use strongly typed arrays, then you don't have to include types
# in the [Linq.Enumerable]::Intersect call.
# See method #1 verses method #2
[IO.FileSystemInfo[]] $all_files_typed  = $all_files
[IO.FileSystemInfo[]] $some_files_typed = $some_files

## Method 4 : using typed arrays, with IEquality from type?
$linky4 =
    [Linq.Enumerable]::Intersect(
        $all_files_typed, $some_files_typed,
        [EqualityComparer[IO.FileSystemInfo]]::Default )

## Method 3 : using better typed params, implicit compare
$linky3 = [Linq.Enumerable]::Intersect(
    $all_files_typed, $some_files_typed,
    [EqualityComparer[Object]]::Create(
        <# equals #>      { param($x, $y) $x.FullName -eq $y.FullName },
        <# gethashCode #> { param($x) [StringComparer]::OrdinalIgnoreCase.GetHashCode( $x.FullName ) })
)
## Method 2 : using Comparison[Object] to make it compatible with [List[Object]]
$linky2 = [Linq.Enumerable]::Intersect(
    $all_files, $some_files,
    [EqualityComparer[Object]]::Create(
        <# equals #>      { param($x, $y) $x.FullName -eq $y.FullName },
        <# gethashCode #> { param($x) [StringComparer]::OrdinalIgnoreCase.GetHashCode( $x.FullName ) })
)

## Method 1 : using [Type[]] $Lists, and explict [EqualityComparer[Type]]
$linky1 = [Linq.Enumerable]::Intersect(
    [IO.FileSystemInfo[]] $all_files,
    [IO.FileSystemInfo[]] $some_files,
    [EqualityComparer[IO.FileSystemInfo]]::Create(
        <# equals #>      { param($x, $y) $x.FullName -eq $y.FullName },
        <# gethashCode #> { param($x) [StringComparer]::OrdinalIgnoreCase.GetHashCode($x.FullName) })
)

@($linky1).count | join-string -op 'linky1 count: '
@($linky2).count | join-string -op 'linky2 count: '
@($linky3).count | join-string -op 'linky3 count: '
@($linky4).count | join-string -op 'linky4 count: '

## using a HashSet with [EqualityComparer<T>] generic
[IO.Fileinfo[]]$files = @(
    [IO.FileInfo]::new('c:\foo\bar.ps1'),
    [IO.FileInfo]::new('c:\foo\bar.ps1'),
    [IO.FileInfo]::new('c:\foo\Bar.ps1')
)
$distinct = [hashSet[IO.FileInfo]]::new(
    $files,
    [EqualityComparer[IO.FileSystemInfo]]::Create(
        <# equals #>      { param($x, $y) $x.FullName -eq $y.FullName },
        <# gethashCode #> { param($x) [StringComparer]::InvariantCulture.GetHashCode( $x.FullName ) }) )

$distinct.fullname # returns 2 items
<#
Extra
a custom [IEquality] comparer, without writing a class
this example for fun randomly adds duplicates

    [discord thread](https://discord.com/channels/180528040881815552/447476117629304853/1198037155264594001),
    [discord thread2](https://discord.com/channels/180528040881815552/447475598911340559/1177305079376793730)
#>
$comparerRandomFolder = # from santisq
    [EqualityComparer[IO.DirectoryInfo]]::Create(
        <# equals: #>
        [Func[IO.DirectoryInfo, IO.DirectoryInfo, bool]] {
            Get-Random -Maximum 2 },
        <# getHashCode: #>
        [Func[IO.DirectoryInfo, int]] {
            $args[0].FullName.GetHashCode() })

$hashFolders =
    [HashSet[IO.DirectoryInfo]]::new(
        $comparerRandomFolder )

0..10 | ForEach-Object { $hashFolders.Add((Get-Item .)) } | Join-string -sep ', ' -op 'RandComparison adds: '
