get-alias
| ? Source -EQ 'pipescript'
| select-Object -First 3
| select-Object ModuleName, ResolvedCommandName, DisplayName, Segments, Separator, Synopsis, Namespace, CommandType, Parameters
| Sort-Object
| %{
    $row = $_
        [int]$num = 4
        [string]$Other = 4
    $members = @{}.Add(
    $row | Add-Member -PassThru -Force -NotePropertyMembers $members



        $_.ParametersList = [object[]]$_.Parameters | % Tostring
    $_
}