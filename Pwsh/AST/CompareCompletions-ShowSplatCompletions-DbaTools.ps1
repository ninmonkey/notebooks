# About:  tab expansion version
$src = @'
Import-Module DbaTools -passthru
$splatExport = @{
    # comment

}
Export-DbaLogin @splatExport
'@
$Pos = $src.IndexOf('# comment')

# Position of the cursor changes completions, in this case it's important
$found = TabExpansion2 -inputScript $src -cursorColumn $Pos
    | % CompletionMatches

$found | Join-string -sep "`n" -p { $_.CompletionText, $_.Tooltip }
<#
Outputs:
    SqlInstance [DbaInstanceParameter[]]
    SqlCredential [PSCredential]
    InputObject [Object[]]
    Login [Object[]]
    ExcludeLogin [Object[]]
    Database [Object[]]
    ExcludeJobs [SwitchParameter]
    ExcludeDatabase [SwitchParameter]
    ExcludePassword [SwitchParameter]
    DefaultDatabase [String]
    Path [String]
    FilePath [String]
    Encoding [String]
    NoClobber [SwitchParameter]
    Append [SwitchParameter]
    BatchSeparator [String]
    DestinationVersion [String]
    NoPrefix [SwitchParameter]
    Passthru [SwitchParameter]
    ObjectLevel [SwitchParameter]
    EnableException [SwitchParameter]
    Verbose [SwitchParameter]
    Debug [SwitchParameter]
    ErrorAction [ActionPreference]
    WarningAction [ActionPreference]
    InformationAction [ActionPreference]
    ProgressAction [ActionPreference]
    ErrorVariable [String]
    WarningVariable [String]
    InformationVariable [String]
    OutVariable [String]
    OutBuffer [Int32]
    PipelineVariable [String]
    WhatIf [SwitchParameter]
    Confirm [SwitchParameter]
#>
