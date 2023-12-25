
$m = New-Module -AsCustomObject -ScriptBlock {
    function Greeting { param([string]$Name)
        "Name: $Name" }
    function List.All {
        param()
        gcm | Sort-Object -Unique Name }
}

hr
$m.psobject.Members|ft
$m.psobject.Methods|ft

hr
$m | gm
$m.Greeting
$m.Greeting('cat')

# $m | fm

hr
$m = new-module -Name 'foo.fork' -ReturnResult -AsCustomObject -ScriptBlock {
    function Greet { param( [string]$Text )
         "Greet: $Text"
    }
}




# either prepend path $Env:PSModulePath
# or direct import to be explicit
import-module -PassThru  | 'H:\data\2023\pwsh\my🍴\