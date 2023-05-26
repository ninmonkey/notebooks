# the context is from <https://discord.com/channels/180528040881815552/447477006385414174/1108361002535374958>
function Invoke-RawWebRequest.Fancy {
    # using the types [Uri] and [Http.HttpMethod]
    # and body suggests default query strings
    # [ArgumentCompletions] completers will run on WinPS 5
    # Join-String is sugar if using PS7
    # [System.Net.Http.HttpMethod] probably requires dotnet/PS7
    # it's a simple [enum] though, easily replaced.
    [Alias('Ira.Fancy')] # it's a pun
    param (
        [ArgumentCompletions(
            'https://api.api-ninjas.com/v1/cats' )]
        [Parameter(Mandatory)]
        [System.Uri]$Uri,

        [ArgumentCompletions(
            "@{ name = 'abyssinian' }" )]
        $Body,

        [System.Net.Http.HttpMethod]$Method

        # [System.Net.Http.HttpMethod] | Find-Member -MemberType Property | % Name | Join-String -sep ', ' -SingleQuote
    )
}
<# valdidate set was created by running: #>
[System.Net.Http.HttpMethod]
    | ClassExplorer\Find-Member -MemberType Property
    | % Name | Sort-Object -Unique
    | Join-String -sep ', ' -SingleQuote
    | Set-Clipboard -PassThru
#>


function Invoke-RawWebRequest {
    [Alias('Ira')] # it's a pun
    param (
        [Parameter(Mandatory)]
        [System.Uri]$Uri,
        $Body,
        [System.Net.Http.HttpMethod]$Method
    )
}

Ira -Uri https://api.api-ninjas.com/v1/cats -Body '?name=abyssinian' -Method GET

Ira.Fancy -Uri https://api.api-ninjas.com/v1/cats -Body @{ name = 'abyssinian' } -Method Get