# using namespace System.Collections.Generic
Import-Module ninmonkey.console

$Paths = @{ # see bottom
    SourceRoot = ''
    DestRoot   = ''
}
# $Paths.SourceRoot = Get-Item 'H:\root_huge_temp\old-psmodulepaths'
# throw 'edit to confirm'
$Paths.Log = @{
    Unicode = 'lastUni.log'
    Basic   = '' # 'last.log'
}

$Paths | Format-Table -AutoSize
$RoboConf = @{

    Using = @{
        ETA             = $True
        Unicode         = $True
        WhatIfOrConfirm = $true
    }
}
$Roboconf.Using.WhatifOrConfirm = $true
$binRobo = Get-Command -CommandType Application 'robocopy' | Select-Object -First 1

function _backup_driveT {
    . {
    }

    . {
        $ErrorActionPreference = 'break'
        $Paths.SourceRoot = 'C:\Users\cppmo_000\SkyDrive\Documents\2021\Powershell\My_Github'
        $Paths.DestRoot = 'H:\root_huge_temp\old-psmodulepaths\2021_myGithubModules'

        [Collections.Generic.List[object]]$finalRoboArgs = @(
            $Paths.SourceRoot | Get-Item #| Join-String -DoubleQuote
            $Paths.DestRoot #| Join-String -DoubleQuote
            $RoboConf.Using.Unicode ? '/UNICODE'                         : ''
            $Paths.Log.Basic        ? '/LOG:{0}' -f $Paths.Log.Basic     : ''
            $Paths.Log.Unicode      ? '/UNILOG:{0}' -f $Paths.Log.Unicode: ''

            'subfolders' ? '/S': ''
            '/COPYALL'

            $RoboConf.Using.WhatIfOrConfirm ? '/L': ''
            $RoboConf.Using.ETA ? '/ETA' : ''
        )
        $finalRoboArgs | Join-String -sep ' ' -op 'cmd Args: Robocopy.exe '

        & $BinRobo @FinalRoboArgs

        if ($RoboConf.Using.WhatIfOrConfirm) {
            'using WhatIf: "/L"' | Write-Host -fg orange
        }
        $ErrorActionPreference = 'Continue'
        ToastIt -title 'robocopy' -text 'Step2+ Final -> Finished'
    }
}
function _backupExample {
    . {
        $ErrorActionPreference = 'break'
        $Paths.SourceRoot = Get-Item -ea 'stop' 'C:\Users\cppmo_000\SkyDrive\Documents\PowerShell'
        $Paths.DestRoot = 'H:\root_huge_temp\old-psmodulepaths\from_cDocsSkyDriveModules'

        [Collections.Generic.List[object]]$finalRoboArgs = @(
            $Paths.SourceRoot | Get-Item #| Join-String -DoubleQuote
            $Paths.DestRoot #| Get-Item #| Join-String -DoubleQuote
            $RoboConf.Using.Unicode ? '/UNICODE'                         : ''
            $Paths.Log.Basic        ? '/LOG:{0}' -f $Paths.Log.Basic     : ''
            $Paths.Log.Unicode      ? '/UNILOG:{0}' -f $Paths.Log.Unicode: ''

            'subfolders' ? '/S': ''
            '/COPYALL'

            $RoboConf.Using.WhatIfOrConfirm ? '/L': ''
            $RoboConf.Using.ETA ? '/ETA' : ''
        )
        $finalRoboArgs | Join-String -sep ' ' -op 'cmd Args: Robocopy.exe '

        & $BinRobo @FinalRoboArgs

        if ($RoboConf.Using.WhatIfOrConfirm) {
            'using WhatIf: "/L"' | Write-Host -fg orange
        }
        $ErrorActionPreference = 'continue'
        ToastIt -title 'robocopy' -text 'Step1 -> Finished'
    }

    . {
        $ErrorActionPreference = 'break'
        $Paths.SourceRoot = 'C:\Users\cppmo_000\SkyDrive\Documents\2021\Powershell\My_Github'
        $Paths.DestRoot = 'H:\root_huge_temp\old-psmodulepaths\2021_myGithubModules'

        [Collections.Generic.List[object]]$finalRoboArgs = @(
            $Paths.SourceRoot | Get-Item #| Join-String -DoubleQuote
            $Paths.DestRoot #| Join-String -DoubleQuote
            $RoboConf.Using.Unicode ? '/UNICODE'                         : ''
            $Paths.Log.Basic        ? '/LOG:{0}' -f $Paths.Log.Basic     : ''
            $Paths.Log.Unicode      ? '/UNILOG:{0}' -f $Paths.Log.Unicode: ''

            'subfolders' ? '/S': ''
            '/COPYALL'

            $RoboConf.Using.WhatIfOrConfirm ? '/L': ''
            $RoboConf.Using.ETA ? '/ETA' : ''
        )
        $finalRoboArgs | Join-String -sep ' ' -op 'cmd Args: Robocopy.exe '

        & $BinRobo @FinalRoboArgs

        if ($RoboConf.Using.WhatIfOrConfirm) {
            'using WhatIf: "/L"' | Write-Host -fg orange
        }
        $ErrorActionPreference = 'Continue'
        ToastIt -title 'robocopy' -text 'Step2+ Final -> Finished'
    }
}
# $Paths = @{
#     #
#     # SourceRoot = Get-Item 'C:\Users\cppmo_000\SkyDrive\Documents\2021\powershell\My_Github'
#     DestRoot = 'H:\root_huge_temp\old-psmodulepaths\root_SkyDocsPowershell'
# }
# $Paths.SourceRoot = Get-Item 'H:\root_huge_temp\old-psmodulepaths'
# $Paths.DestRoot = 'H:\root_huge_temp\old-psmodulepaths\root_SkyDocsPowershell'
# H:\root_huge_temp\old-psmodulepaths
# $Paths.DestRoot = 'H:\root_huge_temp\old-psmodulepaths\from_SkyDriveDocs'

return
Hr
. {
    $Paths.SourceRoot = Get-Item -ea 'stop' 'C:\Users\cppmo_000\SkyDrive\Documents\2021\Powershell\My_Github'
    $Paths.DestRoot = 'H:\root_huge_temp\old-psmodulepaths\from_2021My_github'
    $finalRoboArgs | Join-String -sep ' ' -op 'cmd Args: Robocopy.exe '
    & $BinRobo @FinalRoboArgs
}




'write-warning: Future: As a job, wait, then toastit when done'



































return
class User {
    #  [object]$User
    [int]$AACount = 0
    [int]$ABCount = 0
    [int]$OtherCount = 0
    # object]$MostFrequentLogin = $null
    # or:
    #   [AllowNull()][object]$MostFrequentLogin = $null

    [int] GetMax() {
        $measure = @(
            $This.AACount, $This.ABCount, $This.OtherCount) | Measure-Object -Maximum
        return ($Measure).Maximum
    }
}


# You can call the constructor with a hashtable
$user = [User]@{
    AACount    = 23
    ABCount    = 9
    OtherCount = 10
}

$user | Format-Table -auto
H1 'user: max'
$user.GetMax()

Hr

# or call it yourself
$user2 = [User]::new()
$user2 | Format-Table -auto
H1 'user2: max'
$user2.GetMax()

$user | Format-Table -auto
