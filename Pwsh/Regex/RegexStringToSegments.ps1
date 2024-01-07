<#
original snippet
    'EA0103AB03' -replace '(?<=\G..)(?!$)',':'
outputs:
    'EA:01:03:AB:03'
#>


function New-Regex.SplitBySegmentSize {
    <#
    .SYNOPSIS
        terrible name. turns a string into n-length chars, then
    .NOTES
        dotnet supports variable length lookbehinds
        I'm not sure if some flavors will complain on this
            $splat.InputText -replace '(?<=\G.{2})(?!$)', ' '

        so lets build an explicit version
            'EA0103AB03' -replace '(?<=\G..)(?!$)',':'

        original snippet
            'EA0103AB03' -replace '(?<=\G..)(?!$)',':'
        outputs:
            'EA:01:03:AB:03'
    #>
    [Alias('Regex.SplitByCrumbs')]
    [CmdletBinding()]
    param(
        # return the regex pattern. skips everything else.
        [switch]$PassThru,

        [string]$InputText,

        [Argumentcompletions(2, 3, 4, 10, 16)]
        [int]$SegmentLength = 2,

        [ArgumentCompletions(
            ':')]
        [string]$Delimiter = ':',

        [ArgumentCompletions('Original', 'MultiLine1', 'MultiLine2')]
        [string]$RegexName = 'Original' # MultiLine2

    )
    # was: '(?<=\G..)(?!$)',':'
    $regex = @{}
    # original thread: <https://discord.com/channels/180528040881815552/1179800911900590262/1192431121410048061>
    $regex.Original = @'
(?<=\G{0})(?!$)
'@
    $regex.MultiLine1 = @'
(?x)
    # modified it to work past the first newline
(?:
  ^|
  (?<=\G{0})
)
(?!$)
'@
    $regex.MultiLine2 = @'
(?x)
    # previous version moved delim to the start of match,
    # this preserves the original end of
(?:
  (?<=\G{0})
  |^
)
(?!$)
'@
    # $selectedRegex = $Regex.Original
    # $selectedRegex = $Regex.MultiLine
    # $selectedRegex = $Regex.MultiLine2
    $selectedRegex = $Regex.$RegexName
    if(-not $SelectedRegex){ throw "InvalidRegexName" }
    $renderRegex = $selectedRegex -f @(
        '.' * $SegmentLength -join ''
    )
    $renderRegex | Join-String -op 'RenderRegex: ' | Write-verbose
    $delimiter
        | Format-ControlChar
        | Join-String -op 'Replacement: ' | Write-verbose

    if($PassTHru){ return $RenderRegex }
    $InputText -replace $renderRegex, $Delimiter
}

$splat = @{
    InputText = 'EA0103AB03'
    Delimiter = ':'
    SegmentLength = 2
    Verbose = $true
    Debug = $true
}

$expected = 'EA:01:03:AB:03'
New-Regex.SplitBySegmentSize @Splat | Should -BeExactly $expected

$expected = 'EA 01 03 AB 03'
$splat.Delimiter = ' '
New-Regex.SplitBySegmentSize @Splat | Should -BeExactly $expected

$splat.InputText -replace '(?<=\G..)(?!$)', ' '
$splat.Delimiter = '--'
$expected = 'EA--01--03--AB--03'
New-Regex.SplitBySegmentSize @Splat | Should -BeExactly $expected

$splat.SegmentLength = 3
$splat.Delimiter = ':'
$expected = 'EA0:103:AB0:3'
New-Regex.SplitBySegmentSize @Splat | Should -BeExactly $expected

$splat.SegmentLength = 3
$expected = 'EA0:103:AB0:3'
New-Regex.SplitBySegmentSize @Splat | Should -BeExactly $expected


$splat = @{
    Debug         = $true
    Delimiter     = ':'
    InputText     = 'EA0103AB03'
    SegmentLength = 2
    Verbose       = $true
}
$c1              = "${fg:gray40}"
$c2              = "${fg:#7296ab}"
$c3              = "${bg:#323436}"
$splat.Delimiter = "$c1...$c2"

New-Regex.SplitBySegmentSize @Splat
    | Join-String -op $c2
    | Join-String -op $c3 -os $PSStyle.Reset
hr
New-Regex.SplitBySegmentSize @Splat -PassThru

