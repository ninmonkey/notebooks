<# 
   first use 'ConvertTo-SplatExpression' under code refactor or ctrl+shift+s ( I forget if I added that bind )
   the Code formatter auto aligns columns for you
#>
$excel = Open-ExcelPackage -Path $FileName

$rmcdata = $excel.workbook.Worksheets['RMC Data']
$accdata = $excel.Workbook.Worksheets['ACC Data']
$mcdata = $excel.Workbook.Worksheets['MC Data']

$setExcelColumnSplat = @{
    Worksheet    = $rmcdata
    Column       = 1
    NumberFormat = 'Short Date'
}
Set-ExcelColumn @setExcelColumnSplat

$setExcelColumnSplat = @{
    Worksheet    = $rmcData
    Column       = 4
    NumberFormat = 'Percentage'
}
Set-ExcelColumn @setExcelColumnSplat

$curSheet = $accData
$setExcelColumnSplat = @{
    Worksheet    = $curSheet
    Column       = 1
    NumberFormat = 'Short Date'
}
Set-ExcelColumn @setExcelColumnSplat

$setExcelColumnSplat = @{
    Worksheet    = $curSheet
    Column       = 4
    NumberFormat = 'Percentage'
}
Set-ExcelColumn @setExcelColumnSplat

$setExcelColumnSplat = @{
    Worksheet    = $curSheet
    Column       = 5
    NumberFormat = 'Percentage'
}
Set-ExcelColumn @setExcelColumnSplat

$curSheet = $mcData
$setExcelColumnSplat = @{
    Worksheet    = $curSheet
    Column       = 1
    NumberFormat = 'Short Date'
}
Set-ExcelColumn @setExcelColumnSplat

$setExcelColumnSplat = @{
    Worksheet    = $curSheet
    Column       = 3
    NumberFormat = '###0.00'
}
Set-ExcelColumn @setExcelColumnSplat

$setExcelColumnSplat = @{
    Worksheet    = $curSheet
    Column       = 4
    NumberFormat = '###0.00'
}
Set-ExcelColumn @setExcelColumnSplat

$newPivotTableDefinitionSplat = @{
    PivotTableName    = 'RMC Totals'
    PivotData         = @{'Total' = 'average' }
    PivotRows         = 'TMS', 'SQD'
    PivotColumns      = 'Date'
    SourceWorksheet   = 'RMC Data'
    PivotNumberFormat = '###0.00'
}
$ptrmc = New-PivotTableDefinition @newPivotTableDefinitionSplat

$newPivotTableDefinitionSplat = @{
    PivotTableName    = 'ACC Met Percentage'
    PivotData         = @{'MetTrainingPct' = 'average' }
    PivotRows         = 'TMS', 'SQD'
    PivotColumns      = 'Date'
    SourceWorksheet   = 'ACC Data'
    PivotNumberFormat = 'Percentage'
}
$ptacc1 = New-PivotTableDefinition @newPivotTableDefinitionSplat

$newPivotTableDefinitionSplat = @{
    PivotTableName    = 'ACC Leader Percentage'
    PivotData         = @{'LeaderTrainingPct' = 'average' }
    PivotRows         = 'TMS', 'SQD'
    PivotColumns      = 'Date'
    SourceWorksheet   = 'ACC Data'
    PivotNumberFormat = 'Percentage'
}
$ptacc2 = New-PivotTableDefinition @newPivotTableDefinitionSplat

$newPivotTableDefinitionSplat = @{
    PivotTableName  = 'MC Entitlement'
    PivotData       = @{'Entitlement' = 'sum' }
    PivotRows       = 'TMS', 'SQD'
    PivotColumns    = 'Date'
    SourceWorksheet = 'MC Data'
}
$ptmc1 = New-PivotTableDefinition @newPivotTableDefinitionSplat

$newPivotTableDefinitionSplat = @{
    PivotTableName  = 'MC Actuals'
    PivotData       = @{'Actuals' = 'sum' }
    PivotRows       = 'TMS', 'SQD'
    PivotColumns    = 'Date'
    SourceWorksheet = 'MC Data'
}
$ptmc2 = New-PivotTableDefinition @newPivotTableDefinitionSplat

# $newPivotTableDefinitionSplat = @{
#     PivotTableName  = 'MC Category'
#     PivotData       = @{'Actuals' = 'sum' }
#     PivotRows       = 'TMS', 'SQD'
#     PivotColumns    = 'Description'
#     SourceWorksheet = 'MC Data'
#     Pivot           = -Pivot
# }
# $ptmc3 = New-PivotTableDefinition @newPivotTableDefinitionSplat
# ... stuff
Close-ExcelPackage -ExcelPackage $Excel #-show -autosize
