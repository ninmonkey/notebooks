$path_export = 'g:\temp\xl\proc_usage.xlsx'
# $findTypes = Get-Counter -ListSet *
$counter_set ??= @{}
$regex = [regex]::Escape('cpu')
$counter_set.CPU = $findTypes | ?{ $_.CounterSetName -Match $regex -or $_.Description -match $regex -or $_.Paths -match $regex }

$one = $counter_set.CPU | Select -first 1

$counters.counter | fl *

xL.Window.CloseAll
remove-item $path_export -ea 'ignore'
$script:Pkg = Open-ExcelPackage -Path $path_export -create
function xl.AddSheet {
    # collects list of objects from the pipeline
    [CmdletBinding()]
    param(
        # Data
        [Parameter(Mandatory ,ValueFromPipeline)]
        [object[]]$InputObject,

        [Parameter(Mandatory, Position=0)]
        [string]$SheetName
    )
    begin {
        [COllections.Generic.List[object]]$Items = @()
    }
    process {
        $items.AddRange(@($InputObject))
    }
    end {
        <#

    -ClearSheet [<SwitchParameter>]
        If specified Export-Excel will remove any existing worksheet with the selected name.
        The default behaviour is to overwrite cells in this sheet as needed (but leaving non-overwritten ones in

    -Append [<SwitchParameter>]
        If specified data will be added to the end of an existing sheet, using the same column headings.

    -PivotRows <String[]>
        Name(s) of column(s) from the spreadsheet which will provide the Row name(s) in a PivotTable created from command line parameters.

    -PivotColumns <String[]>
        Name(s) of columns from the spreadsheet which will provide the Column name(s) in a PivotTable created from command line parameters.

    -PivotData <Object>
        In a PivotTable created from command line parameters, the fields to use in the table body are given as a Hash-table in the form
        ColumnName = Average|Count|CountNums|Max|Min|Product|None|StdDev|StdDevP|Sum|Var|VarP.

    -PivotFilter <String[]>
        Name(s) columns from the spreadsheet which will provide the Filter name(s) in a PivotTable created from command line parameters.

    #>
        $script:Pkg = $items
        | Export-Excel -PassThru -work $SheetName -table "${SheetName}_data" -tablestyle Light2 -Show -AutoSize
    }
}
$pkg = Export-Excel


Close-ExcelPackage $Pkg -Show

$pkg = Open-ExcelPackage
$root = Get-Counter * -ea 'ignore'
$root.PathsWithInstances





return
$hostname = hostname
$Date      = $args[0]
$Threshold = $args[1]
$Counter   = $args[2]

$TopProcesses = Get-Counter -ErrorAction SilentlyContinue '\Process(*)\% Processor Time' |
Select-Object -ExpandProperty countersamples |
Select-Object -Property instancename, cookedvalue |
? {$_.instanceName -notmatch "^(idle|_total|system)$"} |
Sort-Object -Property cookedvalue -Descending |
Select-Object -First 10 |
ft InstanceName,@{L='CPU';E={($_.Cookedvalue/100/$env:NUMBER_OF_PROCESSORS).toString('P')}} -AutoSize

$Value = "[{0}] {1} {2} | {3}" -F $Date, 'High CPU', $Threshold, $Counter + $TopProcesses

Add-Content -Value $Value -Path 'C:\HighCPUAlert.log'

## Emails devops log errors are detected
$body = " Error. $Value on $hostname"
$emailFrom = "$hostname@company.com"
$emailTo = "devops@company.com"
$subject = "$hostname - High CPU Usage"
$smtpServer = "mail.adtrav.com"
$smtp = new-object Net.Mail.SmtpClient($smtpServer)
$smtp.Send($emailFrom, $emailTo, $subject, $body)