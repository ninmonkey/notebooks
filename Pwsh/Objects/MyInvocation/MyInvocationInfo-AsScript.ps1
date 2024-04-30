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

    Abbr_Path = $MyInvocation.MyCommand.Source # is this always equal to _.ScriptBlock.File ?
    Abbr_Name = $MyInvocation.MyCommand.Name
    Abbr_SbFile= $MyInvocation.MyCommand.ScriptBlock.File

    

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

# $Meta.Abbr_All = @{
    $Meta.Abbr_Path, $meta.Abbr_Name, $meta.Abbr_SbFile | Join.ul
# render abbr only
$meta.Keys | ?{ $_ -match 'abbr' }
    | %{ $Meta[ $_ ] | join-string -f "${_} => {0}" }
