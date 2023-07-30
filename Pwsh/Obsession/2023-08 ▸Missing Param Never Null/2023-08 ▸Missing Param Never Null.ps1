write-warning 'to copy to dotils something' # 2023-07-20

# Original case where never null
function MaybeParams? {
    param( [int]$Count )
    $null -eq $Count
    $Count.GetType() | Format-ShortSciTypeName
}
MaybeParams?
MaybeParams? -Count $null

'
TLDR:
    undeclared parameters are falsy
    but they are not null

    To check if true null exist during parameterbinding
    then after parameter binding, even nulls will not be true null value type


future:
    - [ ] what if parameters are [Nullable<T>]]
'

function __maybeNullDefaults {
    [OutputType([string])]
    param( [string]$text, [int]$Count  )
    $Text  ??= '-'
    $Count ??= 70
    $Text * $Count -join ''

}

# to save 2023-07-20
function showParams {
    # future just use call stack or my invocation info
    [CmdletBinding()]
    param(
        # [System.Management.Automation.InvocationInfo]
        [Parameter(mandatory, Position = 0)]
        $MyInvo,

        [ArgumentCompletions(
            'Json',
            'Json.SingleLine',
            'Yaml'
        )]
        [Alias('Style', 'Format')]
        [Parameter(Mandatory, position = 1)]
        [string]$OutputStyle = '$.SingleLine'
    )
    [string]$funcNameStr =
        $MyInvo.MyCommand.Name
        | Join-String -f 'fn <{0}>'

    [string]$invokeName =
        $MyInvo.InvocationName

    [string]$fromPSCommandPathStr = $myInvo.PSCommandPath

    [string]$FromFileStr = $MyInvo.ScriptName

    [string]$fromLineStr = $myInvo.Line



    <#
    $myInvo
        isA: [sma.InvocationInfo]
        isA:
    $myInvo.BoundParameters
        isA: [Dictionary<string, object>]
        isA: [sma.PSBoundParametersDictionary]
    $myInvo.UnboundArguments
        isA: [List<object>]
        isA: [sma.PSBoundParametersDictionary]

    $MyInvo.psobject.properties | %{
   $_.Name, $_.TypeNameOfvalue | Join-String -sep ' ⇒ ' }
    #>
    $Json0 = @{ Depth = 0 ; WarningAction = 'ignore' }
    $Json2 = @{ Depth = 2 ; WarningAction = 'ignore' }

    switch($OutputStyle) {
        'Json.SingleLine' {
            $PSCmdlet.MyInvocation.BoundParameters
                | ConvertTo-Json @json0
                | Join-String -op "${funcNameStr}`n" -os "`n"
                | write-verbose -verbose
            break
        }
        'Json' {
            $PSCmdlet.MyInvocation.BoundParameters
                | ConvertTo-Json @json0 -Compress
                | Join-String -op "${funcNameStr}`n"
                | write-verbose -verbose
            break
        }
        'Yaml' {
            $PSCmdlet.MyInvocation.BoundParameters
                | ConvertTo-Yaml
                | Join-String -op "${funcNameStr}`n"
                | write-verbose -verbose
            break
        }
        default {
            throw "unknown output style: $OutputStyle"
        }
    }
}

function writeSomething? {
    <#
    (insert Don't-do-this-at-home, disclamimer)
    #>
    [CmdletBinding()]
    param(
        [string]$Text?,
        [int]$Number?
    )
    'something? '
    $PSCmdlet.MyInvocation.BoundParameters
        | ConvertTo-Json -Depth 0 -Compress
        | Join-String -op 'Func: '
        | write-verbose -verbose
    $null -eq $Text?
    $null -eq $Number?

    showParams -MyInvo $PSCmdlet.MyInvocation -OutputStyle Json
    #.BoundParameters
}

@'
What Types is a PSCmdlet?

in [0]:
    $PSCmdlet.pstypenames
    | Join-string -sep "`n" -SingleQuote | cl

out[0]:
    'sma.PSScriptCmdlet'
    'sma.PSCmdlet'
    'sma.Cmdlet'
    'sma.Internal.InternalCommand'

in [1]:
    $PSCmdlet.MyInvocation.pstypenames
        | Join-string -sep "`n" -SingleQuote | cl

out[1]:
    'System.Management.Automation.InvocationInfo'

# more fun
    $MyInvocation.MyCommand.ScriptBlock.Ast |json -Depth 5
    $MyInvocation.MyCommand.ScriptBlock.Ast |json -Depth 1

'@


writeSomething? -Text? 'hello' -Number? 34
writeSomething? -Text? $Null -Number? 20
writeSomething? -Number? 10
writeSomething?
'done'