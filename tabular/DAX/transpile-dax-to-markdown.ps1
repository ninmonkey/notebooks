Push-Location $PSScriptRoot
remove-variable 'here' -ea ignore 
$Paths = @{ 
    Here   = ($Here = gi .)
    Source = Join-Path $here '.output\generated-md-from-dax.template.yaml'
    Export = Join-Path $Here '.output\generated-md-from-dax.md'
}
$GlobalPassThru = @{ PassThru = $false } 
# 'C:\Users\cppmo_000\SkyDrive\Documents\2022\My_Github\notebooks\tabular\DAX\'
$Paths | Ft -auto 

$docHeader, $docData = ConvertFrom-Yaml -AllDocuments (Get-Content -raw $Paths.Source ) -Ordered
h1 'header'
$docHeader
h1 'content' 
$docData.tests

function autoStr {
    <#
    .synopsis
        Combines Auto-quote with optionally quoted text, without full here-string mode
    #>
    param(
        # Which kind of string quoting?
        [Parameter(Position = 0)] # maybe is the right choice?
        [ValidateSet('Single', 'Double', 'Tick', 'None')]
        [string]$Kind = 'Single',

        [Parameter(Mandatory, ValueFromRemainingArguments)]
        [string]$AutoStr        
    )
    $joinSplat = @{}
    switch ($Kind) { 
        'Single' { $joinSplat.SingleQuote = $true }
        'Double' { $joinSplat.DoubleQuote = $True }
        'None' { }
        'Tick' { $joinSplat.OutputPrefix = '`' ; $joinSplat.OutputSuffix = '`' }
        default { throw "UnhandledAutoStrKind: $Kind !" }

    }
    $AutoStr | Join-String @joinSplat
}


function md.Write.tableRow {
    param(
        # Escape '|' pipe char, because it's part of the query -- not a column
        [switch]$NeverEscapeBars
    )
    # Write column-padded list of n-count number of items
    $Input | Join-String -op '| ' -os ' |' -sep ' | ' {
        if ($NeverEscapeBars) { return $_ }
        $_ -replace ([regex]::Escape( '|')), '\|'
    }
}

function md.Write.Table { 
    # Full object as a table
    param(
        [Parameter(Mandatory)]
        [object[]]$InputItems,
        [hashtable]$Options = @{ SortColumns = $True }
    )
    $Config = $Options

    $first = $InputItems[0]
    $colNames = if ($Config.SortColumns) { 
        $first.Keys.clone() | Sort-Object
    }
    else { $first.Keys.clone() }

    $colCount = $colNames.count

    "`n"
    $colNames
    | md.Write.TableRow
    
    '-' * $colCount | % ToCharArray
    | md.write.tableRow

    $InputItems | % { 
        $row = $_ 
        $toWrite = @(foreach ($name in $colNames) {
                $row[ $name ]
                $row[ $Name ] | write-verbose
            })

        # future: auto full codefence side by side, using <table> and inline code blocks.
        # currently: 
        #    write: warning: constraint should be based on column name not order
        #       because order is not ensured 
        #    backtick escape column 0
        $toWrite[0] = autoStr -Kind Tick $toWrite[0]
        #    truthy symbols: column 1
        # $toWrite[1] = $toWrite[1] -replace 'True', '✅ True' -replace 'False', '😟False'
        $toWrite[1] = $toWrite[1] -replace 'True', '✅ True' -replace 'False', '⛔False'
        $toWrite | md.write.tableRow
    }

    # "`n"
    # $docData[0].Keys
}

h1 'actual start'
Clear-Content -Path $Paths.Export

$docData.GetEnumerator() | % {
    @(
        "`n"
        '## {0}' -f  @( $_.Key )
        # "`n"
    ) -join ''
    | Add-Content -Path $Paths.Export @globalPassThru

    md.Write.Table -InputItems  $_.Value | Join-String -sep "`n"
    | Add-Content -Path $Paths.Export @globalPassThru
}
#  | Join-string -sep ( hr )

    
'source: "{0}"' -f @( $Paths.Source )
'wrote: "{0}"' -f @( $Paths.Export )



return





if ($false -and 'another') {
    $docData.GetEnumerator() | % { 
        "table: {0}" -f @( $_.Key )
        $curTableGroup = $_.Value 
        $Target = $curTableGroup
        md.write.tableRow -InputItems $Target   
    }
    | JOin-String -sep (hr 2)
}

# foreach ($tableGroup in $docData.Keys.clone() ) {
# "`n" | Add-Content -Path
# $Target = $tableGroup    
# $Target = $docData[$tableGroup]
# md.Write.Table -InputItems $Target
# | Add-Content -PassThru -Path $Paths.Export
# }

    

if ($false -and 'single pass') {
    $Target = $docData.Tests
    md.Write.Table -InputItems $Target
    | Add-Content -PassThru -Path $Paths.Export
}
return

if ($false) { 
    foreach ($tableGroup in $docData.Keys.clone() ) {
        # "`n" | Add-Content -Path
        $Target = $tableGroup    
        $Target = $docData[$tableGroup]
        md.Write.Table -InputItems $Target
        | Add-Content -PassThru -Path $Paths.Export
    }
}

# '| {0} | {1} | ' -f @(
#     $_ | Join-String -op '`' -os '`'
#     'result'
# )











return 

$Cols = @'
BLANK() = BLANK(),
BLANK() = 0,
BLANK() = "",
'@ -split '\r?\n'
$markObj = $Cols
| % { 
    '| {0} | {1} | ' -f @(
        $_ | Join-String -op '`' -os '`'
        'result'
    )
}

$markObj | set-clipboard -PassThru

hr
$Results = @(
    @{
        Ex     = autoStr -Kind Tick 'BLANK() = BLANK()'
        Result = 'sad'
    }

)

$Results | ft

hr

$yamlResults = @'
'@

# $PathYaml = gi (Join-String $PSScriptRoot './Dax Examples.Template.psx.yaml')
$PathYaml = gi './../Dax Examples.Template.psx.yaml'
$PathYaml

$docHeader, $docData = ConvertFrom-Yaml -AllDocuments (Get-Content -raw $PathYaml )

$docHeader | ft
Hr
$docData | ft 