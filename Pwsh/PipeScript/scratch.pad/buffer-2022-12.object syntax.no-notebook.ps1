#Requires -Modules @{ModuleVersion = '0.1.9'; ModuleName = 'PipeScript' } -Version 7.0
# Now you can use multi-line dot syntax
@(
    ls . -file | Select -first 2
) | .> { 
    .Name { $_.BaseName }
    .Size { $_.Length / 1kb }
    .IsDir { $_.PsIsContainer }
}



Get-Module pipescript
# import-module PipeScript -MinimumVersion '0.1.9' -ea stop
# .> { .ID { Get-Random } .Count { 0 } .Total { 10 }}

@(
    ls . -file | Select -first 2
    ls . -dir | select -first 2 
) | Select -First 4
| .> { 
    .Name { $_.BaseName } .Size { $_.Length / 1kb } .IsDir { $_.PsIsContainer }
}
| Tee-Object -Variable 'results'
| ft -auto

# $results
