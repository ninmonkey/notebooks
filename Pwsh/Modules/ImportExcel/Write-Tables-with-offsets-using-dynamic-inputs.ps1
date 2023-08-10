$PSDefaultParameterValues['Export-Excel:Verbose'] = $true
$PSDefaultParameterValues['Set-Format:Verbose'] = $true
$PSDefaultParameterValues['Close-ExcelPackage:Verbose'] = $true
# see the base article: <https://dfinke.github.io/powershell/2019/08/29/Learn-to-Automate-Excel-like-a-Pro-with-PowerShell.html>
function setAllVerbose {
    # optional super verbose
    param( [switch]$EnableVerbose, [switch]$DisableAll )
    Gcm -m IMportExcel | %{
        $Key = $_.Name | Join-String -f "{0}:Verbose"
        if($EnableVerbose) {
            $PSDefaultParameterValues[ $Key ] = $EnableVerbose
        }
        if($DisableAll) {
            $PSDefaultParameterValues.Remove('ColumnChart:verbose')
        }
    }
}
function New-SafeFileTime {
    # if you want filenames based on time, else, don't set a path and ImportExcel uses a temp file
    (Get-Date).ToString('u') -replace '\s+', '_' -replace ':', '-'
}

# ExcelAnt\Close-ExcelWindow
$xlFile = New-SafeFileTime | Join-String -f 'multi-table-export-test-{0}.xlsx'

$services ??= Get-Service -ea 'ignore'
$processes ??= Get-Process -ea 'ignore'

$export_shared = @{
    AutoSize   = $true
    PassThru   = $true
    TableStyle = 'Light2'
}

$Pkg = $Services
    | Select -First 7
    | Export-Excel @export_shared -TableName 'services' -StartRow 2

[OfficeOpenXml.ExcelWorksheet]$sheet1 =
    $Pkg.Workbook.Worksheets['Sheet1']

[OfficeOpenXml.Table.ExcelTable]$table1 =
    $sheet1.Tables['services']

if(-not $table1){
    throw "Something failed, table on sheet1 not found"
}

$header_shared = @{
    AutoSize  = $true
    Bold      = $true
    FontSize  = 16
    WorkSheet = $sheet1
}

function titleTemplate {
    param( [object]$InputObject )
    '{0} items of [{1}]' -f @(
        $InputObject.Count
        @( $InputObject )[0].GetType().Name
    )

}

Set-Format -Range 'A1' @header_shared -value (titleTemplate $services)

$nextRowAddr =
    $table1.Address.End.Address
$nextRowNumber =
    $table1.Address.End.Row + 2
$nextRowStr =
    'A{0}' -f $nextRowNumber

$title = '{0} items of {1}' -f @(
    $processes.Count
    $processes.GetType().Name
)
Set-Format -Range $nextRowStr @header_shared -value (titleTemplate $processes)

$nextRowNumber++
$Pkg = $processes
    | Select -First 4
    | Export-Excel @export_shared -ExcelPackage $Pkg -StartRow $nextRowNumber -TableName 'process'

# $pkg.Workbook.Worksheets['Sheet1'].Tables['process']



$xlFIle | Join-String -f "wrote: <{0}>"
Close-ExcelPackage -ExcelPackage $Pkg -Show #-SaveAs $xlFile
# Close-ExcelPackage -ExcelPackage $Pkg -SaveAs $xlfile -Show
