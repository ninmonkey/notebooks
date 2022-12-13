$NbConf = @{
    TempRoot = 'temp:'
    # HereRoot = Get-Item '.'
}
$NbConf.TempRoot = Get-Item 'G:\temp\nbout\export'
$NBConf.TempRoot ??= 'temp:'
# Set-Location $NbConf.TempRoot

# $NbConf | Format-Table -auto

function countPattern.v1 {
    <#
    .EXAMPLE
        how many '\r\n' matches?
        countPattern $file '\r\n' -PassThru
            <stats>

        how many '\r\n' matches?
        countPattern $file '\r\n' -PassThru
            3
    #>
    [Alias('countPattern')]
    param(
        # raw string to search
        [Parameter(Mandatory, ValueFromPipeline)]
        [ValidateNotNull()]
        [string]$Contents,

        # Which pattern
        [ArgumentCompletions(
            "'\r?\n'",
            "'\n'",
            "'\b\w+\b'"
        )]
        [string]$Regex,

        # return object including the regex used
        [switch]$PassThru
    )
    process {
        $found = [Regex]::Matches($Contents, $Regex)
        if (-not $PassThru) {
            return $Found.count
        }
        $obj = [pscustomobject]@{
            Regex   = $Regex
            Count   = $Found.Count
            Matches = $Found
        }
        $obj
    }
}

$EnvNL = [System.Environment]::NewLine
$EnvNLNormalized = [System.Environment]::NewLine -replace '\r?\n', "`n"
$EnvNL_Regex = [Regex]::Escape([System.Environment]::NewLine)

function getAllExport {
    # param( [string]$BasePath = $NBConf.TempRoot )
    Get-ChildItem $NBConf.TempRoot *.txt
}

function getPath {
    param( [string]$Label, $Extension = 'txt' )
    Join-Path $NbConf.TempRoot "$Label.$Extension"
}


function summarizeFile {
    # top level summary stats
    <#
    .SYNOPSIS
        future:
            allow piping fileintems into $filepath param
    #>
    param(
        [Parameter(ValueFromPipeline, Mandatory, ValueFromPipelineByPropertyName)]
        [ValidateNotNull()]
        [string]$FilePath,

        [switch]$AsHashtable
    )
    $File = Get-Item $FilePath -ea stop
    $Contents = Get-Content -Raw $FilePath
    $countSplat = @{
        Contents = $Contents
    }

    $Meta = [ordered]@{
        PSTypeName     = 'fileSummary.nb_utils'
        Name           = $File.Name
        Size_kb        = '{0:n3}' -f @( $File.Length / 1kb )
        Render         = $Contents | Format-ControlChar
        Num_NL         = countPattern @countSplat -Regex '\n'
        Num_CRNL       = countPattern @countSplat -Regex '\r\n'
        'Num_Cr?Nl'    = countPattern @countSplat -Regex '\r?\n'
        Num_EnvNL      = countPattern @countSplat -Regex ( [System.Environment]::NewLine )
        Env_NL         = $EnvNL | Format-ControlChar
        'Env_NL.Norm'  = $EnvNLNormalized | Format-ControlChar
        'Env_NL.Regex' = $EnvNL_Regex

    }
    if ($AsHashtable) { return $meta }
    [pscustomobject]$meta

}
function inspectAll {
    param(
        # [String]$BasePath = '.'
    )
    $id = 0
    [object[]]$results = getAllExport | ForEach-Object {
        summarizeFile $_
        | Add-Member -PassThru -Force -ea 'ignore' -NotePropertyMembers @{
            Id = $Id++
        }
    }

    $PathExcel = getPath 'whitespace_summary' -ext 'xlsx'
    Remove-Item $PathExcel
    $Pkg = Open-ExcelPackage $PathExcel

    $Results | Export-Excel -ExcelPackage $Pkg -TableName 'fileMetricSummary' -WorksheetName 'Summary'

    # Close-ExcelPackage -ExcelPackage $Pkg -ea 'ignore' # export-excel must close it
    "wrote: '$PathExcel'" | Write-Host -BackgroundColor 'red' -fore 'white'

}

# $file = Get-Item 'G:\temp\nbout\export\explicit_jstr_CRNL.txt' -ea stop
# summarizeFile $file

inspectAll
'utils.metrics: Loaded' | Write-Host