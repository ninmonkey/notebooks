Import-Module ImportExcel
$mapping = @(  // easily replace this with a csv file
    @{ Regex = 'dog'                 ; To = 'dog'   }
    @{ Regex = 'bdg|lizard|elephant' ; To = 'other' }
)
$table = Import-Excel -Path  $src # 'c:\data\foo.xlsx'  
foreach($row in $table) {
    foreach($map in $mapping) { 
        if($row.CompanyName -match $map.Regex) { 
           $row.CompanyName = $map.To
        }
    }
}
$table | Export-Excel -Show
