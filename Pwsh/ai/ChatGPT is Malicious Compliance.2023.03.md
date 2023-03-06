## AI is wrong, but also right.

I know it knows about [ImportExcel](https://github.com/dfinke/ImportExcel#basic-usage), so I asked a basic question. I'm using:
[dougFinke/PowerShellAI](https://github.com/dfinke/PowerShellAI#demos-of-the-powershellai) it's a powershell module that makes it easy to use ChatGPT from the command line. 
It calls the REST API for you

Question:
```ps1
Ai 'ImportExcel hilight column cost in table2 worksheet3'
```

### Answer1:

> To hilight the column cost in table2 worksheet3, select the column by clicking on the column header. 
> Then, right-click and select "Format Cells" from the menu. In the Format Cells window, select the 
> "Fill" tab and choose a color to hilight the column. Click "OK" to apply the changes


### Answer2:
Question:
```ps1
Ai 'Powershell ImportExcel hilight column named cost in table2 worksheet3'
```
Answer:
```ps1
$excelFile = Import-Excel -Path 'C:\Path\To\ExcelFile.xlsx'
$worksheet = $excelFile.worksheet3
$worksheet.Table2 | Format-Table -Property * -AutoSize | Out-String -Width 4096 | Foreach-Object {
    $_ -replace '\bCost\b', "`e[7m$&`e[27m"
} | Out-Host
```
it loads a file, then renders it as text / strings in the console. 

