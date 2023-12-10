using namespace System.Collections.Generic
using namespace System.Management.Automation
using namespace System.Management
using namespace System.Text


function Td.New.CompletionResult {
    # from Bintils.Common.psm1
    [Alias(
        'New.Completion',
        'Td.CompletionResult',
        'Td.New.CR'
    )]
    param(
        # original base text
        [Alias('Item', 'Text')]
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNullOrWhiteSpace()]
        [string]$ListItemText,

        # actual value used in replacement, if not the same as ListItem
        [AllowEmptyString()]
        [AllowNull()]
        [Alias('Replacement', 'Replace')]
        [Parameter()]
        [string]$CompletionText,

        # Is there a better default?
        [Parameter()]
        [CompletionResultType]
        $ResultType  = ([CompletionResultType]::ParameterValue),

        # multi-line text displayed when using listcompletion
        [Parameter()]
        [Alias('Description', 'Help', 'RenderText')]
        [string[]]$Tooltip
    )
    [System.ArgumentException]::ThrowIfNullOrWhiteSpace( $ListItemText , 'ListItemText' )

    $Tooltip =  $Tooltip -join "`n"
    if( [string]::IsNullOrEmpty( $Tooltip )) {
        $Tooltip = '[⋯]'
    }
    if( [string]::IsNullOrEmpty( $CompletionText )) {
        $CompletionText = $ListItemText
    }
    [CompletionResult]::new(
        <# completionText: #> $completionText,
        <# listItemText  : #> $listItemText,
        <# resultType    : #> $resultType,
        <# toolTip       : #> $toolTip)
}

function Td.Example.NewUser1 {
    [Alias('Td.Try1')]
    param(
        [string]$Name, [int]$Id
    )
    $PSBoundParameters | Json | write-host -fg 'salmon' -bg 'gray20'
}
function Td.Example.NewUser2 {
    [Alias('Td.Try2')]
    param(
        [string]$Name, [int]$Id
    )
    $PSBoundParameters | Json | write-host -fg 'salmon' -bg 'gray20'
}

function New-CompletionTemplate {
    [CmdletBinding()]
    [Alias(
        'Td.Example.Completion',
        'Td.Complete.Template'
    )]
    [OutputType(
        'System.Management.Automation.CompletionResult[]'
    )]
    param(
        [string]$TemplateName
    )

    [List[CompletionResult]]$Completions = @()
    return @(
        Td.New.CR -ResultType ParameterName -ListItemText 'Name' -CompletionText '-Name' -Tooltip ''
        Td.New.CR -ResultType ParameterValue -ListItemText 'Bob' -CompletionText 'Bob' -Tooltip ''
    )
    # Td.New.CR -ListItemText 'Example' -CompletionText '' -ResultType 'ParameterValue' -Tooltip ''
    switch($TemplateName) {
        '1' {
            $Completions.AddRange( [CompletionResult[]]@(
                Td.New.CR -ResultType ParameterName -ListItemText 'Name' -CompletionText '-Name' -Tooltip ''
                Td.New.CR -ResultType ParameterValue -ListItemText 'Bob' -CompletionText 'Bob' -Tooltip ''
                Td.New.CR -ResultType ParameterName -ListItemText 'Id' -CompletionText '-Id' -Tooltip ''
                Td.New.CR -ResultType ParameterValue -ListItemText '123' -CompletionText '123' -Tooltip ''

                # Td.New.CR -ResultType ParameterValue -ListItemText 'Where.First' -CompletionText ('[WhereOperatorSelectionMode]::First') -Tooltip 'as string inline?'
                # Td.New.CR -ResultType ParameterValue -ListItemText 'Where.Last' -CompletionText [WhereOperatorSelectionMode]::Last -Tooltip 'as as enum?'
                # next, example uses enum as (value) like [Td.Example.NewUser1]
                # Td.New.CR -ResultType ParameterValue -ListItemText '123' -CompletionText '123' -Tooltip ''
            ))
        }
        '2' {
            $Completions.AddRange( [CompletionResult[]]@(
                Td.New.CR -ResultType ParameterName -ListItemText 'Name' -CompletionText '-Name' -Tooltip ''
                Td.New.CR -ResultType ParameterValue -ListItemText 'Bob' -CompletionText 'Bob' -Tooltip ''
                Td.New.CR -ResultType ParameterName -ListItemText 'Id' -CompletionText '-Id' -Tooltip ''
                Td.New.CR -ResultType ParameterValue -ListItemText '123' -CompletionText '123' -Tooltip ''

                Td.New.CR -ResultType ParameterValue -ListItemText 'Where.First' -CompletionText ('[WhereOperatorSelectionMode]::First') -Tooltip 'as string inline?'
                Td.New.CR -ResultType ParameterValue -ListItemText 'Where.Last' -CompletionText [WhereOperatorSelectionMode]::Last -Tooltip 'as as enum?'
                # next, example uses enum as (value) like [Td.Example.NewUser1]
                # Td.New.CR -ResultType ParameterValue -ListItemText '123' -CompletionText '123' -Tooltip ''
            ))
        }
        default {
            "throw: UnhandledTemplateName"
        }
    }

    return $Completions
}

function MyArgumentCompleter1 {
    <#
    .notes
        - Uses all completions, no filter
        - examples
            name => -name
        - it hides 'name' when '-name' is already there
            - but still tab completes multiple '-name's


    #>
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameter)

    [List[CompletionResult]]$Completions = @(  New-CompletionTemplate -TemplateName 1 )
    return $Completions
}
function MyArgumentCompleter2 {
    <#
    .notes
        v1 allowed completing already existing parameter names

    #>
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameter)
    [List[CompletionResult]]$Completions = @(  New-CompletionTemplate -TemplateName 2 )
    # wait-debugger
    return $Completions
}



function GetThings {
    [Alias('Td.Get')]
    param(

        [Parameter()]
        [object]$Echo
    )

    "   Was: $Echo" | write-host -bg 'darkblue'
}


Register-ArgumentCompleter -CommandName Td.Example.NewUser1 -ParameterName Name -ScriptBlock ${function:MyArgumentCompleter1}
Register-ArgumentCompleter -CommandName Td.Example.NewUser2 -ParameterName Name -ScriptBlock ${function:MyArgumentCompleter2}
# GetThings

Export-ModuleMember -Function @(
    'Td.*'
    'New-CompletionTemplate'
) -Alias @(
    'Td.*'
) -Variable @('Td_*')

'The functions are tied to different completers, try running

    > Td.Try1 name<tab>
    > Td.Try2 <menuComplete>
' | write-host -fg 'darkorange' -bg 'gray15'
