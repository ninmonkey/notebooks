using namespace System.Collections.Generic
using namespace System.Management.Automation
using namespace System.Management

'Future testing could test for
- [ ] in a basic function
- [ ] in a basic function nested 2 layers deep
- [ ] in a script block
- [ ] in a script block nested 2 layers deep
- [ ] in a script block nested in a basic function
- [ ] then repeat all of the above in a module''s scope: <file:///./MyInvocationInfo-AsModule.psm1>
'
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
