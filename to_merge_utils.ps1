
[string[]]$NameList = 12, '34' # coerces to string
[object[]]$AnyList = 12, '34'

[Collections.Generic.List[string]]$list = 12, '34'
@{
    ElementTypes = $List | ForEach-Object GetType | Join-String Name -sep ', '
    SelfType     = , $List | ForEach-Object GetType | Join-String Name -sep ', '
}
# hr
$list | ForEach-Object GetType | ForEach-Object Name
, $list | ForEach-Object GetType | ForEach-Object Name
# hr
[Collections.Generic.List[int]]$list = '3.14', 0x2345
# hr
$list | ForEach-Object GetType | ForEach-Object Name
, $list | ForEach-Object GetType | ForEach-Object Name

<#
Notebook utilites. Designed to be terse commands ran in notebooks. Ie: They don't follow best practices, or style guidelines

Currently not used in the examples because I didn't want to abstract things
    making it harder to see what's going on.

#>
function str.Type {
    <#
    .synopsis
        render an objects type as a short name
    #>
    param(
        [switch]$WithNamespace,
        [Parameter(Mandatory, ValueFromPipeline)]
        $InputObject
    )
    process {
        if ($null -eq $InputObject) { return '<trueNull>' }
        # $tinfo = if($InputObject -is 'type') {
        #     $InputObject
        # } else {
        #     ($InputObject)?.GetType()
        # }
        $tinfo = $InputObject.GetType()


        if (-not $WithNamespace) {
            return $tinfo.GetType().Name
        }
        # ((,$_.GetType()).ToString()) -replace '\bSystem\.', ''
        # ((,$_.GetType()).ToString()) -replace '\bSystem\.', ''
    }
}

'....'
$NameList | str.Type
str.Type $NameList
, $NameList | str.Type -WithNamespace
'....'
# $list.ToString()
