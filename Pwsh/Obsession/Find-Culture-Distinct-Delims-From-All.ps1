CacheMe 'Cults' { Get-Culture -ListAvailable }

# 123
(CacheMe Cults).NumberFormat | Group-Object NegativeSign | ForEach-Object Name | ForEach-Object EnumerateRunes


# 124
(CacheMe Cults).NumberFormat | Group-Object NegativeSign | ForEach-Object Name


# 125
$hs = [Hashset[string]]::new()
(CacheMe Cults).NumberFormat | Group-Object NegativeSign | ForEach-Object Name


# 126
$hs = [Hashset[string]]::new()

[string[]]$allProps = (CacheMe Cults)[0].NumberFormat.psobject.properties.name | Sort-Object -Unique
$forAllProps = [ordered]@{}

$allProps | ForEach-Object {
    $curProp = $_
    $curVal = (CacheMe Cults).NumberFormat.$CurProp
    $forAllProps[ $CurProp ] = $curVal
}

# 168
h1 '$forAllProps'
$forAllProps.getEnumerator() | ForEach-Object {
    $_.Name
    $_.Value | ForEach-Object { $_ } | Sort-Object -Unique | Join-String -sep '🐒'
}

$propRegex = 'sep'
[string[]]$whichProps = $forProp.Keys -match $propRegex
[string[]]$notProps   = $forProp.Keys -notmatch $propRegex
$whichProps | Join.UL | Label 'WhichProps'
$notProps  | Join.UL  | Label 'SkipProps'

$forSomeProps = [ordered]@{}
$whichProps | ForEach-Object {
    $curProp = $_
    $curVal = (CacheMe Cults).NumberFormat.$CurProp
    $forSomeProps[ $CurProp ] = $curVal
}

h1 '$forSomeProps'
$forSomeProps.getEnumerator() | ForEach-Object {
    $_.Name
    $_.Value | ForEach-Object { $_ } | Sort-Object -Unique | Join-String -sep '🐒'
}

h1 'madness'
@($forSomeProps.GetEnumerator().ForEach({
   Join-String -op $_.Key -Inp $_.Value -Separator ' '
}))
$C = @{
    GrayLow  = ' ' | New-Text -fg 'gray60' -bg 'gray20' -LeaveColor| Join-String
    GrayHigh = ' ' | New-Text -fg 'gray20' -bg 'gray60' -LeaveColor| Join-String
    Fg1 = $PSStyle.Foreground.FromRgb('#999999')
    Bg1 = $PSStyle.Background.FromRgb('#4c4c4c')
    Fg2 = $PSStyle.Background.FromRgb('#4c4c4c')
    Bg2 = $PSStyle.Foreground.FromRgb('#999999')
    Reset = $PSStyle.Reset
}
$C.Pre1 = $C.Fg1, $C.Bg1 -join ''
$C.Pre2 = $C.Fg2, $C.Bg2 -join ''

h1 'real'
@($forSomeProps.GetEnumerator().ForEach({
    # New-Text -bg 'gray60' -fg 'gray20' 'stuff' -LeaveColor | Join-string
   Join-String -op $_.Key -Separator '' -Inp @( $_.Value | Sort-Object -Unique )
   | Join-String -op $C.Pre1 -os $C.Reset
    # | New-Text -fg 'gray60' -bg 'gray20' | Join-string
   #| Join-String -op $PSStyle.Background.FromRgb('#cecece') -os $PSStyle.Reset
}))



function Str.Frequency.Render {
    $items = @( $Input )
    $Items | Group-Object | %{
        @(
            $C.GrayHigh
            $_.Name
            $PSStyle.Reset
            ' => '
            $C.GrayLow
            $_.Count
            $PSStyle.Reset
        ) | Join-String
    }
    $PSStyle.Reset
}
# ',', ',', '.', '4' | Group-Object | %{

h1 'last'

Join-String $PSStyle.Reset
@($forSomeProps.GetEnumerator().ForEach({
    # $C.GrayHigh
    Join-String -op $_.Key -Separator '' -Inp @(
        $_.Value | Sort-Object -Unique
            | Join-String -op '' )
            | Join-String -op ''
        # | New-Text -fg 'gray60' -bg 'gray20' | Join-string
   #| Join-String -op $PSStyle.Background.FromRgb('#cecece') -os $PSStyle.Reset
    # Join-String $PSStyle.Reset
}))

h1 'end'
return
@($forSomeProps.GetEnumerator().ForEach({
    $C.GrayHigh
    Join-String -op $_.Key -Separator '' -Inp @(
        $_.Value | Sort-Object -Unique
            | Join-String -op $C.GrayLow)
            | Join-String -op $C.GrayHigh
        # | New-Text -fg 'gray60' -bg 'gray20' | Join-string
   #| Join-String -op $PSStyle.Background.FromRgb('#cecece') -os $PSStyle.Reset
    Join-String $PSStyle.Reset
}))

