@'
filter presets to drop keys
- [ ]   [System.Management.Automation.PSCmdlet]::CommonParameters
- [ ] [System.Management.Automation.PSCmdlet]::OptionalCommonParameters
- [ ] drop blank keys/props
- [ ] drop whitespace keys/props
'@


function pk.Assert.Truthy {
    [Alias(
        'pk.Test.Truthy',
        'pk.Assert.Truthy',
        'pk.Is.Truthy'
    )]
    param(
        [AllowEmptyCollection()]
        [AllowEmptyString()]
        [AllowNull()]
        [Parameter(Mandatory)]
        [object]$InputObject,

        # return a bool instead of throwing
        [Alias('TestOnly', 'AsError')]
        [switch]$AsBool,

        [switch]$IsNot
    )
    # if($MyInvocation.MyCommand.Name -match '\btest\b|\bis\b'){
    if(
        ( $MyInvocation.MyCommand.Name -match '\btest\b|\bis\b' ) -and
        ( $MyInvocation.MyCommand.Name -notmatch 'assert' )
    ){
        $AsBool = $True
    }
    $isTruthy = [bool]$InputObject
    $IsNotTruthy = -not [bool]$InputObject

    if($AsBool) {
        if( $IsNot ) { return -not $IsTruthy }
        else { return $isTruthy}
    }
    if( -not $isTruthy ) {
        [System.ArgumentException]::new(
        <# paramName: #> 'InputObject',
        <# message: #> 'Was not truthy')
    }
}

function pk.Assert.IsTypeInfo {
    param(
        [AllowEmptyCollection()]
        [AllowEmptyString()]
        [AllowNull()]
        [Parameter(Mandatory)]
        [object]$InputObject,

        # return a bool instead of throwing
        [Alias('TestOnly', 'AsError')]
        [switch]$AsBool
    )
    $test = $InputObject -is 'type'
    if($AsBool) {
        return $test
    }
    if(-not $test) {
        throw [System.ArgumentException]::new(
        <# paramName: #> 'InputObject',
        <# message: #> 'Was not a typeInfo')
    }
}
function pk.Assert.IsArray {
    param(
        [AllowEmptyCollection()]
        [AllowEmptyString()]
        [AllowNull()]
        [Parameter(Mandatory)]
        [object]$InputObject,

        # return a bool instead of throwing
        [Alias('TestOnly', 'AsError')]
        [switch]$AsBool
    )
    $Tinfo = $InputObject.GetType()
}
function pk.Assert.NotEmpty.List {
    param(
        [AllowEmptyCollection()]
        [AllowEmptyString()]
        [AllowNull()]
        [Parameter(Mandatory)]
        [object]$InputObject,

        # return a bool instead of throwing
        [Alias('TestOnly', 'AsError')]
        [switch]$AsBool
    )
    if( $MyInvocation.InvocationName -in @('pk.Test.NotTrueNull')) {
        $Asbool = $true
    }

}
function pk.Assert.NotTrueNull {
    <#
    .EXAMPLE
    #>
    [Alias('pk.Test.NotTrueNull')]
    param(
        # anything
        [AllowEmptyCollection()]
        [AllowEmptyString()]
        [AllowNull()]
        [Parameter(Mandatory)]
        [object]$InputObject,

        # return a bool instead of throwing
        [Alias('TestOnly', 'AsError')]
        [switch]$AsBool
    )
    if( $MyInvocation.InvocationName -in @('pk.Test.NotTrueNull')) {
        $Asbool = $true
    }
    $isNull = $Null -eq $InputObject
    if( $AsBool ) {
        return $IsNull
    }

    if( $IsNull ) {

        throw [System.ArgumentNullException]::new(
        <# paramName: #> 'InputObject',
        <# message: #> 'Was Null')
    }
}
function PickKeys {
# this function will create a new object with specific keys from the input object
function Select-Keys {
    param(
        [Parameter(Mandatory)]
        [object]$InputObject,

        [Parameter(Mandatory)]
        [Alias('Keys', 'Include')]
        [string[]]$KeyName,

        # mandatory else errors
        [Parameter()]
        [Alias('Keys', 'Include')]
        [string[]]$RequiredKeys
    )

    # create a new ordered dictionary object
    $selected = [ordered]@{}

    # iterate over each key name
    foreach($key in $KeyName) {

        # if the key name exists in the input object
        if($InputObject.psobject.properties.name -contains $key) {

            # add the key and associated value to the new object
            $selected.Add($key, $InputObject.$key)
        }
    }

    # if there are required keys
    if($RequiredKeys) {

        # iterate over each required key
        foreach($key in $RequiredKeys) {

            # if the key name exists in the input object
            if($InputObject.psobject.properties.name -contains $key) {

                # add the key and associated value to the new object
                $selected.Add($key, $InputObject.$key)
            }

            # if the key name does not exist in the input object
            else {

                # throw an error message
                $msg = "Required key '$key' not found in input object."
                throw $msg
            }
        }
    }

    # return the new object
    return $selected
}

}

function TryDropParams {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        $Text
    )


}