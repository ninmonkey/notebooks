function transposeObject {
    <#
    .synopsis
        Takes a custom object, transposes (key, value) pairs
    #>
    [OutputType('System.Collections.Hashtable', 'System.Management.Automation.PSObject')]
    param(
        [Parameter(ValueFromPipeline, Mandatory)]
        [object]$InputObject,

        # Return a hashtables instead of object
        [switch]$AsHashtable
    )
    process {
        $tProp = @{} ;
        $Name = $_.Name; $Value = $_.Value

        $_ | iterProp | ForEach-Object {
            if ($null -eq $_.Value) {
                Write-Debug 'Value was null'
                return
            }
            $tProp[ $_.Value ] = $_.Name
        }
        if ($AsHashtable) {
            return $tProp ;
        }
        return [pscustomobject]$tProp
    }
}

function Get-ObjectProperty {
    <#
    .synopsis
        sugar for looping on '$x.psobject.properties'
    .example
        PS> get-date | prop | Ft Value, Name, TypeNameOfValue
    .example
        PS> Get-Item . | Prop | Ft Name, TypeNameOfValue, Value
    .example
        $query = Get-ComputerInfo
        $selected = $query | Prop | Out-GridView -PassThru
        $query | Select-Object -Prop $Selected.Name
            WindowsVersion BiosSMBIOSBIOSVersion
            -------------- ---------------------
            2009           0613
    #>
    [Alias('iterProp')]
    [OutputType([Management.Automation.PSMemberInfoCollection[Management.Automation.PSPropertyInfo]])]
    [cmdletbinding()]
    param(
        # Object to inspect
        [Parameter(Mandatory, ValueFromPipeline)]
        [object]$InputObject
    )
    process {
        $InputObject.psobject.properties
    }
}

$now = Get-Date
$now | iterProp | Format-Table -auto
# Get-ChildItem . | s -First 1 | transposeObject
