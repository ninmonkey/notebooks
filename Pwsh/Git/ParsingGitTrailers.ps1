using namespace System.Collections.Generic
# Set-Alias 'Write-Host' -Value Write-Host

$sampleCommit = @'
subject

Lorem ipsum dolor sit amet, consectetur adipiscing elit.

Signed-off-by: Alice <alice@example.com>
resolved: crisis 314
Signed-off-by: Bob <bob@example.com>
'@

function H1 {
    # Color console output using header colors
    param( [string]$Text )
    "`n### $Text `n`n"
        | Microsoft.PowerShell.Utility\Write-Host
}

function Parse-CommitTrailer {
    <#
    .NOTES
        - subcommand usage: https://git-scm.com/docs/git-interpret-trailers
        - can works on 'git-format-patch' patches too: https://git-scm.com/docs/git-format-patch
        - trailers can use duplicate key names, see: <https://git-scm.com/docs/git-interpret-trailers>

        --parse is an alias for: --only-trailers --only-input --unfold.
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

h1 'original'


$sampleCommit

h1 'parsed'
( $Parsed = Parse-CommitTrailer $sampleCommit )  | ConvertTo-Json
$Parsed.KeyCollection | Format-Table -AutoSize
$Parsed | Format-List

h1 'render shared as collapsed'
$Parsed.ShortKeys
#

# $Items = $parsed.KeyCollection
# $items | Group-Object Key | %{
#     $_.Group | % Value | Join-string -f "`n    {0}" -op $_.Name
# }

function AddTrailer {
    # file or conents
    # Gc  .\msg.txt -raw
    param(
        $CommitMessage
        # [hashtable]$NewTrailers # not right, new trailers can use duplicate keys
    )
    [List[Object]]$AddTrailerArgs = @(
        'interpret-trailers'
    )
    $AddTrailerArgs.AddRange(@(
        '--trailer'
        'author: Jen <jen@bar.com>'
        '--trailer'
        'author: Tom <tom@bar.com>'
        '--trailer'
        'reviewed-by: Dan <dan@bar.com>'
    ))


    $CommitMessage
        # | git interpret-trailers --trailer 'location: local' --trailer 'author: Jen <jen@bar.com>'
        # | git interpret-trailers --trailer 'location: local' --trailer 'author: Jen <jen@bar.com>'
}

h1 'Append trailers to message'

AddTrailer -CommitMessage $sampleCommit

$roundTrip = Parse-CommitTrailer -CommitMessage ( AddTrailer -CommitMessage $sampleCommit )

h1 'RoundTrip.RawMessage'

$roundTrip.RawMessage

h1 'RoundTrip.ShortKeys'

$roundTrip.ShortKeys