function FancySegment {
    param(
        [Parameter(Mandatory)]
        [Argumentcompletions(2, 3, 4, 10, 16)]
        [Alias('Len')][int]$SegmentLength = 2,

        [ArgumentCompletions(
            "'.'", "'--'", "'  '", "','", "'•'", "'￫'", "'¦'", "'😒'", "'9️⃣'"
        )]
        [Parameter(Mandatory)]
        [string]$Delimiter,

        [Alias('Fg1')]
        # [PoshCode.Pansies.RgbColor]
        [ArgumentCompletions('"${fg:gray40}"')]
        $FgColor1 = "${fg:gray40}",

        [Alias('Fg2')]
        # [PoshCode.Pansies.RgbColor]
        [ArgumentCompletions('"${fg:#7296ab}"')]
        $FgColor2 = "${fg:#7296ab}",

        [Alias('Bg', 'Bg1')]
        # [PoshCode.Pansies.RgbColor]
        [ArgumentCompletions('"${bg:#323436}"')]
        $BgColor1  = "${bg:#323436}",

        [Parameter(Mandatory, ValueFromPipeline)]
        [Alias('Str', 'Text', 'InputObject', 'InObj', 'InText', 'Obj')]
        [string]$InputText


    )
    process {

        $splitSplat = @{
            InputText     = $InputText
            SegmentLength = $SegmentLength
            Delimiter     = "${FgColor1}${Delimiter}${FgColor2}"
        }
        New-Regex.SplitBySegmentSize @splitSplat
            | Join-String -op $FgColor2
            | Join-String -op $BgColor1 -os $PSStyle.Reset

    }
}
$PSDefaultParameterValues['New-Regex.SplitBySegmentSize:verbose'] = $false
$PSDefaultParameterValues['New-Regex.SplitBySegmentSize:debug'] = $false
hr
$Splat.InputText | FancySegment -SegmentLength 2 -Delimiter '.' # -fg1 '#7296ab' -fg2 '#323436' -bg1 '#323436'
$Splat.InputText | FancySegment -SegmentLength 2 -Delimiter '.'  -fg2 "${fg:#714a78}"
$Splat.InputText | FancySegment -SegmentLength 2 -Delimiter '--' -fg1 "${fg:#714a78}"
# hah, first output was
# > #323436#7296abSy:st:em:.C:ol:le:ct:io:ns:.H:as:ht:ab:le
$Longstuff = 'ÚÛÜÝÞßàáâãäåæçèéêëìíîïðñòóôõö÷øùúûüýþÿĀāĂăĄąĆćĈĉĊċČčĎďĐđĒēĔĕĖėĘęĚěĜĝĞğĠġĢģĤĥĦħĨĩĪīĬĭĮįİıĲĳĴĵĶķĸĹĺĻļĽľĿŀŁłŃńŅņŇňŉŊŋŌōŎŏŐőŒœŔŕŖŗŘřŚśŜŝŞşŠšŢţŤťŦŧŨũŪūŬŭŮůŰűŲųŴŵŶŷŸŹźŻżŽžſƀƁƂƃƄƅƆƇƈƉƊƋƌƍƎƏƐƑƒƓƔƕƖƗƘƙƚƛƜƝƞƟƠơƢƣƤƥƦƧƨƩƪƫƬƭƮƯưƱƲƳƴƵƶƷƸƹƺƻƼƽƾƿǀǁǂǃǄǅǆǇǈǉǊǋǌǍǎǏǐǑǒǓǔǕǖǗǘǙǚǛǜǝǞǟǠǡǢǣǤǥǦǧǨǩǪǫǬǭǮǯǰǱǲǳǴǵǶǷǸǹǺǻǼǽǾǿȀȁȂȃȄȅȆȇȈȉȊȋȌȍȎȏȐȑȒȓȔȕȖȗȘșȚțȜȝȞȟȠȡȢȣȤȥȦȧȨȩȪȫȬȭȮȯȰȱȲȳȴȵȶȷȸȹȺȻȼȽȾȿɀɁɂɃɄɅɆɇɈɉɊɋɌɍɎɏɐɑɒɓɔɕɖɗɘəɚɛɜɝɞɟɠɡɢɣɤɥɦɧɨɩɪɫɬɭɮɯɰɱɲɳɴɵɶɷɸɹɺɻɼɽɾɿʀʁʂʃʄʅʆʇʈʉʊʋʌʍʎʏʐʑʒʓʔʕʖʗʘʙʚʛʜʝʞʟʠʡʢʣʤʥʦʧʨʩʪʫʬʭʮʯ'
$stuff = $Longstuff.Substring( $stuff.Length / 7 )

