. (Join-Path $PSScriptRoot '__import__.notebook.ps1' )
# . 'H:\data\2023\pwsh\notebooks\sketches\__import__.notebook.ps1'
# no current path in notebooks

# Export-Pipescript -InputPath (Get-Item './../toc/buffer.ps.md') -Verbose
Export-Pipescript -InputPath 'H:\data\2023\pwsh\notebooks\toc\buffer.ps.md' -Verbose

function debug.exportErrors {
    'note: formatting is not transformed yet, see Tabify.* instead'


    err | Get-Error | ForEach-Object {
        $curErr = $_
        if ($_ -isnot 'System.Management.Automation.ErrorRecord') {

            'warning, format expected [ErrorRecord] type is not an error record {0}' -f @(
            ($_)?.GetType().FullName
            )
        }
        $meta = @{}
        $meta.PSTypeName = 'notebooks.ErrorRecord.'
        $Meta.ErrorCategoryInfo ??= [System.Management.Automation.ErrorCategoryInfo]$curErr.ErrorCategoryInfo
        $Meta.ErrorDetails ??= [System.Management.Automation.ErrorDetails]$curErr.ErrorDetails
        $Meta.Exception ??= [System.Exception]$curErr.Exception
        $Meta.ErrorQualifedName ??= [string]$curErr.FullyErrorQualifedName
        $Meta.ScriptStackTrace ??= [string]$curErr.ScriptStackTrace
        $Meta.InvocationInfo ??= [System.Management.Automation.InvocationInfo]$curErr.InvocationInfo
        return [PSCustomObject]
    }
}

return






if ($false) {

    $all_files ??= Get-ChildItem -File -Force | Group-Object extension | Sort-Object Count -Descending
    $ls_files = fd --base-directory (Get-Item ..) -tf | Get-Item
    $ls_all = fd --base-directory (Get-Item ..) | Get-Item
    $with_ignored = fd --base-directory (Get-Item ..) -tf --absolute-path | Get-Item
    $q = fd --base-directory (Get-Item ..) -tf --absolute-path | Get-Item
    $grouped = $q
    | Group-Object {
        $_.LastWriteTime.ToString('yyyy-MM')
    }

}



#fd --search-path (gi ..)
# fd -tf --base-directory ( gi .. )
#| gi | Group extension
# | sort -Descending Count
# | select Count, Name

#  fd -e png -e jpg -e gif -e mpv4

# fd --absolute-path | sort

# fd --search-path (gi ..)
# fd -tf --absolute-path | gi | Group extension
# | sort -Descending Count
# | select Count, Name



# ~~~PipeScript{

#     function md.Path.escapeSpace { process { $_ -replace ' ', '%20' } }

#     Get-ChildItem . -Recurse -File
#     | Where-Object extension -Match '\.(pbix|pq|xlsx|png|md|dax)'#
#     | Where-Object Extension -NotMatch '\.ps\.(md|pbix|pq|dax)'  # ignore pipescript
#     | Sort-Object BaseName | ForEach-Object name
#     | ForEach-Object {
#         '[{0}]({1})' -f @(
#             $_
#             $_ | md.Path.escapeSpace
#         )
#     } | Join.UL
# }
# ~~~

