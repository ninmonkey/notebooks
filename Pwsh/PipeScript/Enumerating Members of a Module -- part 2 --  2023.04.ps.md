## Test exporting module meta info


~~~pipescript{
# $myMods = Get-Module | S -First 1 | convertto-csv | convertfrom-csv
# $mod.ExportedAliases.Keys | Join-String -sep ', ' | CountOf
$mod  = Import-Module ExcelAnt -PassThru -DisableNameChecking 
$aliasMeta = $mod.ExportedAliases.Keys | %{
    $aliasName = $_     
    $curCmd = Get-Command $aliasName
    $maybeSyntax = (gcm $aliasName -Syntax -ea ignore)
    if([String]::IsNullOrWhitespace($MaybeSyntax)) {
        $MaybeSyntax = "`u{2400}"
    }

    $curCmd | Add-Member -PassThru -Force -ea Ignore -NotePropertyMembers @{ 
        Syntax = $maybeSyntax ?? "`u{2400}"
    }       
} 
$aliasMeta | Select -p CommandType, Name, Version, Source, CommandNamespace, Description, Example, HasValidation # | ft -AutoSize 

[pscustomobject]@{
    Table = $aliasMeta
}

}~~~



```ps1


```