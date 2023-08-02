
# Note, when using module imports, the 'script:' scope
# is essentialy now a 'module' scope, even though technically there isn't a scope named that
# the user will not see any script or local scoped variables
$script:MintilsConfig = @{
    SomeState = 'stuff'
}

function Test-IsBlank {
    <#
    .synopsis
        Check if a string is essentially blank. treat strings that only contain whitespace or ansi escapes as blanks
    #>
    param(
        [Alias('InputObject')]
        [AllowNull()]
        [AllowEmptyCollection()]
        [AllowEmptyString()]
        [Parameter(Mandatory, ValueFromPipeline)]
        [object]$String,

        # only treat true nulls as blank. non-nulls are false
        [Alias('Strict')]
        [switch]$TestIsTrueNull
    )
    if( $TestIsTrueNull ) {
        return $null -eq $string
    }

    return [string]::IsNullOrWhiteSpace( $String )
}