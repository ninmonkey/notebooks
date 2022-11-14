using namespace System.Management.Automation
using namespace System.Management.Automation.Language

class ValidateCustomSet : ValidateEnumeratedArgumentsAttribute {
    static [string[]] $Set = 'Mercury', 'Venus', 'Earth', 'Mars', 'Jupiter', 'Saturn', 'Uranus', 'Neptune', 'Pluto'
    [string] $ErrorMessage

    [void] ValidateElement([object] $Element) {
        if(-not $this.ErrorMessage) {
            $this.ErrorMessage = "'{0}' is not in set! Valid Values '{1}'"
        }

        if($Element -notin [ValidateCustomSet]::Set) {
            throw [MetadataException]::new(
                [string]::Format(
                    $this.ErrorMessage,
                    $Element, ([ValidateCustomSet]::Set -join ', ')
                )
            )
        }
    }
}

function Test-Set {
    [CmdletBinding()]
    param(
        [Parameter()]
        [ValidateCustomSet(
            ErrorMessage = 'Invalid Value: {0}. Must be one of the following: {1}.'
        )]
        # [string] $Item = ([ValidateCustomSet]::Set | OGV -PassThru)
        [string] $Item = ([ValidateCustomSet]::Set )
    )

    $Item
}

Test-Set
