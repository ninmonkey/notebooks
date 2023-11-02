using namespace System.Collections.Generic

$sampleCommit = @'
subject

Lorem ipsum dolor sit amet, consectetur adipiscing elit.

Signed-off-by: Alice <alice@example.com>
resolved: crisis 314
Signed-off-by: Bob <bob@example.com>
'@

function Parse-CommitTrailer {
    <#
    .NOTES
        trailers can use duplicate key names, see: <https://git-scm.com/docs/git-interpret-trailers>
    #>
    [CmdletBinding()]
    param( $CommitMessage )

    [List[Object]]$GitArgs = @(
        'interpret-trailers'
        '--parse'
    )
    $GitArgs
        | Join-String -sep ' ' -op 'Invoking GitArgs: '
        | write-verbose

    [List[Object]]$trailerList = @(
        $CommitMessage
            # | CountOf 'orig line count'
            | git @gitArgs
            # | CountOf 'after interpret-trailer'
            | %{
                $delim = ': '
                $Key, $Remaining = $_ -split $Delim, 2

                [PSCustomObject]@{
                    PSTypeName = 'test.Git.Trailer.KeyCollectionElement'
                    Key = $Key
                    Value = $Remaining
                }
            }
    )
    return [pscustomobject]@{
        PSTypeName = 'test.Git.ParsedCommit.Record'
        KeyCollection = $trailerList
        RawMessage = $CommitMessage
        ShortKeys = $trailerList | Group-Object Key
            | %{
                $_.Group | % Value | Join-string -f "`n    {0}" -op $_.Name
            }
    }
}

'original'
    | Microsoft.PowerShell.Utility\Write-Host -fore blue

$sampleCommit

'parsed'
    | Microsoft.PowerShell.Utility\Write-Host -fore blue

( $Parsed = Parse-CommitTrailer $sampleCommit )  | ConvertTo-Json
$Parsed.KeyCollection | Format-Table -AutoSize
$Parsed | Format-List

'render shared as collapsed'
$Parsed.ShortKeys
#     | Microsoft.PowerShell.Utility\Write-Host -fore blue

# $Items = $parsed.KeyCollection
# $items | Group-Object Key | %{
#     $_.Group | % Value | Join-string -f "`n    {0}" -op $_.Name
# }

