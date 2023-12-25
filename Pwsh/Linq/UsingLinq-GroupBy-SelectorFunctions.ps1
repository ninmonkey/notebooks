using namespace System.Collections.Generic
using namespace System.Linq
using namespace System.Management.Automation

$procs = Get-Process
$groupProcs = [Enumerable]::GroupBy( $procs,
    [Func[object, string]]{
        param($p) return $p.Name })

h1 'result of groupings'

@(foreach($g in $groupProcs) {
    @( $g | Measure-Object -Property VirtualMemorySize64, PrivateMemorySize64 -Sum -Average -Maximum )
    | Add-Member -NotePropertyMembers @{ Name = $g.Key } -force -PassThru -ea ignore
})
    | Select -first 15
    | ft -auto Name, Property, Count, Average, Sum, Maximum

<#
[3] Outputs

Name               Property            Count          Average                Sum          Maximum
----               --------            -----          -------                ---          -------
Code               VirtualMemorySize64    26 3276366924563.69  85185540038656.00 3424346501120.00
Code               PrivateMemorySize64    26     109425585.23      2845065216.00     622895104.00
com.docker.service VirtualMemorySize64     1    5003096064.00      5003096064.00    5003096064.00
com.docker.service PrivateMemorySize64     1      53522432.00        53522432.00      53522432.00

#>


$all_procs = Get-Process
$select_parentPid =
    [Func[object, string]]{
        param($p) return $p.Parent.Id }

$select_parentName =
    [Func[object, string]]{
        param($p) return $p.Parent.Name }

$source = $all_procs
$by_ParentPid = [Enumerable]::GroupBy(
    <# source: #> $all_procs,
    <# keySelector: #> $select_parentPid )

function fmt.ProcName {
    param(
        [Parameter(ValueFromPipeline)]
        [Diagnostics.Process]$InObj )
    process {
        "${fg:#ceceaa}{0}${fg:#555555} {1}${fg:clear}" -f @(
            $InObj.Name, $InObj.Id
        )
    }
}
$by_ParentPid | %{
    [pscustomobject]@{
        Parent =
            [string]::IsNullOrWhiteSpace( $_.Key ) ?
                "`u{2400}" : $_.Key
        Items = $_.GetEnumerator() | fmt.ProcName
    }
}

<#
[4] outputs....

Parent Items
------ -----
␀      {AppleMobileDeviceService 5752, ApplicationFrameHost
11540  {PowerToys.AlwaysOnTop 3168, PowerToys.ColorPickerUI 2188, PowerToys.CropAndLock 3328
33524  {Code 1040, Code 15264, Code 25808, Code 26692…}
28884  {Code 1236, rundll32 32480, steam 26536, WindowsTerm
19064  {Code 11444, Code 13656, Code 14916, Code 18452…}
1236   {Code 13580, Code 15940, Code 16208, Code 19064…}

#>



$names = Get-Process | % Name
$groupedNames =
    [Enumerable]::GroupBy( $names,
        [Func[object,string]]{param($n) return $n})

$groupedNames
    | select -first 8
    | Join-String -p { $_.key, @($_.GetEnumerator()).count } -sep "`n"

<#
[2] outputs:

    Code 26
    com.docker.service 1
    CompPkgSrv 1
    conhost 11
    Discord 6
    steam 1
    svchost 97
#>


$groupedNames
    | select -first 8
    | Join-String -Property { $_.GetEnumerator() -join ', ' } -sep "`n"

<#
[1] outputs:

    Code Code Code Code Code Code Code Code Code Code Code
    com.docker.service
    Discord Discord Discord Discord Discord Discord

#>
