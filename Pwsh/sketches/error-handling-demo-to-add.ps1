```ps1
<#
class-as-a-record

#>

class records {
    # [sdfds]$dsf   # nice validation herea nd ctor
}

function LoadConfig {
    <#
    A bit of a silly example. I tried to keep it sort-of-real, but also edited
    nonsense, to fit multiple examples
    #>
    [CmdletBinding()]
    param (
        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory)][string]$Path
    )
    # [a]  some errors should be [1] loud, and [2] optional
    # Like a user's config file, so they know they have the wrong filepath
    $Optional = 'foo.xml', 'bar.json' | Get-Item

    # [b] some errors should be [1] silent, and [2] optional
    # some cases you either want the value, or null, but silently
    $SilentOption = Get-Item 'c:\foo\app.db' -ea 'ignore'
    if (-not $SilentOption) { rebuildCache } # ...

    # [f] some errors should be [1] silent, and [2] optional
    # perhaps a cache file that doesn't exist, so re-build it silently
    if ( -not $SilentOption ) { Write-Verbose '...' }

    # [c] some errors should be [1] loud, and [2] Fatal
    # if stuff is missing,
    # I don't have to continue to test, it should exit early.
    $Required = '~/.stuff' | Get-Item -ea 'stop'

    # [d] sometimes you may use 'return' as control flow instead of writing an error
    # an example is when you are reciving text from Get-Content
    # newlines are split, which means it can send some null values
    # down the pipeline. Yelling at the user rather than
    # silently continuing is a better experience
    # in that case, don't error
    if ( $Null -eq $Path ) {
        return
    }

    # [e] combined /w [d] sometimes you want exactly true null to
    # betreated differently than falsy/nully values
    $FilepathFromUser = '  '
    if ( -not [String]::IsnullOrEmpty($FilepathFromUser) ) {
        throw 'ParamValueException: Filepath must not be blank'
    }



    # some errors should be [1] silent, and [2] required


    # -ea Stop, automatically early exit on failure, for some validation
    # like the one above, this path error the user does want to see
    code (Get-Item $Path -ea stop)
    # vs code isn't executed with invalid filepaths not
}

function AppEntry {
    $splat = @{}
    if ($strict) { $splat.errorAction = 'stop' }
    LoadConfig 'stuff.txt' @splat

    DoMoreWork


}
```