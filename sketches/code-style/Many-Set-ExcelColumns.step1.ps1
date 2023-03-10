$excel = Open-ExcelPackage -Path $FileName

$rmcdata = $excel.workbook.Worksheets['RMC Data']
$accdata = $excel.Workbook.Worksheets['ACC Data']
$mcdata = $excel.Workbook.Worksheets['MC Data']
Set-ExcelColumn -Worksheet $rmcdata -Column 1 -NumberFormat 'Short Date'
Set-ExcelColumn -Worksheet $rmcData -Column 4 -NumberFormat 'Percentage'

Set-ExcelColumn -Worksheet $accData -Column 1 -NumberFormat 'Short Date'
Set-ExcelColumn -Worksheet $accData -Column 4 -NumberFormat 'Percentage'
Set-ExcelColumn -Worksheet $accData -Column 5 -NumberFormat 'Percentage'

Set-ExcelColumn -Worksheet $mcData -Column 1 -NumberFormat 'Short Date'
Set-ExcelColumn -Worksheet $mcData -Column 3 -NumberFormat '###0.00'
Set-ExcelColumn -Worksheet $mcData -Column 4 -NumberFormat '###0.00'


$ptrmc = New-PivotTableDefinition -PivotTableName 'RMC Totals' -PivotData @{"Total"="average"} -PivotRows 'TMS', 'SQD' -PivotColumns 'Date' -SourceWorksheet 'RMC Data' -PivotNumberFormat '###0.00' 
$ptacc1 = New-PivotTableDefinition -PivotTableName 'ACC Met Percentage' -PivotData @{"MetTrainingPct"="average"} -PivotRows 'TMS','SQD' -PivotColumns 'Date' -SourceWorksheet 'ACC Data' -PivotNumberFormat 'Percentage'
$ptacc2 = New-PivotTableDefinition -PivotTableName 'ACC Leader Percentage' -PivotData @{"LeaderTrainingPct"="average"} -PivotRows 'TMS','SQD' -PivotColumns 'Date' -SourceWorksheet 'ACC Data' -PivotNumberFormat 'Percentage'
$ptmc1 = New-PivotTableDefinition -PivotTableName 'MC Entitlement' -PivotData @{"Entitlement"="sum"} -PivotRows 'TMS','SQD' -PivotColumns 'Date' -SourceWorksheet 'MC Data' 
$ptmc2 = New-PivotTableDefinition -PivotTableName 'MC Actuals' -PivotData @{"Actuals" = "sum"} -PivotRows 'TMS', 'SQD' -PivotColumns 'Date'-SourceWorksheet 'MC Data' 
$ptmc3 = New-PivotTableDefinition -PivotTableName 'MC Category' -PivotData @{"Actuals" = "sum"} -PivotRows 'TMS', 'SQD' -PivotColumns 'Description'-SourceWorksheet 'MC Data' # ...
