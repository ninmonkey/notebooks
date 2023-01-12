@'
see:
    - https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_intrinsic_members?view=powershell-7.3
    - https://learn.microsoft.com/en-us/powershell/scripting/learn/deep-dives/everything-about-pscustomobject?view=powershell-7.4#using-defaultpropertyset-the-long-way

example removing
    $myObject.psobject.properties.remove('ID')
'@



# function Get-MyObject
# {
#     [OutputType('My.Object')]
#     [CmdletBinding()]
#         param
#         (
#             ...

#             https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_intrinsic_members?view=powershell-7.3



function asDict {
    <#
    .SYNOPSIS
        Converts PSObjects to hashtables
    .EXAMPLE
        #ps | s -First 2 | fl -Force *

        ps | Select -first 3 | asDict -ExcludePropertyRegex '.*' -IncludePropertyRegex 'name', '64' -AsNewObject
    #>
    # [Alias('b.asDict')]
    [CmdletBinding()]
    [OutputType('System.Hashtable')]
    param(
        [Parameter(ValueFromPipeline, mandatory)]
        [object[]]$InputObject,

        # include property regex overrides any exlucded properties
        [string[]]$IncludePropertyRegex, # overrides exclusion
        # blacklist pattern regex
        [string[]]$ExcludePropertyRegex,

        [Alias('AsNewObject')]
        [switch]$PassThru,

        # should I explicit sort, or use ordered hashtable?
        [switch]$NoSortKeys
    )

    process {
        foreach ($Object in $InputObject) {
            $target = $Object
            if ($NoSortKeys) {
                $possible_names = $target.psobject.properties.name
                $props = @{}
            }
            else {
                $possible_names = $target.psobject.properties.name | Sort-Object
                $props = [ordered]@{}
            }
            foreach ( $curPropName in $possible_names) {
                # blacklist filter
                $shouldExclude = $false
                foreach ($regex in $ExcludePropertyRegex) {
                    if ($CurPropName -match $regex) {
                        $ShouldExclude = $true
                    }
                }
                # override blacklist
                foreach ($regex in $IncludePropertyRegex) {
                    if ($CurPropName -match $regex) {
                        $ShouldExclude = $false
                    }
                }
                if (-not $shouldExclude) {
                    $props[$curPropName] = $target.$curPropName
                }
            }
            if ($PassThru) {
                return [pscustomobject]$Props
            }
            $Props
        }
    }
}

Get-Item . | asDict -ExcludePropertyRegex 'link', 'name', 'date', 'time', 'path', '.*' -IncludePropertyRegex 'name'

#ps | s -First 2 | fl -Force *

Get-Process | Select-Object -First 3 | asDict -ExcludePropertyRegex '.*' -IncludePropertyRegex 'name', '64'
#ps | s -First 2 | fl -Force *

Get-Process | Select-Object -First 3 | asDict -ExcludePropertyRegex '.*' -IncludePropertyRegex 'name', '64' -AsNewObject

