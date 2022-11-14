```ps1
$relatedModules = [ModuleRelationships()]$MyModule | .RelatedModule
$modulesToCheck = @() + $myModule + $relatedModules
$pathsToCheck   = $modulesToCheck | Split-Path

$script:TranspilerListUsingAll = 
    all scripts in $pathsToCheck where {
        $_.Name -match '\.psx\.ps1$'
    } are transpilers sort by {
        foreach ($attr in $_.ScriptBlock.Attributes) {
            if ($attr -isnot [Reflection.AssemblyMetadataAttribute]) {
                continue
            }
            if ($attr.Key -notin 'Order', 'Rank') {
                continue
            }
            $attr.Value -as [int]
        }
    }, Name

Get-Gradient -StartColor (. { new RgbColor 255 0 255 } ) blue

```

```ps1


.>PipeScript
.>


$relatedModules = [ModuleRelationships()]$MyModule | .RelatedModule
$modulesToCheck = @() + $myModule + $relatedModules
$pathsToCheck   = $modulesToCheck | Split-Path

where artAsset { $_ -match '\.(png|jpg|gif)' }
where optionalConfig { $_ -match .... }
where mandatoryConfig  { $_ -in @( 'core.xml', 'core.json' ) }
where is PipeWork { $_.Name -match '\.psx\.ps1$' }

sortBy AttributeMetadataRank { 
    foreach ($attr in $_.ScriptBlock.Attributes) {
    if ($attr -isnot [Reflection.AssemblyMetadataAttribute]) {
        continue
    }
    if ($attr.Key -notin 'Order', 'Rank') {
        continue
    }
    $attr.Value -as [int]
}


$script:TranspilerListUsingAll = 
    all scripts in $pathsToCheck
    where is PipeWork 
    sortBy AttributeMetadataRank

$script:TranspilerListUsingAll = all scripts in $pathsToCheck,
where is PipeWork, sortBy AttributeMetadataRank
```

