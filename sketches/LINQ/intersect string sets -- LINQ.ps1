using namespace System.Collections.Generic


$arr = 'a', 'b', 'c', 'd'
$a = $arr[0..2]
$b = $arr[1..($arr.Count - 1)]
[Linq.Enumerable]::Intersect([string[]] $a, [string[]] $b)


$a = $arr[0..2]
$b = $arr[1..($arr.Count - 1)]
[Linq.Enumerable]::Intersect([string[]] $a, [string[]] $b)




function Linq.diff.string { 
    <#
    .EXAMPLE

    .notes
        # see related:
        [linq.enumerable] | Find-Member
    #>
    param(
        [ALias('Left')]
        [Parameter(Mandatory)]
        [string[]]$InputTextA,

        [ALias('Right')]
        [Parameter(Mandatory)]
        [string[]]$InputTextB,

        [switch]$CaseSensitive
    )
    if($CaseSensitive) { throw "NYI: lookup in linq"}
    
    [string[]]$Left_ci = @(foreach($str in $InputTextA) {
        $str.ToLower()
    })
    [string[]]$Right_ci = @(foreach($str in $InputTextB) {
        $str.ToLower()
    })

    class StringSetComparisonResult {
        hidden [List[string]]$OriginalLeft
        hidden [List[string]]$OriginalRight
        [List[string]]$Intersect
        [List[string]]$RemainingLeft
        [List[string]]$RemainingRight
        [List[string]]$Union
    }
     
    
    [string[]]$both = [Linq.Enumerable]::Intersect($InputTextA, $InputTextB)

    [StringSetComparisonResult]@{
        OriginalLeft = $InputTextA
        OriginalRight = $InputTextB
        Intersect = $both
        RemainingLeft = [string[]]@('a')
        RemainingRight = 'b'
    }
}


Linq.diff.string -Left @('a', 'b', 'cat', 'a') -Right @('b', 'c', 'cat', 'a')



Linq.diff.string -Left @('a', 'b', 'cat', 'a', 'Bat') -Right @('b', 'Bat', 'c', 'cat', 'a')


@'
ndmy history paths


to detect run these

    (Get-PSReadLineOption).HistorySavePath
    (Get-PSReadLineOption).HistorySavePath | split-path | ls -filter *hist*

    ~\AppData\Roaming\Microsoft\Windows\PowerShell\PSReadline\

}
'@

function jsonShrink {
    process {
        $_ | Get-Item | % FullName }
}

@{
    label = 'next'
    hsp = (Get-PSReadLineOption).HistorySavePath | gi | % fullname
    # hs_ls = (Get-PSReadLineOption).HistorySavePath | split-path | ls -filter *hist* | % gi | % 
    hs_ls = (Get-PSReadLineOption).HistorySavePath | split-path | ls -filter *hist* | get-item | % fullname 
}

C:\Users\cppmo_000\SkyDrive\Documents\PowerShell\Microsoft.PowerShell_profile.ps1
C:\Users\cppmo_000\SkyDrive\Documents\PowerShell\Microsoft.VSCode_profile.ps1

function collectInfo {
    @{
        label = 'WinPS5.external'
        hsp = (Get-PSReadLineOption).HistorySavePath | gi | % fullname
        # hs_ls = (Get-PSReadLineOption).HistorySavePath | split-path | ls -filter *hist* | % gi | % 
        hs_ls = (Get-PSReadLineOption).HistorySavePath | split-path | ls -filter *hist* | get-item | % fullname 
    } | ConvertTo-Json -Compress | Set-Clipboard
}
[object[]]$Results = @(

    @{
        Label = 'Pwsh.VsCode.Default'
        Json = '
{"hs_ls":["C:\\Users\\cppmo_000\\AppData\\Roaming\\Microsoft\\Windows\\PowerShell\\PSReadline\\ConsoleHost_history.txt","C:\\Users\\cppmo_000\\AppData\\Roaming\\Microsoft\\Windows\\PowerShell\\PSReadline\\ConsoleHost_history.txt.0j","C:\\Users\\cppmo_000\\AppData\\Roaming\\Microsoft\\Windows\\PowerShell\\PSReadline\\Visual Studio Code Host_history.txt"],"label":"Pwsh.VsCode.Defualt","hsp":"C:\\Users\\cppmo_000\\AppData\\Roaming\\Microsoft\\Windows\\PowerShell\\PSReadLine\\ConsoleHost_history.txt"}
        '
    }
    @{
        Label = 'Pwsh.VsCode.Addon'
        Json = '
{"hsp":"C:\\Users\\cppmo_000\\AppData\\Roaming\\Microsoft\\Windows\\PowerShell\\PSReadLine\\Visual Studio Code Host_history.txt","label":"Pwsh.VsCode.Addon","hs_ls":["C:\\Users\\cppmo_000\\AppData\\Roaming\\Microsoft\\Windows\\PowerShell\\PSReadline\\ConsoleHost_history.txt","C:\\Users\\cppmo_000\\AppData\\Roaming\\Microsoft\\Windows\\PowerShell\\PSReadline\\ConsoleHost_history.txt.0j","C:\\Users\\cppmo_000\\AppData\\Roaming\\Microsoft\\Windows\\PowerShell\\PSReadline\\Visual Studio Code Host_history.txt"]}
'
    }
    @{
        Label = 'Pwsh.External'
        Json = '
{"label":"Pwsh.External","hs_ls":["C:\\Users\\cppmo_000\\AppData\\Roaming\\Microsoft\\Windows\\PowerShell\\PSReadline\\ConsoleHost_history.txt","C:\\Users\\cppmo_000\\AppData\\Roaming\\Microsoft\\Windows\\PowerShell\\PSReadline\\ConsoleHost_history.txt.0j","C:\\Users\\cppmo_000\\AppData\\Roaming\\Microsoft\\Windows\\PowerShell\\PSReadline\\Visual Studio Code Host_history.txt"],"hsp":"C:\\Users\\cppmo_000\\AppData\\Roaming\\Microsoft\\Windows\\PowerShell\\PSReadLine\\ConsoleHost_history.txt"}
'
    }

    @{
        Label = 'WinPS5.external'
        Json = '
    {"label":"WinPS5.external","hsp":"C:\\Users\\cppmo_000\\AppData\\Roaming\\Microsoft\\Windows\\PowerShell\\PSReadLine\\ConsoleHost_history.txt","hs_ls":["C:\\Users\\cppmo_000\\AppData\\Roaming\\Microsoft\\Windows\\PowerShell\\PSReadLine\\ConsoleHost_history.txt","C:\\Users\\cppmo_000\\AppData\\Roaming\\Microsoft\\Windows\\PowerShell\\PSReadLine\\ConsoleHost_history.txt.0j","C:\\Users\\cppmo_000\\AppData\\Roaming\\Microsoft\\Windows\\PowerShell\\PSReadLine\\Visual Studio Code Host_history.txt"]}
'
    }
) | %{ [pscustomobject]$_ }