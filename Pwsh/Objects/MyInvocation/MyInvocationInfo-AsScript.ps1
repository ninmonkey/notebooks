using namespace System.Collections.Generic
using namespace System.Management.Automation
using namespace System.Management

$Config = @{
    SuperVerboseSummaryRender = $True
}
if($SuperVerbose) { }
$meta = [ordered]@{
    PsRoot       = $PSScriptRoot
    PsCmdPath    = $PSCommandPath
    MyI          = $MyInvocation
    MyI_Cmd      = $MyInvocation.MyCommand # [ScriptInfo]
    MyI_Cmd_Path = $MyInvocation.MyCommand.Source
    MyI_Cmd_Src  = $MyInvocation.MyCommand.Source

    # $MyInvocation.MyCommand.Name
    # $MyInvocation
    # $MyInvocation.DisplayScriptPosition

}
$meta | ft -auto


if($Config.SuperVerboseSummaryRender) {
    $Meta.GetEnumerator() | %{
        h1 ($_.Key |Join-String -f '$meta[ {0} ] => ...')
        if( $_.Value -is 'string' ) { $_.Value |Join-String -op 'raw [string] =: '}
        else { $_.Value | iot2 -NotSkipMost | ft -auto }
    }
}
