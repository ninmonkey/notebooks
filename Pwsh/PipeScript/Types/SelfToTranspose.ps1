function help.office.namespaces.sketch { 
     <#
     .SYNOPSIS
        to remember what namespaces are used 
     .notes
        Some of the office/xml namespaces were already loaded,
        but a bunch had not. Meaning if you don't try to import,
        you can get less, but non-zero results
    .link
        https://learn.microsoft.com/en-us/office/open-xml/word-processing
    .link
        https://learn.microsoft.com/en-us/dotnet/api/documentformat.openxml.wordprocessing.text?redirectedfrom=MSDN&view=openxml-2.8.1
    .link
        https://learn.microsoft.com/en-us/dotnet/api/documentformat.openxml.wordprocessing.paragraph?redirectedfrom=MSDN&view=openxml-2.8.1
    .link
        https://github.com/dfinke/ImportExcel
    .LINK
        https://github.com/EvotecIT/PSWriteOffice               

     #>
     [CmdletBinding()]
     param(
        [Parameter()]
        [ArgumentCompletions(
            '*.OfficeOpenXml.*',
            'OfficeOpenXml',
            'OfficeOpenXml.*',
            'DocumentFormat.OpenXml'
        )]
        [string[]]$Namespaces = @('*.OfficeOpenXml.*', 'OfficeOpenXml.*'),

        [switch]$NeverImport,
        [switch]$PassThru
     )
     if( -not $NeverImport ) { 
        # import-module always prints verbose that it's loading, even if it's loaded        
        if( -not (get-module 'ImportExcel' -ea ignore)) {
            Import-Module -Scope Global 'ImportExcel'
        }
        if( -not (get-module 'PSWriteOffice' -ea ignore)) {
            Import-Module -Scope Global 'PSWriteOffice'
        }
     }
    $query = @(
        foreach($space in $Namespaces) { 
            $wildFullName = '*{0}*' -f @( $space )
            ClassExplorer\find-type -FullName $wildFullName #| sort FullName -Unique
            ClassExplorer\find-type -Namespace $space #| sort FullName -Unique
            
        }) | sort -Unique FullName

        $query | Group namespace -NoElement
        | sort Count -Descending
        | ft -AutoSize  | out-string # required. else fails when using 'oss'
        | join-string
        | Label 'Namespace Count'
        | write-debug


        if($PassThru) { return $query }    
        return $query #maybe never return text?

        # return $query.Name #maybe never return text?

  }
[ValidateNotNull()]$script:____countQueryState = @{}
function crazy.countPerQueryGrouping {
    <#
    .SYNOPSIS
        testing uniques per query. why? I felt like It?
    #>
    param(
        [Alias('Query', 'Pattern')]
        [string[]]$InputObject,

        [hashtable]$Optionos = @{}
    )
    $state = $script:____countQueryState
    class queryResult {
        [string]$QueryString
        [string]$Parameter
        [string]$Description
        [int]$DistinctCount
    }

    $Config = mergeHashtable -OtherHash $Options -BaseHash @{
        TryWildcards = $true
    }

    if($Config.TryWildcards) { 
        $QueryList = $InputObject | %{
            
            '{0}'   -f @( $_ )
            '{0}*'  -f @( $_ )
            '{0}'   -f @( $_ )
            '*{0}*' -f @( $_ )
        }
    } else {
        $QueryList = $InputObject
    }

    $final = foreach($QueryString in $QueryList) { 
        $query = Find-Type -Namespace $QueryString
        | sort -Unique FullName
        [queryResult]@{
            QueryStr = $QueryString
            Parameter = 'Namespace'
            DistinctCount = ($Query | Sort -unique FullName).count
            Count = $Query.Count
            Description = 'blank'
        }
        # $query
        
    }

    
}
ps | select Name
# $queryGrouping = @{}
# foreach($query in $queryString) { 

# }
# $query.
help.office.namespaces -Namespaces *.OfficeOpenXml.*,OfficeOpenXml
$namespaces = '*.OfficeOpenXml.*', 'OfficeOpenXml'
$res = help.office.namespaces -Namespaces $namespaces -debug

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
            # $props[ $_.Value ] = $_.Name
            [pscustomobject]$props
        }
    }
}
hr 
ls . | select -First 3 #| transposeObject
# $zdsfdsf = "sadfd"