return
h1 'test'
@($forSomeProps.GetEnumerator().ForEach({
    New-Text -bg 'gray60' -fg 'gray20' 'stuff' | Join-string
   Join-String -op $_.Key -Separator '' -Inp @( $_.Value | Sort-Object -Unique )
    | New-Text -fg 'gray60' -bg 'gray20' | Join-string
   #| Join-String -op $PSStyle.Background.FromRgb('#cecece') -os $PSStyle.Reset
}))



return

# 170
Get-History | ForEach-Object {
    $_.Id | Join-String -f '# {0}'
    $_.CommandLine
    "`n"
}

$hs
@( (CacheMe Cults).NumberFormat | Group-Object NegativeSign | ForEach-Object Name )
| ForEach-Object { $hs.Add( $_ ) }

$hs = [Hashset[string]]::new()
@((CacheMe Cults) | Group-Object NegativeSign)
| ForEach-Object Name
| ForEach-Object {
    $hs.Add( $_ ) }


$forProp = [ordered]@{}
$allProps | ForEach-Object { $curProp = $_
    $curVal = (CacheMe Cults).NumberFormat.$CurProp
    $forProp[ $CurProp ] = $curVal
}


return
# 127



# 141
(CacheMe Cults).NumberFormat
# 142
(CacheMe Cults)[0].NumberFormat


# 143
(CacheMe Cults)[0].NumberFormat.psobject.properties


# 144
(CacheMe Cults)[0].NumberFormat.psobject.properties | Format-Table


# 145
(CacheMe Cults)[0].NumberFormat.psobject.properties.name


# 146
(CacheMe Cults)[0].NumberFormat.psobject.properties.name | Sort-Object -Unique


# 147
$allProps = (CacheMe Cults)[0].NumberFormat.psobject.properties.name | Sort-Object -Unique


# 148
$allProps | ForEach-Object { $curProp = $_
   (CacheMe Cults)[0].NumberFormat.$CurProp
}


# 149
$allProps | ForEach-Object { $curProp = $_
   (CacheMe Cults).NumberFormat.$CurProp
}


# 150
$forProp = [ordered]@{}
$allProps | ForEach-Object { $curProp = $_
    $curVal = (CacheMe Cults).NumberFormat.$CurProp
    $forProp[ $CurProp ] = $curVal
}


# 151
$forProp


# 152
$forProp | ForEach-Object {
    h1 $_.name }


# 153
$forProp | ForEach-Object {
    h1 $_.key
}


# 154
$forProp | ForEach-Object {
    $_
}


# 155
$forProp[0] | ForEach-Object {
    $_
}


# 156
$forProp | ForEach-Object {
    $_
}


# 157
$forProp.getEnumerator() | ForEach-Object {
    $_
}


# 158
$forProp.getEnumerator() | ForEach-Object {
    $_.key
}


# 159
$forProp.getEnumerator() | ForEach-Object {
    $_.Name
}


# 160
$forProp.getEnumerator() | ForEach-Object {
    $_.Name
    $_.Value
}


# 161
$forProp.getEnumerator() | ForEach-Object {
    $_.Name
    $_.Value | Sort-Object -Unique
}


# 162
$forProp.getEnumerator() | ForEach-Object {
    $_.Name
    $_.Value.GetType()
}


# 163
$forProp.getEnumerator() | ForEach-Object {
    $_.Name
    $_.Value | Join-String -sep '🐒' Sort-object -Unique
}


# 164
$forProp.getEnumerator() | ForEach-Object {
    $_.Name
    $_.Value | Join-String -sep '🐒'
}


# 165
$forProp.getEnumerator() | ForEach-Object {
    $_.Name
    $_.Value | ForEach-Object { $_ }
}


# 166
$forProp.getEnumerator() | ForEach-Object {
    $_.Name
    $_.Value | ForEach-Object { $_ } | Sort-Object -Unique
}


# 167
$forProp.getEnumerator() | ForEach-Object {
    $_.Name
    $_.Value | ForEach-Object { $_ } | Sort-Object -Unique | Join-String -sep '-'
}


# 168
$forProp.getEnumerator() | ForEach-Object {
    $_.Name
    $_.Value | ForEach-Object { $_ } | Sort-Object -Unique | Join-String -sep '🐒'
}


# 169
Get-History


# 170
Get-History | ForEach-Object {
    $_.Id | Join-String -f '# {0}'
    $_.CommandLine
    "`n"
}
