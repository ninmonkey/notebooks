class CustomCompleter : ArgumentCompleterAttribute {
    [string]$Param1
    [string]$Param2

    CustomCompleter([string]$Param1, [string]$Param2) {
        $this.Param1 = $Param1
        $this.Param2 = $Param2
    }

    [IEnumerable[CompletionResult]] CompleteArgument(
        [string] $commandName,
        [string] $parameterName,
        [string] $wordToComplete,
        [CommandAst] $commandAst,
        [IDictionary] $fakeBoundParameters) {

        # Mimic ArgumentCompletions
        $completions =
            [ArgumentCompletions]::GetArgumentCompletionResults(
                $wordToComplete, $commandAst, $fakeBoundParameters )

        return $completions

        # return [CompletionResult[]](foreach ($completion in $completions) {
        #     [CompletionResult]::new(
        #         $completion.CompletionText,
        #         $completion.ToolTip)
        # })
    }
}

function ExampleFunction {
    param(
        [CustomCompleter(
            'param1Value',
            'param2Value')
        ][string]$Parameter
    )
    $PSBoundParameters | Json
    # Function body
}
function CompleteWithNewline {
    <#
    .SYNOPSIS
        depending on line endings, you cant even escape the \r chars as literals because of limitations
    #>
    param(
        [ArgumentCompletions(
            '@{
    Fg = "#f91134"
    Join = ", "
            }'
#             ('@{
# }' -replace '\r', '')
        )][hashtable]$Options
    )
    $Config = nin.MergeHash -other $Options -BaseHash @{
        Fg = '#30645f'
        Join = ' -- '
    }

    Get-Process
        | Get-Random -count 10
        | New-Text -fg $Config.Fg
        | Join-String -sep $Config.Join
}

function ExampleProblem {
    <#
    .SYNOPSIS
        depending on line endings, you cant even escape the \r chars as literals because of limitations
    #>
    param(
        [ArgumentCompletions(
            '@{
    Fg = "#f91134"
    Join = ", "
            }'
#             ('@{
# }' -replace '\r', '')
        )][hashtable]$Options
    )
    $Config = nin.MergeHash -other $Options -BaseHash @{
        Fg = '#30645f'
        Join = ' -- '
    }

    Get-Process
        | Get-Random -count 10
        | New-Text -fg $Config.Fg
        | Join-String -sep $Config.Join
}

function Func.WithOptions {
    param(
        # Expects keys: GenComplements: bool, GenHighContrastComplements: bool
        [ArgumentCompletions(
            '@{ GenerateHighContrastComplements = $true ; GenerateComplements = $true }',
            '@{
GenerateHighContrastComplements = $true
GenerateComplements = $true }',

            '@{
GenerateHighContrastComplements = $true
GenerateComplements = $true
}'
        )]
        [hashtable]$Options,
        [switch]$BaseColorsOnly
    )

    $Options|ConvertTo-Json | Join-String -op 'Opts: ' | Write-verbose -verb
}