$stuff | FancySegment -SegmentLength 2 ' ￫ '

hr
$stuff
| FancySegment -SegmentLength 3 ',' -BgColor1 "${bg:gray15}" -FgColor2 "${fg:gray30}"
hr
$stuff | FancySegment -SegmentLength 15 ' ￫ '

Get-Module -ea Ignore | FancyName Name -Separator ' ' -Len 6


function FancyName {
    param(
        [ArgumentCompletions(
            'Name', 'Length', 'FullName', 'Path'
        )]
        [string]$PropertyName,
        [string]$Separator = ', ',
        [ArgumentCompletions(
            2, 3, 4, 10, 16
        )]
        [int]$Len
    )
    $Input
        | % $PropertyName
        | Sort-Object -Unique
        | Join-String -sep $Separator -p {
            $_ | FancySegment -SegmentLength $Len '•'
        }
}

hr
Get-Module -ea Ignore | FancyName Name -Separator "`n" -len 4
hr
Get-service -ea Ignore | FancyName Name -Separator '  ' -Len 6


return
$stuff | FancySegment -SegmentLength 2 ' ￫ '
hr
$stuff | FancySegment -SegmentLength 2 '   ￫   '
return

0..3000 -as [Text.Rune[]] | Join-String -sep ''
$stuff = 0..540 -as [Text.Rune[]] | Join-String -sep ''



# $stuff -replace '\s+', '' |Join-String -sep '__' | FancySegment -Len 2 -Delimiter '.'
# $stuff -replace '\s+', '' |Join-String -sep '__' | FancySegment -Len 8 -Delimiter '.'
$chars = '¢£¤¥¦§¨©ª«¬­®¯°±²³´µ¶·¸¹º»¼½¾¿ÀÁÂÃÄÅÆÇÈÉÊËÌÍÎÏÐÑÒÓÔÕÖ×Ø
ÙÚÛÜÝÞßàáâãäåæçèéêëìíîïðñòóôõö÷øùúûüýþÿĀāĂăĄąĆćĈĉĊċČčĎďĐđĒēĔĕĖėĘęĚěĜĝĞğĠġĢģĤĥĦħĨĩĪīĬĭĮįİıĲĳĴĵĶķĸĹĺĻļĽľĿŀŁłŃńŅņŇňŉŊŋŌōŎŏŐőŒœŔŕŖŗŘřŚśŜŝŞşŠšŢţŤťŦŧŨũŪūŬŭŮůŰűŲųŴŵŶŷŸŹźŻżŽžſƀƁƂƃƄƅƆƇƈƉƊƋƌƍƎƏƐƑƒƓƔƕƖƗƘƙƚƛƜƝƞƟƠơƢƣƤƥƦƧƨƩƪƫƬƭƮƯưƱƲƳƴƵƶƷƸƹƺƻƼƽƾƿǀǁǂǃǄǅǆǇǈǉǊǋǌǍǎǏǐǑǒǓǔǕǖǗǘǙǚǛǜǝǞǟǠǡǢǣǤǥǦǧǨǩǪǫǬǭǮǯǰǱǲǳǴǵǶǷǸǹǺǻǼǽǾǿȀȁȂȃȄȅȆȇȈȉȊȋȌȍȎȏȐȑȒȓȔȕȖȗȘșȚțȜȝȞȟȠȡȢȣȤȥȦȧȨȩȪȫȬȭȮȯȰȱȲȳȴȵȶȷȸȹȺȻȼȽȾȿɀɁɂɃɄɅɆɇɈɉɊɋɌɍɎɏɐɑɒɓɔɕɖɗɘəɚɛɜɝɞɟɠɡɢɣɤɥɦɧɨɩɪɫɬɭɮɯɰɱɲɳɴɵɶɷɸɹɺɻɼɽɾɿʀʁʂʃʄʅʆʇʈʉʊʋʌʍʎʏʐʑʒʓʔʕʖʗʘʙʚʛʜʝʞʟʠʡʢʣʤʥʦʧʨʩʪʫʬʭʮʯʰʱʲ'
