
# Query the event log
$when = $startTime.ToUniversalTime().ToString('o')
$getWinEventSplat = @{
    LogName     = 'Microsoft-Windows-Windows Defender/Operational'
    FilterXPath = "*[System[TimeCreated[@SystemTime>='${when}']]]"
    # FilterXPath = "*[System[TimeCreated[@SystemTime>='$($startTime.ToUniversalTime().ToString('o'))']]]" # forgive me. copilot wrote this format string
}

$query = Get-WinEvent @getWinEventSplat
    | ? Message -Match 'Taken action|has detected'


# quick summary
$query | Join-string -sep ("`n`n") -p Message
$query | Ft -auto

<# outputs
$query[1]|fl * -Force

    Message :
        Microsoft Defender Antivirus has detected malware or other potentially unwanted software.
        For more information please see the following: https://go.microsoft.com/fwlink/?linkid=37020&name=Trojan:PowerShell/ScriptSmug.A&threatid=2147914598&enterprise=0
                Name: Trojan:PowerShell/ScriptSmug.A
                ID: 2147914598
                Severity: Severe
                Category: Trojan
                Path: file:_G:\2023-git\SeeminglyScience👨\dotfiles\Documents\PowerShell\NamespaceAwareCompletion.ps1
                Detection Origin: Local machine
                Detection Type: Concrete
                Detection Source: User
                User: nin8\cppmo_000
                Process Name: C:\Users\cppmo_000\AppData\Local\GitHubDesktop\app-3.4.1\resources\app\git\mingw64\bin\git.exe
                Security intelligence Version: AV: 1.413.626.0, AS: 1.413.626.0, NIS: 1.413.626.0
                Engine Version: AM: 1.1.24050.5, NIS: 1.1.24050.5
    Id                   : 1116
    Version              : 0
    Qualifiers           :
    Level                : 3
    Task                 : 0
    Opcode               : 0
    Keywords             : -9223372036854775808
    RecordId             : 95171
    ProviderName         : Microsoft-Windows-Windows Defender
    ProviderId           : 11cd958a-c507-4ef3-b3f2-5fd9dfbd2c78
    LogName              : Microsoft-Windows-Windows Defender/Operational
    ProcessId            : 6756
    ThreadId             : 25376
    MachineName          : nin8
    UserId               : S-1-5-18
    TimeCreated          : 2024-07-01 10:58:54 AM
    ActivityId           :
    RelatedActivityId    :
    ContainerLog         : Microsoft-Windows-Windows Defender/Operational
    MatchedQueryIds      : {}
    Bookmark             : System.Diagnostics.Eventing.Reader.EventBookmark
    LevelDisplayName     : Warning
    OpcodeDisplayName    : Info
    TaskDisplayName      :
    KeywordsDisplayNames : {}
    Properties           : {System.Diagnostics.Eventing.Reader.EventProperty, System.Diagnostics.Eventing.Reader.EventProperty,

#>

<#
# A defender module. It uses CIM. Very slow.

WinPS5> $cat = Get-MpThreatCatalog
WinPS5> $query = $cat | ? ThreatName -Match 'smug'
WinPS5> $query | ft

    CategoryID SeverityID   ThreatID ThreatName                     TypeID PSComputerName
    ---------- ----------   -------- ----------                     ------ --------------
            8          5 2147869450 Trojan:HTML/Smuggling               0
            8          5 2147910863 Trojan:VBS/SmugVBS.C                0
            8          5 2147914598 Trojan:PowerShell/ScriptSmug.A      0
            8          5 2147914601 Trojan:MSIL/ScriptSmug.A            0
            8          5 2147914602 Trojan:MSIL/ScriptSmug.B            0

WinPS5> $query | ? ThreatName -Match 'ScriptSmug.A' | ft -AutoSize

    CategoryID SeverityID   ThreatID ThreatName                     TypeID PSComputerName
    ---------- ----------   -------- ----------                     ------ --------------
            8          5 2147914598 Trojan:PowerShell/ScriptSmug.A      0
            8          5 2147914601 Trojan:MSIL/ScriptSmug.A            0


WinPS5> $fin|fl * -Force


    CategoryID            : 8
    SeverityID            : 5
    ThreatID              : 2147914598
    ThreatName            : Trojan:PowerShell/ScriptSmug.A
    TypeID                : 0
    PSComputerName        :
    CimClass              : ROOT/Microsoft/Windows/Defender:MSFT_MpThreatCatalog
    CimInstanceProperties : {CategoryID, SeverityID, ThreatID, ThreatName...}
    CimSystemProperties   : Microsoft.Management.Infrastructure.CimSystemProperties
#>
