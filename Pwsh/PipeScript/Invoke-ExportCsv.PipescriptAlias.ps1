Import-Module -MinimumVersion 0.2.4 -Name 'Pipescript'

$results = get-alias
| ? Source -EQ 'pipescript'
| select-Object -ea ignore ModuleName, ResolvedCommandName, DisplayName,  Synopsis, Namespace, CommandType
| Sort-Object ModuleName, ResolvedCommandName, Name, DisplayName -ea ignore

# simplify for readability
$DestPath = join-path '.' './Readme.Pipescript.Commands.csv'
$results | Export-Csv -Path $DestPath -Encoding utf8

$DestPath | Get-Item | Join-String -f 'wrote: <file:///{0}>'