function TestOption {
    param(
        [ValidateNotNullOrWhiteSpace()]
        [Parameter()]
        [string[]]$FilterVersion,

        [Parameter(Mandatory)]
        $Name
    )

    $PSBoundParameters | Json | Write-Host -bg orange -fg black
}

TestOption -f 'a', 'b' -n 'bob' # is good
TestOption -n 'bob'             # is good.
TestOption -f '' -n 'bob'       # throws
TestOption -f $Null -n 'bob'    # throws
TestOption -f @() -n 'bob'      # throws
TestOption -f @('') -n 'bob'    # throws
TestOption -f @('a') -n 'bob'   # is good
