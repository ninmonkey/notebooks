function WhatNotToDo.TestShadow {
    [CmdletBinding()]
    param(
        [Parameter(ValueFromPipeline)]
        [string]$ShadowMe

    )
    process {
         $ShadowMe # param
         $ShadowMe = '🦇'
         $ShadowMe # shadowed local
         $PSBoundParameters['ShadowMe'] # reference param again

    }
    end {

    }
}

'🐱' | WhatNotToDo.TestShadow | Join-String


