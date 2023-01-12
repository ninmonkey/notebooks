function Robo.Copy {
    <#
    .SYNOPSIS
        simplified wrapper of Robocopy, sugar for regular duplicating of paths
    .DESCRIPTION
        quick, initial pass. meant to simplify my most common invokes
    .NOTES
        see also. desktop.ini files are copied
            <https://learn.microsoft.com/en-us/windows/win32/shell/how-to-customize-folders-with-desktop-ini>
    .EXAMPLE        
        Robo.Copy @robo_splat -CommandPassThru | join-string -sep ' ' { $_ | out-string }            
    #>
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter()]
        [hashtable]$Options = @{},

        # Robocopy /S
        [Alias('/S')]
        [switch]$Recurse,

        # returns the command line args that was built, without executing
        [switch]$CommandPassthru,
        # quick help
        [switch]$Help
        # [switch]$WhatIf # even though I use WhatIf, can't declare it because it already is from ShouldProcess
    )
    if ($Help) { 
        @'
- [official robocopy docs](https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/robocopy
        - [file options](https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/robocopy#file-selection-options)
        - [Logging Options](https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/robocopy#logging-options)
- [adamtheautomator's guide'(https://adamtheautomator.com/robocopy/#Source_Options)
'@
        $hinfo = Get-Command robo.copy | Get-Help
        $hinfo.parameters[0] | s * -expand Parameter -ea ignore  | Format-Table
        Get-Command robo.copy -Syntax
        return
    }


    $Config = mergeHashtable -other $Options -BaseHash @{
        Using = @{
            WhatIf                = -not $WhatIf # inverts outer param
            Tee                   = $true
            Recurse               = $Recurse # from outer param
            ETA                   = $True
            RestartableMode       = $true
            BackupMode            = $null
            RestartableBackupMode = $true
            UnbufferedIO          = $true
            LogAppend = $true                        
        }
        MaxDepth = $Null # false?
    }
    if($Recurse) {
        $Config.Using.Recurse = $true
    }

    Set-Location $Config.Dest -ea Ignore | out-null

    $Config | Format-Table -AutoSize | out-string | write-debug

    'Log: <{0}>' -f @(
        $Config.Log
    ) | Write-Information

    if( [string]::IsNullOrWhiteSpace( $Config.Dest ) ) {
        throw "Missing Dest Path"
    }

    
    [Collections.Generic.List[Object]]$RoboArgs = @(
        # (Get-Item -ea stop $Config.Source) | Join-String -DoubleQuote
        (Get-Item -ea stop $Config.Source)

        # $Config.Dest | Join-String -DoubleQuote
        $Config.Dest

        $Config.Using.Recurse ? '/S' : $null
        # '/COPYALL'
        '/COPY:DAT'  # data, attribute, timestamp
        if ($False) { 
            # /COPY:<flags> 
            # Data, attributes, timestamps, NTFS control list, Owner, AuditInfo
            '/COPY:DAT'  # data, attribute, timestamp
            '/DCOPY:DA'  # data, attributes
            '/sec' # alias of '/copy:DATS'
            '/copyall' # alias of '/copy:DATSOU'
            '/nocopy' # use with /purge

            '/purge' # Deletes destination files and directories that no longer exist in the source. 
            # Using this option with the /e option and a destination directory, allows
            # the destination directory security settings to not be overwritten.

            '/mir' # alias for '/purge' plus '/e'
            '/mov' # more files, deletes from source as copied
            
            # monitor for changes
            '/mon<n>'
            '/mot<m>'

            # Creates multi-threaded copies with n threads. n must be an integer
            #  between 1 and 128. The default value for n is 8. For better performance,
            # redirect your output using /log option.
            '/mt[:n]'
            <#
            /rh:hhmm-hhmm 	Specifies run times when new copies may be started.
            /pf 	Checks run times on a per-file (not per-pass) basis.
            /ipg:n 	Specifies the inter-packet gap to free bandwidth on slow lines.
            /sj 	Copies junctions (soft-links) to the destination path instead of link targets.
            /sl 	Don't follow symbolic links and instead create a copy of the link.
            /nodcopy 	Copies no directory info (the default /dcopy:DA is done).
            /nooffload 	Copies files without using the Windows Copy Offload mechanism.
            /compress 	Requests network compression during file transfer, if applicable.
            #>

            
        }
        # if($Config.MaxDepth) {
        # $Config.Recurse ? '/S' : $null

        if($Config.MaxDepth -as 'int') {
            '/LEV:{0}' -f @( $Config.MaxDepth )
        }

        # z: Copies files in restartable mode
        $Config.Using.RestartableMode ? '/z' : $null
        # b: Copies files in backup mode
        $Config.Using.BackupMode ? '/b' : $null
        # zb: restartable mode. if permission is denied, goto backup mode.
        $Config.Using.RestartableBackupMode ? '/zb' : $null
        # j: (recommended for large files).
        $Config.Using.UnbufferedIO ? '/j' : $null
        

        '/UNICODE'    
        # '/UNILOG:{0}' -f @($Config.Log)
        '/UNILOG+:{0}' -f @($Config.Log) # to append always, for now.

        # tee: write status to console and window
        
        $Config.Using.Tee ? '/Tee' : $null
        ($Config.Using.WhatIf -or $Whatif ) ? '/L' : $null
        
        $Config.Using.ETA ? '/ETA' : $null # maybe bad when using a log, else ok?
        
    )
    if ($false) { 
        $RoboArgs.AddRange(@(
                'stuff'
            ))
    }
    if($CommandPassthru) { 
        return $RoboArgs
    }

    $RoboArgs | Join-String -op 'Robocopy.exe ' -sep ' '
    | Write-Information

    $logPath? = Get-Item -ea ignore $Config.Log
    $path = $logPath? ?? $Config.Log

    $strTarget = "`ncopy from:`n  {0}`nTo:`n  {1}`n`nLog: {2}`n" -f @(
        $Config.Source
        $Config.Dest
        $path | Join-String -DoubleQuote
    ) | Write-ConsoleColorZd -fg 'gray30' | Write-Information 

    $StrTarget | Write-Verbose

    if ($PSCmdlet.ShouldProcess( $strTarget , 'Robocopy.Copy')) {
        & Robocopy @RoboArgs
    }

    'wrote: "{0}"' -f @(
        (gi -ea ignore $Config.Log) ?? $config.Log
    ) | Write-Information -infa Continue
}

# $Cfg = @{
#     # Source = Get-Item -ea stop 'T:\Users\Public'
#     # Source = Get-Item -ea stop 'H:\robo_root\root_T_oldClone'
#     Source = Get-Item -ea stop 'T:\Users\Public'
#     Dest  = Get-Item -ea stop 'H:\robo_root\Told_clone'
#     Log   = 'lastHuge.log'
#     Using = @{
#         Tee    = $True
#         WhatIf = $false
#         ETA    = $True
#     }
# }
# # Set-Location $PSScriptRoot
# $Cfg | Format-Table -AutoSize

# # Robo.Copy $Cfg
# #Write-Host 'try: Robo.Copy $Cfg' -ForegroundColor orange -bg darkred
# Write-Host 'try: Robo.Copy $Cfg' -ForegroundColor darkred -bg yellow

# $robo_splat = @{    
#     Recurse           = $true
#     Verbose           = $true
#     Debug             = $true
#     InformationAction = 'continue'
#     WhatIf = $true
#     Options = $Cfg
# }

# # Robo.Copy @robo_splat