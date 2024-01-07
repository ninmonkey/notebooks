# First, the simple versions

function IsNull {
    # test for true null only. everything else is false
    [OutputType('System.Boolean')]
    param( $Object  )
    $null -eq $Object
}
function IsEmptyStr {
    # test for empty string only. everything else is false
    [OutputType('System.Boolean')]
    param( $Object  )
    ($Object -is [string]) -and $Object.length -eq ''
}
function IsBlank {
    [OutputType('System.Boolean')]
    param( $Object )
    [string]::IsNullOrWhiteSpace( $Object )
}

function Test-IsBlank {
    <#
    .synopsis
        Checks if an object is a true null. starting to get fancy
    .description
        Creates a table of different kinds of blankness
        - true null values
        - true empty string
        - strings with whitespace
    #>
    param(
        $Obj,
        # if true, the function returns a single boolean, no info
        [switch]$AsBool
    )
    $filtered = $Obj -replace "`a", '' # otherwise ascii bell is not "whitespace"
    if($AsBool) {
       return [string]::IsNullOrWhiteSpace( $filtered )
    }

    $isTrueNull     = $Null -eq $Obj
    $isStr          = $Obj -is [String]
    $isTrueEmptyStr = $isStr -and ($Obj.Length -eq 0)

    $finalLength = if(-not $IsTrueNull) { $Obj.ToString().Length }
    if($isTrueEmptyStr) { $finalLength = '<EmptyStr>' }
    if($IsTrueNull)     { $finalLength = '<null>'     }

    [pscustomobject]@{
        IsTrueNull     = $isTrueNull
        IsEmpty        = [string]::IsNullOrEmpty( $Obj )
        IsTrueEmptyStr = $isTrueEmptyStr
        IsBlank        = [string]::IsNullOrWhiteSpace( $filtered )
        Length         = $finalLength
        RawValue       = $Obj
        AsBool         = [string]::IsNullOrWhiteSpace( $filtered )
    }
}

<#
    $examples = $null, ' ' , ''
    $examples | %{
        IsNull $_
    } | Join-String -sep ', ' -op 'IsNull:     '
    
    # output
    # true, false, false
    
    $examples | %{
        IsEmptyStr $_
    } | Join-String -sep ', ' -op 'IsEmptyStr: '
    
    # output
    # false, false, true
    
    $examples | %{
        IsBlank $_
    } | Join-String -sep ', ' -op 'IsBlank:    '
    
    # output
    # true, true, true
#>
