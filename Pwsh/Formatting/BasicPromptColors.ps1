
# your prompt can do anything that returns a single string
# multiline prompts work
# using this pattern ensures you return one string
function Prompt {
    @(
        'User> '
    ) -join ''
}

function Prompt {
    # using Pwsh7's builtin functions on $PSStyle for color
    $C = @{
        FgRed = '#ce6060'
        FgPath = '#a9cea7'
    }
    @(
        if( $error.count -gt 0 ) {
            $PSStyle.Foreground.FromRgb( $c.FgRed )
            $Error.count
            $PSStyle.Reset
            ' '
        }

        $PSStyle.Foreground.FromRgb( $c.FgPath )
        (Get-Location) -split '\\' | Select -Last 3  | Join-String -sep ' > '
        $PSStyle.Reset
        "`n🐒> "

    ) -join ''
}
