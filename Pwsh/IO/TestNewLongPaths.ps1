@'
See more:
- [Unicode skip MAX_PATH limitations](https://learn.microsoft.com/en-us/windows/win32/fileio/maximum-file-path-limitation?tabs=powershell#enable-long-paths-in-windows-10-version-1607-and-later)
- [LongPathAware part of your manifest](https://learn.microsoft.com/en-us/windows/win32/sbscs/application-manifests)
- [ApplicationManifests](https://learn.microsoft.com/en-us/windows/win32/sbscs/application-manifests)

Oh, the 32,000 limit still limits each segment to <= 255 chars.
- See [Filesytem limits comparison table](https://learn.microsoft.com/en-us/windows/win32/fileio/filesystem-functionality-comparison#limits)
'@
# try going above and below the MAX_PATH upper limits
$long1 = 'a' * 180 -join ''
$long2 = 'b' * 340 -join ''
pushd 'g:\temp\longpathTest'
$baseDir  = Join-Path 'g:\temp\longpathTest' $Long1
$baseDir2 = Join-Path 'g:\temp\longpathTest' $Long2
( Test-Path $BaseDir ) ? '' : ( mkdir $baseDir )
# ( Test-Path $BaseDir2 ) ? '' : ( mkdir $baseDir2 )
#$newPath = ( $where = Join-String -f '{0}\SomeFile.log' -in  (Join-Path (gi .) $Long1 ))
#(Test-Path $NewPath) ? ( mkdir -Path $where
#GEt-date | Set-content -Path $newPath -PassThru
$nextPath  = Join-String -f '{0}\SomeFile.log' -in  (Join-Path (gi .) $Long1 )
$nextPath2 = Join-String -f '{0}\SomeFile.log' -in  (Join-Path (gi .) $Long2 )

# try writing to it
Get-Date | Set-content -path $nextPath -PassThru
# Get-Date | Set-content -path $nextPath2 -PassThru

$info = [ordered]@{
    BaseDir               = $BaseDir
    BaseDirFullNameLength = (Get-Item $baseDir).FullName.Length
    NextPath              = $NextPath
    NextPath_Length       = $NextPath.Length
    NextPath2             = $NextPath2
    NextPath2_Length      = $NextPath2.Length
}
# $info.NextPath_Filesize = (gi $NextPath2).Length

( $scaryPathFolder = Join-Path 'G:\temp\longpathTest\' -ChildPath 'stuff' @(
    'a' * 240 -join ''
    'b' * 240 -join '' ) )

( Test-Path $scaryPathFolder ) ? '' : ( mkdir $scaryPathFolder )

$info.ScaryPath = $ScaryPathFolder
$info.ScaryPath_Length = $ScaryPathFolder.length
$info.ScaryPath_SegLengths = $scaryPathFolder -split '\\'
    | Join-String -p { $_.Length } -sep ', '

$Info
@'
notes:
Here's a couple of details on MAX_PATH I hadn't ran across
There's a few causes how `LongPathsEnabled` is ignored

> - Starting in Windows 10, version 1607, MAX_PATH limitations have been removed from common Win32 file and directory functions. However, you must opt-in to the new behavior.
> - Windows API has many functions that also have Unicode versions to permit an extended-length path for a **maximum total path length of 32,767 characters**. This type of path is composed of components separated by backslashes, each up to the value returned in the `lpMaximumComponentLength` parameter of the `GetVolumeInformation` function. ( That part is commonly set to 255 )
> - Because you cannot use the `"\\?\"` prefix with a relative path, **relative paths are always limited to a total of MAX_PATH characters.**

I wonder if `32,767 characters` is number of chars, or codepoints? Probably the former?

<https://learn.microsoft.com/en-us/windows/win32/fileio/maximum-file-path-limitation?tabs=registry#enable-long-paths-in-windows-10-version-1607-and-later>
 32,767 characters.
> The maximum path of 32,767 characters is approximate,

> path is composed of components separated by backslashes, each up to the value returned in the lpMaximumComponentLength parameter of the GetVolumeInformation function (this value is commonly 255 characters)

'@
