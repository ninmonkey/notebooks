
function IsBlank {
    <#
    .synopsis
        blank or not sugar. Test whether something is null, empty string, not empty but whitespace
    #>
    [CmdletBinding()]
    param(
        [Parameter()]$Obj,

        # this parameter will auto complete
        [Parameter()]
        [validateset('TrueNull', 'Empty', 'EmptyString', 'Whitespace')]
        $Mode = 'Whitespace'
    )
    switch( $Mode ) {
        'TrueNull' {    $null -eq $Obj }
        'Empty' {       [string]::IsNullOrEmpty( $Obj ) }
        'WhiteSpace' {  [string]::IsNullOrWhiteSpace( $Obj ) }
        'EmptyString' { $Obj -is [string] -and $Obj.Length -eq 0 }
        default { throw "ShouldNeverReach: Unhandled Mode: $Mode" }
    }
}

#examples

IsBlank $FakeObject TrueNull
IsBlank $FakeObject Empty
IsBlank '' Empty
IsBlank '' Whitespace
IsBlank '' TrueNull
IsBlank $Null TrueNull
IsBlank "`n" Whitespace
IsBlank "`n" Empty
