function Markdown.Format-UnorderedList {
    <#
    .SYNOPSIS
        markdown unordered lists
    #>
    [Alias(
        'md.Format-UL', 'markdown.UL' )]
    param(
        [int]$Depth = 0,
        #input lines
        [Alias('Content', 'Items', 'List', 'InText', 'Str')]
        [Parameter(ValueFromPipeline)]
        [string]$Text
    )
    process {
        $Predent = '  ' * $Depth -join ''
        $Text
            | Join-String -f "${Predent} - {0}" -sep "`n"
    }
}
$StrId = 0
function AsBuilder {
    param( [Text.StringBuilder]$InText )
    $name = Get-Process | % Name | Get-Random
    [void]$InText.AppendLine( $Name )
    [void]$inText.Append( ( $strId++ ))
    return $InText
    # return $inText.ToString()
}
function Markdown.AppendString {
    param(
        [string[]]$InText, [string]$JoinDelim
    )

}
function Markdown.GenerateLinks.FromType {
    <#
    .SYNOPSIS
        takes a class and builds a list of markdown links from type def
    #>
    param(
        [ArgumentCompletions(
            "([Enumerable])"
        )]
        [Alias('InputObject', 'InObj', 'Obj', 'Tinfo')]
        [Parameter(Mandatory)]
        [Type]
        $TypeInfo,

        [ArgumentCompletions(
            'view=net-8.0',
            'dotnet-uwp-10.0',
            ''
        )]
        $Suffix = 'view=net-8.0'
    )
    function __fmt.ListItem {
        <#
        .SYNOPSIS
            template render one list item
        example
        #>
        param(
            [string]$Text
            # [string]$Suffix = '?'
        )
        $NameLower = $Text.ToLowerInvariant()
        $tinfoLowerName = $TypeInfo.ToString().ToLowerInvariant() # .ToString().ToLower()
@"
[$Text](https://learn.microsoft.com/en-us/dotnet/api/${TinfoLowerName}.${NameLower}?${Suffix})
"@
    }
    $TypeInfo
        | Find-Member -MemberType Method
        | % Name | Sort-Object -Unique
        | %{ __fmt.ListItem $_ } #-Suffix $Suffix }
}

# Dot.Markdown.GenerateLinks.FromType
$render_md = Markdown.GenerateLinks.FromType -TypeInfo ([Enumerable])

$render_md | Markdown.Format-UnorderedList -Depth 1
# ($render_md = a.Markdown.GenerateLinks.FromType -TypeInfo ([Enumerable]) -Suffix 'view=net-8.0' )

$expected = @'
[Aggregate](https://learn.microsoft.com/en-us/dotnet/api/system.linq.enumerable.aggregate?view=net-8.0)
'@
