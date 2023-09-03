Import-Module PSParseHtml
function GetFirstGoogleResult {
    <#
    .SYNOPSIS
        Combination of XPath and url regex that selects the first google result
    .EXAMPLE
        Pwsh> GetFirstGoogleResult -Query 'cat'
        https://en.wikipedia.org/wiki/Cat

        Pwsh> GetFirstGoogleResult -Query 'power query docs table.merge'
            | Should -because 'manual test' -be 'https://support.microsoft.com/en-au/office/merge-queries-power-query-fd157620-5470-4c0f-b132-7ca2616d17f9'
    #>
    [OutputType('string')]
    param(
        # google search query
        [Alias('Query')][string]$SearchTerm = 'cat
    ')
    $url = 'https://www.google.com/search?&q={0}' -f @( $SearchTerm )
    $response ??= invoke-webrequest $url
    $agil = ConvertFrom-HTML -Content $response.Content -Engine AgilityPack
    $urlPrefix = '^/url\?q='
    $firstUrl = $agil.SelectNodes("//a")
        | ?{ $_.Attributes['href'].Value -match $urlPrefix }
        | Select -First 1

    $cleanUrl = $firstUrl.Attributes['href'].value -replace ([regex]::Escape('/url?q=')), '' -split '&' | select -First 1
    $cleanUrl
}

$search ??= @{}
$Search.cat ??= GetFirstGoogleResult -Query 'cat'
$Search.pq_Merge ??= GetFirstGoogleResult -Query 'powerquery docs table.merge'
$search |Ft -auto

$search.pq_merge
# worked | Should -be 'https://support.microsoft.com/en-au/office/merge-queries-power-query-fd157620-5470-4c0f-b132-7ca2616d17f9' -because 'manual test'
