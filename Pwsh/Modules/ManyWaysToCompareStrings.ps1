# string compare types
$Sample = @{}
$Sample.A1 = '.NL'
$Sample.A2 = '.nl'
# return
$Left  = $Sample.A1
$Right = $Sample.A2

$Left.EndsWith( $Right )
# $Left.EndsWith( $Right, [StringComparison]::

$Tests = [ordered]@{
# $Tests.EndsWith_asMember_CI_Invariant = {
    # $Sample.A1.EndsWith
    Left = $Left
    Right = $Right
    CompareOptions = [System.StringComparison]|fime| Join-String -sep ', ' Name
    'Left.EndsWidth( Right )' =
        $Left.EndsWith(<# value: #> $Right)


    # b = $Sample.A1.EndsWith(
    #     <# value: #> $value,
    #     <# comparisonType: #> $comparisonType)
    # EndsWith_asMember_Ignore_Invariant =
    #     $Sample.A1.EndsWith(
    #         <# value: #> $value,
    #         <# ignoreCase: #> $true,
    #         <# culture: #> $null)
    # EndsWith_asMember_NoIgnore_Invariant =
    #     $Sample.A1.EndsWith(
    #         <# value: #> $value,
    #         <# ignoreCase: #> $false,
    #         <# culture: #> $null)
}
[String]::Compare('.NL', '.nl', [StringComparison]::CurrentCultureIgnoreCase )
$Sample.A1.EndsWith( $Sample.A2, $false, $null)
$Sample.A1.EndsWith( $Sample.A2, $true, $null)
# $CompareType =

function Foo {
        [Parameter(Mandatory, ValueFromPipeline)]
        [Alias('Str', 'Text', 'InStr', 'Content')]
        [object] $InputObject
}

function Str.EndsWith {
    param(
        [Parameter(Mandatory, ValueFromPipeline)]
        [Alias('Str', 'Text', 'InStr', 'Content')]
        [string] $InputText,

        [string] $Substring,

        [Parameter( Mandatory,
            ParameterSetName = 'ParamStringCompareType')]
        [Alias('CompareType', 'Type')]
        [System.StringComparison] $ComparisonType,

        [Parameter( Mandatory,
            ParameterSetName = 'ParamCaseSensitive')]
        [Alias('AsCS', 'CS', 'CaseSensitive', 'UsingCS')]
        [switch] $UsingCaseSensitive,

        # this function only accepts culture when using ignoreCase version
        [Parameter( Mandatory,
            ParameterSetName = 'UsingCaseSensitive')]
        [CultureInfo]$Culture = [CultureInfo]::InvariantCulture
        # ,$CultInfo

    )

    switch($PSCmdlet.ParameterSetName) {
        'ParamStringCompareType' {
            return $InputText.EndsWith(
                <# values #> $SubString,
                <# StringComparison #> $ComparisonType
             )
        }
        'UsingCaseSensitive' {
            return $InputText.EndsWith(
                <# value      #> $SubString,
                <# ignoreCase #> $UsingCaseSensitive,
                <# Culture    #> $Culture
            )
        }
        default {
            throw 'ShouldNeverReachException?'
            $CompareType = if($CaseSensitive) {
                [StringComparison]::InvariantCulture
            } else{
                [StringComparison]::InvariantCultureIgnoreCase
            }}
    }
    <#
    EndsWith( string value )
    EndsWith( string value, StringComparison comparisonType )
    EndsWith( string value, bool ignoreCase, CultureInfo culture )
    EndsWith( char value )
    #>
    throw 'ShouldNeverReachException'

}

h1 'Related Types'
@(
    [System.CultureAwareComparer]
    [System.Globalization.CompareOptions]
    [System.StringComparer]
    [System.StringComparison]
    [System.Globalization.CultureInfo]
)

h1 'Semi-related types'
@(
    [Microsoft.PowerShell.Commands.GetCultureCommand]
    [Microsoft.PowerShell.Commands.GetUICultureCommand]
    [Microsoft.PowerShell.Commands.ValidateCultureNamesGenerator]
    [Microsoft.PowerShell.Commands.ValidateMatchStringCultureNamesGenerator] # is [IvalidateSetValuesGenerator]
    [System.ComponentModel.CultureInfoConverter]
    [System.Globalization.CultureTypes]
    [System.IFormatProvider]
) | Ft

h1 '$Str.A | Fime'

$Sample.A1 | fime Compare

h1 '"str" | Fime'
'dsfs' | Fime Compare

$Tests.GetEnumerator() | %{
    h1 $_.Key
    $_.Value
}
