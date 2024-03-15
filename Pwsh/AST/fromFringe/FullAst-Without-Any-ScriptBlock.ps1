using namespace System.Management.Automation.Language
<#

context
discord thread: <https://discord.com/channels/180528040881815552/447475598911340559/1213974060136927303>
    > Wait, how do you invoke an AST?
    ScriptBlockAst.GetScriptBlock()

this invokes scriptblock from AST without serializing it

related: <https://gist.github.com/SeeminglyScience/2f38c96a09d63f3bdac4d37781e8d9c7>
#>

$ep = [ScriptPosition]::new(0, 0, 0, '', '')
$ee = [ScriptExtent]::new($ep, $ep)

$commandAst = [CommandAst]::new(
    $ee,
    [CommandElementAst[]](
        [StringConstantExpressionAst]::new(
            $ee, 'Write-Host', 'BareWord'),
        [StringConstantExpressionAst]::new(
            $ee, 'hi!', 'BareWord')),
    [TokenKind]::Ampersand,
    [array]::Empty[RedirectionAst]())

$pipelineAst = [PipelineAst]::new($ee, $commandAst)

$endBlock = [NamedBlockAst]::new(
    $ee,
    [TokenKind]::End,
    [StatementBlockAst]::new(
        $ee,
        [StatementAst[]]@($pipelineAst),
        [array]::Empty[TrapStatementAst]()
    ),
    <# unnamed: #> $true)

$sbAst = [ScriptBlockAst]::new(
    $ee,
    [array]::Empty[UsingStatementAst](),
    [array]::Empty[AttributeAst](),
    $null,
    $null,
    $null,
    $endBlock,
    $null,
    $null)

& $sbAst.GetScriptBlock()
