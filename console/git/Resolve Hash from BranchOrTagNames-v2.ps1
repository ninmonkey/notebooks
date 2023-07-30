# Import-Module ugit -PassThru
Remove-Module ugit -ea ignore
$repoPath = gi -ea 'stop' 'H:/data/2023/pwsh/PsModules/GitLogger'
Set-Location $repoPath
<#
see also:
    $PSNativeCommandArgumentPassing
    $PSNativeCommandUseErrorActionPreference
#>

# git branch
function .git.Resolve-SymbolReference {
    <#
    .synopsis
        Resolves hash from Branch names, tag names, etc
    .EXAMPLE
        PS> import-module ugit -ea 'stop'
    .EXAMPLE
        PS> import-module ugit -ea 'stop'
            git branch | % BranchName | .git.Show-Ref
    #>
    [Alias('.git.Show-Ref')]
    param(
        [Parameter(Mandatory, ValueFromPipeline)]
        [string]$SymbolName
    )
    process {
        $query = git show-ref $SymbolName
        foreach ($pair in $query) {
            $hash, $name = $pair -split '\s+'
            [pscustomobject]@{
                PSTypeName = '.git.ResolvedReference'
                SymbolName = $SymbolName
                SymbolRef  = $Hash
                Name = $Name
            }
        }
    }
}

$summary = @(
    .git.Resolve-SymbolReference -SymbolName 'refs/remotes/origin/Improve-Onboarding'
    .git.Resolve-SymbolReference -SymbolName 'main'
)
$summary

return


[hashtable]$script:mapping2 = @{}

function git.Resolve-SymbolAsHash2 {

    foreach ($branch_name in @(git branch)) {
        [pscustomobject]@{
            PSTypeName = 'git.Resolve-SymbolResult'
            Branch     = $branch_name

        }

    }
    git branch # | ? IsCurrentBranch
    | ForEach-Object {
        $obj = $_
        if ($mapping2.ContainsKey($Obj.BranchName)) { return }

        $key = $Obj.BranchName
        [object[]]$values = git show-ref $Key

        if (-not $Values) {
            $key
            | Join-String -f 'Zero results for: <git show-ref $key> = "{0}"'
            | Write-Error
            return
            # Wait-Debugger
        }

        $values | % {
            $Hash, $Label =
            $_ -split '\s+', 2

            if ([string]::IsNullOrWhiteSpace($Hash) -or [string]::IsNullOrWhiteSpace($Label)) {
                '$Hash or $Label are empty' | Write-Error
            }
            $Mapping2[ $Label ] = $Hash

        }
        return $mapping2
    }
}
$mapping2 = git.Resolve-SymbolAsHash2
$mapping2 | ft -AutoSize -Wrap
$mapping2.keys.count

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