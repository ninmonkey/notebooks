
$CopyPairs = @(
    @{
        Source = 'C:\Users\x.txt'
        Dest   = 'C:\Users\a\x.txt'
    }
    @{
        Source = 'C:\Users\y.txt'
        Dest   = 'C:\Users\b\y.txt'

    }
)
function QuoteIt {
    <#
    .SYNOPSIS
        Double quote filepaths, optionally require it to exist
    #>
    [OutputType('System.String')]
    param(
        [Parameter(Mandatory)]
        [string]$Path,
        # error if path does not exist
        [switch]$MustExist
    )

    $item = $Path
    if ($MustExist) {
        $item = Get-Item -ea 'stop' $Path
    }
    else {
        $Item = $Path
    }

    '"{0}"' -f @(
        $Path
    )
}

function CopyPair {
    [CmdletBinding()]
    param(
        # A List of hashtables of Source and Dest
        [Parameter(mandatory)]
        [object[]]$PairList,
        [switch]$WhatIf # not actually a full true WhatIf yet
    )

    foreach ($pair in $CopyPairs) {
        [object[]]$RoboArgs = @(
            QuoteIt -MustExist $Pair.Source
            QuoteIt $Pair.Dest

            if ($WhatIf) {
                '/L'
            }
        )
        $RoboArgs -join ', ' | write-verbose
        & 'robocopy' @RoboArgs

    }
}

CopyPair -PairList $CopyPairs -WhatIf



$rbArgs = @(
    'C:\Users\a\x.txt' | Get-Item -ea stop | Join-String -Double
    'C:\Users\b\y.txt' | Join-String -Double
    '/L'
)
& robocopy @rbArgs

or this for PS 5
$rbArgs = @(
    '"{0}"' -f @( 'C:\Users\a\x.txt' | Get-Item -ea stop )
    '"{0}"' -f @( 'C:\Users\b\y.txt' )
    '/L'
)
& robocopy @rbArgs