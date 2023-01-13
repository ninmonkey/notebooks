$md_Docstring = @'
<#
Some, (but not all) options . 

::
:: Logging Options :
::
                 /L :: List only - don't copy, timestamp or delete any files.
                 /X :: report all eXtra files, not just those selected.
                 /V :: produce Verbose output, showing skipped files.
                /TS :: include source file Time Stamps in the output.
                /FP :: include Full Pathname of files in the output.
             /BYTES :: Print sizes as bytes.

                /NS :: No Size - don't log file sizes.
                /NC :: No Class - don't log file classes.
               /NFL :: No File List - don't log file names.
               /NDL :: No Directory List - don't log directory names.

                /NP :: No Progress - don't display percentage copied.
               /ETA :: show Estimated Time of Arrival of copied files.

          /LOG:file :: output status to LOG file (overwrite existing log).
         /LOG+:file :: output status to LOG file (append to existing log).

       /UNILOG:file :: output status to LOG file as UNICODE (overwrite existing log).
      /UNILOG+:file :: output status to LOG file as UNICODE (append to existing log).

               /TEE :: output to console window, as well as the log file.

               /NJH :: No Job Header.
               /NJS :: No Job Summary.

/UNICODE :: output status as UNICODE.

::
:: Retry Options :
::

    /R:n :: number of Retries on failed copies: default 1 million.
    /W:n :: Wait time between retries: default is 30 seconds.

    /REG :: Save /R:n and /W:n in the Registry as default settings.

    /TBD :: Wait for sharenames To Be Defined (retry error 67).

    /LFSM :: Operate in low free space mode, enabling copy pause and resume (see Remarks). 

    /LFSM:n[KMG] :: /LFSM, specifying the floor size in n [K:kilo,M:mega,G:giga] bytes.



#>
'@
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
    .EXAMPLE        
        # test, as a list only
        Robo.Copy @robo_splat -Recurse -LimitOutput -ListOnly
    .EXAMPLE            
        # skip any inner ShouldProcess prompts
        Robo.Copy @robo_splat -Recurse -LimitOutput -ListOnly -WithoutWhatIf
    .EXAMPLE        
        # misc 

        Robo.Copy @robo_splat -Recurse -LimitOutput -ListOnly
        Robo.Copy @robo_splat -Recurse -LimitOutput -Confirm   
        Robo.Copy @robo_splat -Recurse -LimitOutput
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


        # general switch to ignore some extra outputs
        [switch]$LimitOutput,

        [Alias('Force')]
        [switch]$WithoutWhatIf,

        [switch]$ListOnly,

        # returns the command line args that was built, without executing
        [switch]$CommandPassthru,
        # quick help
        [switch]$Help
        # [switch]$WhatIf # even though I use WhatIf, can't declare it because it already is from ShouldProcess
    )
    if ($Help) { 
        $md_Docstring        
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
Documents

    $Config = mergeHashtable -other $Options -BaseHash @{
        Using    = @{
            WhatIf                = -not $WhatIf # inverts outer param
            Tee                   = $true
            Recurse               = $Recurse # from outer param
            ETA                   = $True
            RestartableMode       = $true
            ListOnly              = $null
            BackupMode            = $null
            RestartableBackupMode = $true
            UnbufferedIO          = $true
            LogAppend             = $true
            RetryCount            = 5
            RetryDelay            = 3
            LogTailLinesAtEnd     = 40
        }
        MaxDepth = $Null # false?
    }
    
    
    if ($Config.Using.RetryCount) {        
        '/R:{0}' -f @( $Config.Using.RetryCount ) # default 1million
    }
    if ($Config.Using.RetryDelay) {        
        '/W:{0}' -f @( $Config.Using.RetryDelay ) # default seconds between retries # default 30
    }
    if ($Recurse) {
        $Config.Using.Recurse = $true
    }
    if ($LimitOutput) {
        $Config.Using.Tee = $false
    }
    if ($WithoutWhatIf) {
        $Config.Using.WhatIf = $false
    }
    if ($ListOnly) { 
        $Config.Using.ListOnly
    }

    Set-Location $Config.Dest -ea Ignore | Out-Null

    $Config | Format-Table -AutoSize | Out-String | Write-Debug

    'Log: <{0}>' -f @(
        $Config.Log
    ) | Write-Information

    if ( [string]::IsNullOrWhiteSpace( $Config.Dest ) ) {
        throw 'Missing Dest Path'
    }

    
    [Collections.Generic.List[Object]]$RoboArgs = @(
        # (Get-Item -ea stop $Config.Source) | Join-String -DoubleQuote
        (Get-Item -ea stop -LiteralPath $Config.Source -Force) # force for hidden

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

        if ($Config.MaxDepth -as 'int') {
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
        ($Config.Using.WhatIf -or $Whatif -or $ListOnly) ? '/L' : $null
        
        $Config.Using.ETA ? '/ETA' : $null 
        $Config.Using.ListOnly ? '/L' : $null 
        $Config.Using.NoProgressBar ? '/NP' : $null 

    )
    if ($false) { 
        $RoboArgs.AddRange(@(
                'stuff'
            ))
    }
    if ($CommandPassthru) { 
        return $RoboArgs
    }

    $RoboArgs | Join-String -op 'Robocopy.exe ' -sep ' '
    | Write-Information

    $logPath? = Get-Item -ea ignore -LiteralPath $Config.Log
    $path = $logPath? ?? $Config.Log

    $strTarget = "`ncopy from:`n  {0}`nTo:`n  {1}`n`nLog: {2}`n" -f @(
        $Config.Source
        $Config.Dest
        $path | Join-String -DoubleQuote
    ) | Write-ConsoleColorZd -fg 'gray30' | Write-Information 

    $StrTarget | Write-Verbose

    if ($Config.using.WhatIf) {
        if ($PSCmdlet.ShouldProcess( $strTarget , 'Robocopy.Copy')) {
            & Robocopy @RoboArgs
        }
    }
    else {
        & Robocopy @RoboArgs
    }

    'wrote: "{0}"' -f @(
        (Get-Item -ea ignore $Config.Log) ?? $config.Log
    ) | Write-Information -infa Continue

    if ($Config.using.LogTailLinesAtEnd -as 'int') { 
        Get-Content $Config.Log -Tail $Config.Using.LogTailLinesAtEnd
    }
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