Set-Location (gi -ea 'stop' 'H:/data/2023/pwsh/PsModules/GitLogger')
Import-Module ugit -PassThru

[hashtable]$script:mapping = @{}

function git.Resolve-SymbolAsHash1{
    git branch # | ? IsCurrentBranch
    | ForEach-Object {
        $obj = $_
        if ($mapping.ContainsKey($Obj.BranchName)) { return }

        $key = $Obj.BranchName
        [object[]]$values = git show-ref $Key

        if (-not $Values) {
            $key
            | Join-String -f 'Zero results for: <git show-ref $key> = "{0}"'
            |  write-error
            return
            # Wait-Debugger
        }

        $values | % {
            $Hash, $Label =
            $_ -split '\s+', 2

            if ([string]::IsNullOrWhiteSpace($Hash) -or [string]::IsNullOrWhiteSpace($Label)) {
                '$Hash or $Label are empty' | Write-Error
            }
            $Mapping[ $Label ] = $Hash

        }
        return $mapping
    }
}
hr
$mapping = git.Resolve-SymbolAsHash
$mapping | ft -AutoSize -Wrap
$mapping.keys.count

hr
h1 'with exissting commands'

   git log $mapping['refs/remotes/origin/Improve-Onboarding'] -NumberOfCommits 5
git status $mapping['refs/remotes/origin/Improve-Onboarding'] | Join-String StatusLines -sep "`n"


return
if ($false) {
    return
    'super slow'
    git branch
    | ? IsCurrentBranch
    | % {

        $obj = $_
        $obj | Add-Member -NotePropertyMembers @{
            FromBranchName = $obj.BranchName
            ShowRef        = git show-ref $obj.BranchName
        } -PassThru -Force -ea 'ignore'
    } | ft -AutoSize -Wrap

}

# git branch| %{
#    $obj  = $_
#    $obj | Add-Member -NotePropertyMembers @{
#       FromBranchName = $_.BranchName
#       ShowRef = git show-ref $_.BranchName
#    } -PassThru -Force -ea 'ignore'
# }