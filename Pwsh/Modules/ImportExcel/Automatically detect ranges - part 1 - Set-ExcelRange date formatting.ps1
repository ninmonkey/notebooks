#Requires -Modules ImportExcel
<#
.description
- Export a table with dates and numbers
- explicitly setting format strings per-column
- ranges are automatically detected if you use named tables

- It was based on this: <https://github.com/dfinke/ImportExcel/blob/fa907da4a459d9da2d080d60f563333828313ef4/Examples/CustomNumbers/ShortenNumbers.ps1>
#>


$Records = @'
[ { 'name': 'bob', 'when': '2024-07-23 20:23:48Z', 'currency': '1234.3566' },
  { 'name': 'jen', 'when': '2023-04-05 11:23:32Z', 'currency': '93.134545' } ]
'@ | ConvertFrom-Json # -depth 10


$Records | %{
    # in general you want to use [datetime]::ParseExact
    $_.when = [datetime] $_.when
}

$exportSplat = @{
    Title         = 'Column formatting example'
    TableName     = 'Employees_table'
    WorksheetName = 'Employees'
    AutoSize      = $true
    PassThru      = $true
}
[OfficeOpenXml.ExcelPackage] $excel = $records | Export-Excel @exportSplat

$Sheet = $excel.Employees
Set-ExcelRange -Worksheet $Sheet -Range 'C2:C4' -NumberFormat 'Currency' -Verbose
Set-ExcelRange -Worksheet $Sheet -Range 'B2:B4' -NumberFormat 'Short Date' -Verbose
Close-ExcelPackage $excel -Show
