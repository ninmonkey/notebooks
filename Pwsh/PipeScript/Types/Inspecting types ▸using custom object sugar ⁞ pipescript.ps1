#Requires -Modules @{ ModuleName = 'pipescript'; ModuleVersion = '0.1.6' }
Import-Module PipeScript

$query = Get-Variable
$few = $query | select -first 3
$one = $query[0]

function MiniType { 
    # note: currently outside loops, ie: transpiles every iteration
    $Input | .> { .Type = ($_.GetType() | ShortType) .Value = $_ .FullType = ($_.GetType()) `
       .ValueAbbr = (shortStr -InputText $_ -Options @{ AlwaysQuoteInner = $true}  )
    }
}

@(gi . ; get-date ) | MiniType


# todo
# [ ] - item in one line, then merge hashtables
# [ ] - item across line with one more parens
# [ ] - transpile dynamically calling EZFormat
function MiniType { 
    # note: currently outside loops, ie: transpiles every iteration
    $Input | .> {
         $item = $_
        .Type = ($_.GetType() | ShortType) .Value = $_ .FullType = ($_.GetType()) `
       .ValueAbbr = (shortStr -InputText ($item.ToString() ?? ':(')  )
    }
}

@(gi . ; get-date ) | select *name*, *path* | MiniType


import-module pipescript *>$null
function MiniType { 
    $Input | .> {
        .Type     = ($_.GetType() | ShortType) `
        .Value    = $_ `
        .FullType = ($_.GetType()) }
}

@(gi . ; get-date ) | MiniType

function transposeObject { 
    param(
        [Parameter(Mandatory, ValueFromPipeline)]
        $InputObject
    )
    process { 
        $InputObject.PSobject.Properties | ForEach-Object { 
            $props = [ordered]@{}            
            $props['Key'] = $_.Name
            $props['Value'] = $_.Value
            [pscustomobject]$props
        }
    }
}
ls . | select -First 3 | transposeObject

hr

return

hr


# note, this is pretty slow, it was transpiling 1 line at a time.
& { # first example: 
    $one | ForEach-Object { 
        $out = $_
        #$out = Get-Variable | s -First 1
        .> {
            $_ = $out
            $_.gettype()
            .a = $_.Value .t = ($_.GetType().Name)
        } 
    }
}
hr 

& { # better 
        .> {
     $one | ForEach-Object { 
        $out = $_
        #$out = Get-Variable | s -First 1
            $_ = $out
            $_.gettype()
            .a = $_.Value .t = ($_.GetType().Name)
        }
    }
}