﻿#Requires -Modules ImportExcel
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
# original
    # Set-ExcelRange -Worksheet $Sheet -Range 'C2:C4' -NumberFormat 'Currency' -Verbose
    # Set-ExcelRange -Worksheet $Sheet -Range 'B2:B4' -NumberFormat 'Short Date' -Verbose

$workSheetName = 'Employees'
$tableName = 'Employees_table'

function GetColNames {
    param(
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [OfficeOpenXml.ExcelPackage] $Excel,

        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [ArgumentCompletions('Employees_table')]
        [string] $TableName,

        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [ArgumentCompletions('Employees')]
        [string] $WorkSheetName
    )


    return @( $excel.$WorkSheetName.Tables[ $tableName ].Columns.Name )
}
function BuildMappingTable {
    <#
    .synopsis
        Maps column names like 'Currency' to the (column,rows) range, for example: 'C2:C4'
    #>
    param(
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [OfficeOpenXml.ExcelPackage] $Excel,

        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [ArgumentCompletions('Employees_table')]
        [string] $TableName,

        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [ArgumentCompletions('Employees')]
        [string] $WorkSheetName
    )
    $chars = 'A'..'Z' # future: support more column names
    $Excel.$WorkSheetName.Tables[ $TableName ].Columns | %{
        $colChar = $chars[ $_.Position ]

        $renderAddr = @( # ex: C2:C4
            $colChar
            $excel.$WorkSheetName.Tables[ $tableName ].Address.Start.Row
            ':'
            $colChar
            $excel.$WorkSheetName.Tables[ $tableName ].Address.End.Row
        ) -join ''

        [pscustomobject]@{
            ColName  = $_.name
            Char     = $chars[ $_.Position ]
            Address  = $renderAddr
            Id       = $_.Id
            Position = $_.Position
        }
    }
}

function ColNameToAddr {
    param(
        [object]$Map,
        [string] $ColName
    )
    $map.Where({ $_.ColName -eq $ColName }).Address
}

$map = BuildMappingTable -Excel $excel -TableName 'Employees_table' -WorkSheetName Employees
$map | ft -auto
GetColNames -Excel $Excel -TableName 'Employees_table' -WorkSheetName Employees | Join-String -sep ', '


$rangeSplat = @{
    Worksheet    = $excel.Employees
    Range        = ColNameToAddr $map 'when'
    NumberFormat = 'Short Date'
}
Set-ExcelRange @rangeSplat
$rangeSplat = @{
    Worksheet    = $excel.Employees
    Range        = ColNameToAddr $map 'Currency'
    NumberFormat = 'Currency'
}
Set-ExcelRange @rangeSplat

Close-ExcelPackage $excel -Show
