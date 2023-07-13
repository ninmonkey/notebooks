
function DoStuff {
    <#
    .description
        Should you do this? No.
        Can you? Yes.

        A single XOR says
            One or the other, but not neither and not both

        Multiple says
            not all, not none, allow any other combinations

        It gets messy though, when coercion is involved


    #>
    [CmdletBinding()]
    param(
        $Stuff, $Other, $A, $B
    )

    $PSCmdlet.MyInvocation.BoundParameters
        | ConvertTo-Json -Depth 0 -wa 'ignore' -Compress
        | Join-String -op 'Func: '
        | write-verbose

    $IsOk? =
        $PSBoundParameters['Stuff']     -xor
            $PSBoundParameters['Other'] -xor
            $PSBoundParameters['A']     -xor
            $PSBoundParameters['B']

    $IsSlightlyMoreOkay? =
        $PSBoundParameters.ContainsKey('Stuff')     -xor
            $PSBoundParameters.ContainsKey('Other') -xor
            $PSBoundParameters.ContainsKey('A')     -xor
            $PSBoundParameters.ContainsKey('B')

    $IsOk? | Join-String -f 'Are you Ok? {0}'
    $IsSlightlyMoreOkay? | Join-String -f 'Are you Slightly Ok? {0}'
}

<# examples #>
$PSDefaultParameterValues['DoStuff:Verbose'] = $true
# all
DoStuff 'a' 'b' 'c' 'd'
# None
DoStuff
# not all, not none
DoStuff 'a' 'b' 'e'
DoStuff 'a' 'b' 'e' ''
DoStuff -s '' -o '' -a '' -b ''
DoStuff -s '' -o '' -a '' -b ' '
