@'
Import-Module EditorServicesCommandSuite -Force
Import-CommandSuite -Verbose 
'@

if( -not (gcm -m pipescript -ea ignore)) {
    import-module PipeScript
}

$sourceList = 'ETS', 'MemberResolution', 'TypeConversion', 'TypeConversion','TypeMatch'
| sort -Unique


$A = "i*"
$now = get-date

Trace-Command -Option All -InputObject $now -PSHost -Name $SourceList -Expression {  
   $cur = $Input
   $cur.zyx = 10  
}


h1 'inspect: $Error[0] | Get-Error'
@'
                                at <ScriptBlock>, <No file>: line 1
    TargetSite  : System.Object CallSite.Target(System.Runtime.CompilerServices.Closure, System.Runtime.CompilerServices.CallSite, 
Int32)
    Message     : The property 'zyx' cannot be found on this object. Verify that the property exists and can be set.
    Data        : System.Collections.ListDictionaryInternal
    Source      : Anonymously Hosted DynamicMethods Assembly
    HResult     : -2146233087
    StackTrace  : 
   at CallSite.Target(Closure , CallSite , Object , Int32 )
   at System.Management.Automation.Interpreter.DynamicInstruction`3.Run(InterpretedFrame frame)
   at System.Management.Automation.Interpreter.EnterTryCatchFinallyInstruction.Run(InterpretedFrame frame)
CategoryInfo          : InvalidOperation: (:) [], RuntimeException
FullyQualifiedErrorId : PropertyAssignmentException
InvocationInfo        : 
    ScriptLineNumber : 14
    OffsetInLine     : 4
    HistoryId        : -1
    ScriptName       : C:\Users\cppmo_000\SkyDrive\Documents\2022\My_Github\notebooks\Pwsh\maybe-member-binding-trace.ps1
    Line             : $cur.zyx = 10

    PositionMessage  : At C:\Users\cppmo_000\SkyDrive\Documents\2022\My_Github\notebooks\Pwsh\maybe-member-binding-trace.ps1:14 cha
                       +    $cur.zyx = 10
                       +    ~~~~~~~~~~~~~
    PSScriptRoot     : C:\Users\cppmo_000\SkyDrive\Documents\2022\My_Github\notebooks\Pwsh
    PSCommandPath    : C:\Users\cppmo_000\SkyDrive\Documents\2022\My_Github\notebooks\Pwsh\maybe-member-binding-trace.ps1
    CommandOrigin    : Internal
'@

return
<#
the docs:

Trace-Command -Name metadata,parameterbinding,cmdlet -Expression {Get-Process Notepad} -PSHost


$A = "i*"
Trace-Command ParameterBinding {Get-Alias $Input} -PSHost -InputObject $A
#>