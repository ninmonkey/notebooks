
function ShortenStr {
    <#
    .SYNOPSIS
        truncate string length, never throw errors
    #>
    [CmdletBinding()]
    [Alias('Shorten')]
    param(
        # text to shorten
        [AllowEmptyString()]
        [AllowNull()]
        [Alias('InputObject', 'Text')]
        [Parameter(ValueFromPipeline)]
        [string]$InputText,

        [int]$MaxLength = 120
    )
    process {
        if($Null -eq $InputText) { return '' }
        if( [string]::IsNullOrEmpty( $InputText) ) { return '' }
        $inputLen = $InputText.length
        $maxValidCount = [Math]::Clamp(
            <# value #> $inputLen,
            <# min #> 0, <# max #> $MaxLength )

        $InputText.Substring( 0, $maxValidCount )

        <# or WinPS #>
        if($false) {
            $reFirst = '^(.{1,50}).*' # silly regex, grab the first 300 chars
            $InputText -replace $reFirst, '$1'
        }
    }
}

. {
    # Original demo
    $queryParam = 'PSParseHTML blog evotec'
    $language = 'sv'
    $urlbuilder = "https://www.google.com/search?&q=" + [System.Web.HttpUtility]::UrlEncode($QueryParam) + "&hl=$language"
    'Loading Website with AgilityPack'
    $agiltypackload ??= ConvertFrom-Html -Url $urlbuilder -Engine AgilityPack
    $agiltypackload.SelectNodes('//a').Count
    $agiltypackload.SelectNodes('//a') | Select-Object InnerText | Format-List
    'Loading website with Invoke-WebRequest'
    $iwrload ??= (Invoke-WebRequest -Uri $urlbuilder).Content | ConvertFrom-Html -Engine AgilityPack
    $iwrload.SelectNodes('//a').Count
    $iwrload.SelectNodes('//a') | Select-Object InnerText | Format-List
    'saved to $agilityPackLoad and $iwrLoad' | write-host -back 'red'
}


function Render.Bool {
    <#
    .SYNOPSIS
        render something bool-like
    .example
        Pwsh>
        $sample = 'true,$true,$null,null,none,false,$false,1,0,, ,y,Yes,n,No,not' -split ','

        $sample | Render.Bool | fcc |
    .EXAMPLE
        # current expected value
'true,$true,␀,$null,null,none,false,$false,1,0,, ,y,Yes,n,No,not' -split
     ',' | Render.Bool | Join-String -sep "`n" { $_ | fcc }
        | cl -Append

            ␛[38;2;0;95;0mtrue␛[0m
            ␛[38;2;153;153;153m$true␛[0m
            ␛[38;2;190;116;73m␛[48;2;51;51;51m␀␛[0m
            ␛[38;2;190;116;73m␛[48;2;51;51;51m$null␛[0m
            ␛[38;2;190;116;73m␛[48;2;51;51;51mnull␛[0m
            ␛[38;2;190;116;73m␛[48;2;51;51;51mnone␛[0m
            ␛[38;2;95;0;0mfalse␛[0m
            ␛[38;2;153;153;153m$false␛[0m
            ␛[38;2;0;95;0m1␛[0m
            ␛[38;2;95;0;0m0␛[0m
            ␛[38;2;153;153;153m␛[0m
            ␛[38;2;153;153;153m␠␛[0m
            ␛[38;2;0;95;0my␛[0m
            ␛[38;2;0;95;0mYes␛[0m
            ␛[38;2;95;0;0mn␛[0m
            ␛[38;2;95;0;0mNo␛[0m
            ␛[38;2;153;153;153mnot␛[0m
    #>
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [AllowNull()]
        [AllowEmptyCollection()]
        [Parameter(ValueFromPipeline)]
        $InputObject
    )
    process {
        [string]$Text = $InputObject
        $C = @{
            FgDim = $PSStyle.Foreground.FromRgb('#999999')
            FgBad = $PSStyle.Foreground.FromRgb('#5f0000')
            FgGood = $PSStyle.Foreground.FromRgb('#005f00')
            FgNull = "${fg:#be7449}${bg:#333333}"
        }
        if( $InputObject -isnot 'bool' ) {
            'InputObject type {0} is not a true [bool]' -f @( $InputObject | Format-ShortTypeName )
            | Write-verbose
        }
        $fg = $C.FgDIm
        $selectedColor = switch -Regex ( $Text ) {
            # too wide as nonzero
            # '^(true|1||[^0]+)$
            '^(\$?null|␀|none)$' { $C.FgNull }
            '^(true|1|y|yes)$' { $C.FgGood ; break; }
            '^(false|0|n|no)$' { $C.FgBad  ; break; }
            default { $C.FgDim }
        }
        $selectedColor = $selectedColor -join ''
        $Text | Join-String -op $selectedColor -os $PSStyle.Reset -sep ''
    }
}

$query = $agiltypackload.SelectNodes('//a')
$query | fl * -force
$what = $query | One



function Render.Dom.Attributes {
     $lone.Attributes
        # custom priorities
        | Sort-Object -Descending {@(
            $_.Value.Length -lt 15
            $_.Name -match 'class|id|name'
            $_.Name -match 'href|src|url'
            $_.Name
        )}
        | Join-String -sep "`n" {
        '{0}: {1}' -f @(
            $_.Name | Join-String -op "${fg:#aad3a8}" -os $PSStyle.Reset
            ( $_.Value ?? '') | Join-String -DoubleQuote -op "${fg:#94c5e4}" -os $PSStyle.Reset
        )
    }


}

function Render.Dom.Attributes {
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipeline)]
        $InputObject
    )
    $sep = ' ' # { '', ', ', ", " }
    $InputObject.Attributes
        # custom priorities
        | Sort-Object -Descending {@(
            $_.Value.Length -lt 15
            $_.Name -match 'class|id|name'
            $_.Name -match 'href|src|url'
            $_.Name
        )}
        | Join-String -sep $Sep {
        '{0}: {1}' -f @(
            $_.Name | Join-String -op "${fg:#aad3a8}" -os $PSStyle.Reset
            ( $_.Value ?? '') | Join-String -DoubleQuote -op "${fg:#94c5e4}" -os $PSStyle.Reset
        )
    }
}
# Render.Dom.Attributes__
$NextType = 'HtmlAgilityPack.HtmlDocument'
update-typedata -typename $NextType -membername 'TextShort' -membertype ScriptProperty -value {
    Shorten -Inp $this.Text -maxLength 200
        | Dotils.Write-DimText # toggles gray text in tables
} -Force
update-typedata -typename $NextType -membername 'ParsedTextShort' -membertype ScriptProperty -value {
    Shorten -Inp $this.ParsedText -maxLength 200
        | Dotils.Write-DimText # toggles gray text in tables
} -Force

$NextType = 'HtmlAgilityPack.HtmlNode'

update-typedata -typename $NextType -membername 'OuterHtmlShort' -membertype ScriptProperty -value {
    Shorten -Inp $this.OuterHtml -maxLength 150
    | Dotils.Write-DimText # toggles gray text in tables
} -Force
update-typedata -typename $NextType -membername 'InnerHtmlShort' -membertype ScriptProperty -value {
    Shorten -Inp $this.InnerHtml -maxLength 150
    | Dotils.Write-DimText # toggles gray text in tables
} -Force
update-typedata -typename $NextType -membername 'InnerHtmlColumn' -membertype ScriptProperty -value {
    Shorten -Inp $this.InnerHtml -maxLength 300
    | Dotils.Write-DimText # toggles gray text in tables
} -Force
update-typedata -typename $NextType -membername 'InnerTextShort' -membertype ScriptProperty -value {
    Shorten -Inp $this.InnerText -maxLength 150
    | Dotils.Write-DimText # toggles gray text in tables
    # | bat -l html  --color always -p | Out-String
} -Force
update-typedata -typename $NextType -membername 'AttrSummaryLong' -membertype ScriptProperty -value {
    $this | Dotils.Render.Dom.Attributes -Separator "`n"
    # | Shorten -maxLen 15 # optionally truncate it too
} -Force
update-typedata -typename $NextType -membername 'AttrSummaryColumn' -membertype ScriptProperty -value {
    $render = $this | Dotils.Render.Dom.Attributes -Separator "`n"
    $render -split '\r?\n' | %{
        Shorten -Inp $_ -MaxLength 60
    } | Join-String -sep "`n"
    # | Shorten -maxLen 15 # optionally truncate it too
} -Force
update-typedata -typename $NextType -membername 'AttrSummarySingleLine' -membertype ScriptProperty -value {
    # optionally: Shorten()
    $this | Dotils.Render.Dom.Attributes -Separator ' '
    # | Shorten -maxLen 15 # optionally truncate it too
} -Force

update-typedata -typename $NextType -membername 'HasSummary' -membertype ScriptProperty -value {
    'Closed: {0}, ChildAttrs: {1}, ChildNodes: {2}, HasClosingAttr: {3}' -f @(
        $this.Closed ?? '␀' | Render.Bool
        $this.HasChildAttributes ?? '␀' | Render.Bool
        $this.HasChildNodes  ?? '␀' | Render.Bool
        $this.HasClosingAttributes ?? '␀' | Render.Bool
    )
    | Dotils.Write-DimText
} -Force

Update-TypeData -typeName $NextType -DefaultDisplayPropertySet @(
    'Id'
    'Depth'
    'HasSummary'
    'AttrSummarySingleLine'
    'Attributes'
    'ChildNodes'
    'InnerHtmlShort'
    'InnerTextShort'
    'OuterHtmlShort'
    'OwnerDocument'
    'ParentNode'
    'XPath'
    'AttrSummaryLong'

    # 'Attributes' # -is [HtmlAgilityPack.HtmlAttributeCollection]
    # 'ChildNodes' # -is [HtmlAgilityPack.HtmlNodeCollection]
    # 'Closed' # -is [System.Boolean]
    # 'ClosingAttributes' # -is [HtmlAgilityPack.HtmlAttributeCollection]
    # 'Depth' # -is [System.Int32]
    # 'EndNode' # -is [HtmlAgilityPack.HtmlNode]
    # 'FirstChild' # -is [HtmlAgilityPack.HtmlNode]
    # 'HasAttributes' # -is [System.Boolean]
    # 'HasChildNodes' # -is [System.Boolean]
    # 'HasClosingAttributes' # -is [System.Boolean]
    # 'Id' # -is [System.String]
    # 'InnerHtml' # -is [System.String]
    # 'InnerLength' # -is [System.Int32]
    # 'InnerStartIndex' # -is [System.Int32]
    # 'InnerText' # -is [System.String]
    # 'LastChild' # -is [HtmlAgilityPack.HtmlNode]
    # 'Line' # -is [System.Int32]
    # 'LinePosition' # -is [System.Int32]
    # 'Name' # -is [System.String]
    # 'NextSibling' # -is [HtmlAgilityPack.HtmlNode]
    # 'NodeType' # -is [HtmlAgilityPack.HtmlNodeType]
    # 'OriginalName' # -is [System.String]
    # 'OuterHtml' # -is [System.String]
    # 'OuterLength' # -is [System.Int32]
    # 'OuterStartIndex' # -is [System.Int32]
    # 'OwnerDocument' # -is [HtmlAgilityPack.HtmlDocument]
    # 'ParentNode' # -is [HtmlAgilityPack.HtmlNode]
    # 'PreviousSibling' # -is [HtmlAgilityPack.HtmlNode]
    # 'StreamPosition' # -is [System.Int32]
    # 'XPath' # -is [System.String]
) -Force

# Example output
# other properties
$what | fime -MemberType Property | sort Name | ft Name, PropertyType, * -AutoSize

$agiltypackload.SelectNodes('//a') | select -exclude 'OuterHtml' ,'InnerHtml', 'InnerText' | fl * -force
hr
$query
| select Id,Depth, HasSummary, AttrSummaryLong, ChildNodes, *short*, XPath, *node*, *child* -ea 'ignore'
| select -ExcludeProperty 'InnerXmlShort', 'OuterXmlShort' -ea 'ignore'

