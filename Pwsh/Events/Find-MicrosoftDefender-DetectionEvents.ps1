
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
