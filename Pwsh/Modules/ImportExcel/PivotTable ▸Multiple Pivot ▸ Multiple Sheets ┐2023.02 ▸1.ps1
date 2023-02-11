# complete vs code
impo ninmonkey.console # only part used is 'New-SafeFileTime'
throw "write-warning '.... not finished, need to finalize args for pviot tables'"
@'
refs:
- <file:///E:\PSModulePath_2022\ImportExcel\7.6.0\Public\Add-PivotTable.ps1>

$Pvt    = [OfficeOpenXml.Table.PivotTable.ExcelPivotTable]
$Pkg    = [OfficeOpenXml.ExcelPackage]
$Pkg.Workbook   = [OfficeOpenXml.ExcelWorkbook]
$Pkg.Workbook.Worksheets = [OfficeOpenXml.ExcelWorksheet[]]
$Pkg.Workbook.Worksheets[1].Tables = [OfficeOpenXml.Table.ExcelTable[]]


'@

# enable or disable super verbose commands.
function Enable-ModuleSuperVerbose {
    [CmdletBinding()]
    param(
        [ArgumentCompletions('ImportExcel')]
        [Parameter(Mandatory, Position = 0)][string]$ModuleName,

        [switch]$Disable
    )
    Get-Command -m ImportExcel | ForEach-Object {
        $renderKey = "$ModuleName\{0}:Verbose'" -f @( $_.Name )
        if (-not $Disable) {
            'added: {0}' -f @($renderKey) | Write-Verbose
            $PSDefaultParameterValues[ $renderKey ] = $true
        }
        else {
            'removed: {0}' -f @($renderKey) | Write-Verbose
            $PSDefaultParameterValues.Remove( $renderKey )
        }
    }
}

$App = @{
    Export            = @{
        Root         = mkdir -Force -Path 'G:\temp\xl\.output' -ea Ignore
        Template     = 'multiplePivot-{0}.xlsx'
        FullTemplate = ''
    }
    UsingSuperVerbose = $false
}


$PropList = @{
    ServicesInclude = @(
        'Status', '*Name*', '*Path*', '*Type*'
    )
    ProcessInclude  = @(
        'Name', '*64*', '*path*'
    )
    FilesExclude    = @(
        'PSPath', 'PSParentPath', 'PSChildName', 'PSDrive', 'PSProvider'
    )

}

# Enable-ModuleSuperVerbose 'ImportExcel' -Verbose -Disable:(-not $App.UsingSuperVerbose)

$eaIgnore = @{
    ErrorAction = 'ignore'
}


$App.Export.FullTemplate = Join-Path $App.Export.Root $App.Export.Template
$Dest = New-SafeFileTime -TemplateString $App.Export.FullTemplate -verbose
'write: <{0}>' -f @( $Dest )
Remove-Item @eaIgnore $Dest

$Pkg = Open-ExcelPackage -Path $Dest -Create

$exportExcelSplat = @{
    Append        = $false # Append If specified data will be added to the end of an existing sheet, using the same column
    AutoSize      = $true
    PassThru      = $true
    TableName     = 'processList'
    TableStyle    = 'Light1'
    WorksheetName = 'processList'
    # Verbose       = $True

}

# Displaying multiple invokes can append existing data
$pkg = Get-Process
| Get-Random -Count 3
| Select-Object @eaIgnore $PropList.ProcessToInclude
| Export-Excel @exportExcelSplat -ExcelPackage $Pkg
$pkg = Get-Process
| Get-Random -Count 3
| Select-Object @eaIgnore $PropList.ProcessToInclude
| Export-Excel @exportExcelSplat -ExcelPackage $Pkg
$pkg = Get-Process
| Get-Random -Count 80
| Select-Object @eaIgnore $PropList.ProcessToInclude
| Export-Excel @exportExcelSplat -ExcelPackage $Pkg

# $pivot = Add-PivotTable @splat

$exportExcelSplat = @{
    ExcelPackage  = $Pkg
    PassThru      = $true
    WorksheetName = 'fileList'
    TableName     = 'fileList'
    AutoSize      = $true
    TableStyle    = 'Light2'
    # PivotTableName = 'filePivot'
    Append        = $true
    # Verbose       = $True
}

$pkg = Get-ChildItem ~
| Select-Object -ExcludeProperty $PropList.FilesExclude
| Select-Object -First 10
| Export-Excel @exportExcelSplat


$exportExcelSplat = @{
    WorksheetName      = 'Services'
    PassThru           = $true
    AutoSize           = $true
    DisplayPropertySet = $true
    TableName          = 'ServiceTable'
    Title              = "Services on $Env:COMPUTERNAME"
    # Verbose            = $True
}

$addPivot_processes = @{
    # note: worksheets are 1-base-index, tables are 0-based-index
    PivotTableName  = 'ServiceSummary'
    SourceRange     = $Pkg.Workbook.Worksheets[1].Tables[0].Address
    PivotRows       = 'Status'
    PivotData       = 'Name'
    NoTotalsInPivot = $true
    Activate        = $true
    # Verbose         = $True
    ea              = 'break'
}
$addPivot_services = @{
    # note: worksheets are 1-base-index, tables are 0-based-index
    PivotTableName  = 'ProcessSummary'
    SourceRange     = $Pkg.Workbook.Worksheets[1].Tables[0].Address
    PivotRows       = 'Status'
    PivotData       = 'Name'
    NoTotalsInPivot = $true
    Activate        = $true
    # Verbose         = $True
    ea              = 'break'
}

$pkg = Get-Service @eaIgnore
| Select-Object @eaIgnore -p $PropList.ServicesInclude
| Select-Object -First 10
| Export-Excel @exportExcelSplat -ExcelPackage $Pkg


$Pvt = Add-PivotTable @addPivot_processes -PassThru -ExcelPackage $Pkg
$Pvt = Add-PivotTable @addPivot_services -PassThru -ExcelPackage $Pkg

Close-ExcelPackage $pkg -Show # -SaveAs 'anotherPath.xlsx'


function Enable-Completer.vscode {
    <#
    .SYNOPSIS
    .NOTES
        see more:
            - [about_advanced_parameters](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_functions_advanced_parameters?view=powershell-7.4)
    #>
}

'done'