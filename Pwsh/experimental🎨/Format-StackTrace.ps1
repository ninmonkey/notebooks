$Sample ??= @{}
$Regex ??= @{}
$Patterns = @(
    @{
        Pattern = [Regex]::Escape('System.Management.Automation.')
        Replacement = 'sma.'
    }
    @{
        Pattern = [Regex]::Escape('System.')
        Replacement = ''
    }
)

function Dotils.Format-StackTrace.iter0 {
    param(
      [string[]]$ScriptStackTrace
    )
}
throw 'script wip'
$Sample.StackTrace1 = @'
  at System.Management.Automation.CommandDiscovery.LookupCommandInfo(String commandName, CommandTypes commandTypes, SearchResolutionOptions searchResolutionOptions, CommandOrigin commandOrigin, ExecutionContext context)
   at System.Management.Automation.ExecutionContext.CreateCommand(String command, Boolean dotSource)
   at System.Management.Automation.PipelineOps.AddCommand(PipelineProcessor pipe, CommandParameterInternal[] commandElements, CommandBaseAst commandBaseAst, CommandRedirection[] redirections, ExecutionContext context)
   at System.Management.Automation.PipelineOps.InvokePipeline(Object input, Boolean ignoreInput, CommandParameterInternal[][] pipeElements, CommandBaseAst[] pipeElementAsts, CommandRedirection[][] commandRedirections, FunctionContext funcContext)

   at System.Management.Automation.Interpreter.ActionCallInstruction`6.Run(InterpretedFrame frame)
   at System.Management.Automation.Interpreter.EnterTryCatchFinallyInstruction.Run(InterpretedFrame frame)
'@ -replace '\r?\n', "`n"

$Sample.StackTrace2 = @'
Exception             :
    Type        : System.Management.Automation.CommandNotFoundException
    ErrorRecord :
        Exception             :
            Type    : System.Management.Automation.ParentContainsErrorRecordException
            Message : The term 'fetchOptions' is not recognized as a name of a cmdlet, function, script file, or
executable program.
                      Check the spelling of the name, or if a path was included, verify that the path is correct
