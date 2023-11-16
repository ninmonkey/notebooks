<#
see more:
    https://gist.github.com/StartAutomating/d75cd9eaccfea1b50bc6523256e539a5
#>
function InspectSelf {
    [CmdletBinding()]
    param()
}

function InspectOther {
    <#
    https://learn.microsoft.com/en-us/dotnet/csharp/advanced-topics/reflection-and-attributes/attribute-tutorial
    #>
    [CmdletBinding()]
    param(
        [Parameter( # ValueFromPipelineByPropertyName,
            Mandatory, ValueFromPipeline )]
        [Alias( # 'Ast', 'ScriptBlock'
        )]$InputObject
    )

    $command = $InputObject | Dotils.Resolve.Command
    if(-not $Command) {
        throw [ArgumentException]::new(
        <# message: #> ('Unable to resolve object type: {0}' -f ( $InputObject | Format-ShortTypeName )),
        <# paramName: #> 'InputObject')
    }
    $command | Join-String -op ' Resolved => ' | write-verbose -verb
}
function dbg.ShowError {
    $id = 0
    $global:error | %{ $curErr = $_
        hr
        h1 ($id++)
        $curErr.CategoryInfo                 ?? '␀' | Label 'Category'
        $curErr.FullyQualifiedErrorId        ?? '␀' | Label 'FullQualId'
        $curErr.TargetObject                 ?? '␀' | label 'TargetObj'
        $curErr.InvocationInfo | Select *command*, *parameters*, *argumen* | Ft
        $curErr
    }
    hr
    h1 'manual'

    $global:error | %{ $_.Exception.ToString() }
         | Join-String -sep (hr 1)
    hr 1
    $global:error | %{ $_.Exception.ToString() }
        | Dotils.Write-DimText
        | Join-String -sep (hr 1)


}

$global:error.clear()
gcm 'label' | InspectOther
'label'  | InspectOther
'bad-command' | InspectOther

dbg.ShowError