and try again.
            HResult : -2146233087
        TargetObject          : fetchOptions
        CategoryInfo          : ObjectNotFound: (fetchOptions:String) [], ParentContainsErrorRecordException
        FullyQualifiedErrorId : CommandNotFoundException
        InvocationInfo        :
            ScriptLineNumber : 1
            OffsetInLine     : 46
            HistoryId        : 2
            Line             : [System.Diagnostics.DebuggerHidden()]param() fetchOptions
            PositionMessage  : At line:1 char:46
                               + [System.Diagnostics.DebuggerHidden()]param() fetchOptions
                               +                                              ~~~~~~~~~~~~
                               +                                              ~~~~~~~~~~~~
            InvocationName   : fetchOptions
            CommandOrigin    : Internal
        ScriptStackTrace      : at showParams, H:\data\2023\pwsh\notebooks\Pwsh\Obsession\2023-08 ▸Missing Param Never Null\2023-08 ▸Missing Param Never Null.ps1: line 69
                                at writeSomething?, H:\data\2023\pwsh\notebooks\Pwsh\Obsession\2023-08 ▸Missing Param Never Null\2023-08 ▸Missing Param Never Null.ps1: line 98
                                at <ScriptBlock>, H:\data\2023\pwsh\notebooks\Pwsh\Obsession\2023-08 ▸Missing Param Never Null\2023-08 ▸Missing Param Never Null.ps1: line 129
                                at <ScriptBlock>, <No file>: line 1
    CommandName : fetchOptions
    TargetSite  :
        Name          : LookupCommandInfo
        DeclaringType : System.Management.Automation.CommandDiscovery, System.Management.Automation, Version=7.3.5.500, Culture=neutral, PublicKeyToken=31bf3856ad364e35
        MemberType    : Method
        Module        : System.Management.Automation.dll
    Message     : The term 'fetchOptions' is not recognized as a name of a cmdlet, function, script file, or executable program.
                  Check the spelling of the name, or if a path was included, verify that the path is correct and try again.
    Data        : System.Collections.ListDictionaryInternal
    Source      : System.Management.Automation
    HResult     : -2146233087
    StackTrace  :
   at System.Management.Automation.CommandDiscovery.LookupCommandInfo(String commandName, CommandTypes commandTypes, SearchResolutionOptions searchResolutionOptions, CommandOrigin commandOrigin, ExecutionContext context)
   at System.Management.Automation.ExecutionContext.CreateCommand(String command, Boolean dotSource)
   at System.Management.Automation.PipelineOps.AddCommand(PipelineProcessor pipe, CommandParameterInternal[] commandElements, CommandBaseAst commandBaseAst, CommandRedirection[] redirections, ExecutionContext context)
   at System.Management.Automation.PipelineOps.InvokePipeline(Object input, Boolean ignoreInput, CommandParameterInternal[][] pipeElements, CommandBaseAst[] pipeElementAsts, CommandRedirection[][] commandRedirections, FunctionContext funcContext)

   at System.Management.Automation.Interpreter.ActionCallInstruction`6.Run(InterpretedFrame frame)
   at System.Management.Automation.Interpreter.EnterTryCatchFinallyInstruction.Run(InterpretedFrame frame)
TargetObject          : fetchOptions
CategoryInfo          : ObjectNotFound: (fetchOptions:String) [], CommandNotFoundException
FullyQualifiedErrorId : CommandNotFoundException
InvocationInfo        :
    ScriptLineNumber : 1
    OffsetInLine     : 46
    HistoryId        : 2
    Line             : [System.Diagnostics.DebuggerHidden()]param() fetchOptions
    PositionMessage  : At line:1 char:46
                       + [System.Diagnostics.DebuggerHidden()]param() fetchOptions
                       +                                              ~~~~~~~~~~~~
    InvocationName   : fetchOptions
    CommandOrigin    : Internal
ScriptStackTrace      : at showParams, H:\data\2023\pwsh\notebooks\Pwsh\Obsession\2023-08 ▸Missing Param Never Null\2023-08 ▸Missing Param Never Null.ps1: line 69
                        at writeSomething?, H:\data\2023\pwsh\notebooks\Pwsh\Obsession\2023-08 ▸Missing Param Never Null\2023-08 ▸Missing Param Never Null.ps1: line 98
                        at <ScriptBlock>, H:\data\2023\pwsh\notebooks\Pwsh\Obsession\2023-08 ▸Missing Param Never Null\2023-08 ▸Missing Param Never Null.ps1: line 129
                        at <ScriptBlock>, <No file>: line 1
'@ -replace '\r?\n', "`n"

<#
is
    at (NameOrAnonName)
    ,
    (Filepath)
    :\s
    line\s
    (LineNum)
#>
$Regex.FunctionOrAnonName = @'
(?x)
    (?<AnonSB>
        <ScriptBlock>
    )
    |
    # crazy amount would be valid, especially since it's a rendered string already
    (?<FunctionName>
        .+
    )
'@
$Regex.FullPathInline = @'

'@
$Sample.ShortenPathNames = @'
ScriptStackTrace      : at showParams, H:\data\2023\pwsh\notebooks\Pwsh\Obsession\2023-08 ▸Missing Param Never Null\2023-08 ▸Missing Param Never Null.ps1: line 69
                        at writeSomething?, H:\data\2023\pwsh\notebooks\Pwsh\Obsession\2023-08 ▸Missing Param Never Null\2023-08 ▸Missing Param Never Null.ps1: line 98
                        at <ScriptBlock>, H:\data\2023\pwsh\notebooks\Pwsh\Obsession\2023-08 ▸Missing Param Never Null\2023-08 ▸Missing Param Never Null.ps1: line 129
                        at <ScriptBlock>, <No file>: line 1
'@ -replace '\r?\n', "`n"

