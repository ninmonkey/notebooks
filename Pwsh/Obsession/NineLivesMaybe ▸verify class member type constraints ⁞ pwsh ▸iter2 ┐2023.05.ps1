#Requires -Version 7.0

@'
# About

When do class member's type constraints apply?

not during the declaration
they are in c-tors, IfAndOnlyIf assigned to something in the c-tor
members not assigned are null, except type constraints don't prevent null at that point

So be careful with omitting properties when using the hashtable
    ctor: [class]@{ Name = Value }
or a ctor that never attempts an assignment.

Testing whether "[Nullable[datetime]]$When1" constraint stays
    or if it's lost because it's not actually constrained to non null
'@
function stat {
    param( $Obj )
    Hr | Write-Host
    $Obj | iot2 -NotSkipMost | Out-String | Write-Host
    # Hr | Write-Host
}
class Cat {
    [ValidateRange(1, 9)][int]$Lives
    [string]$Name

    [Nullable[datetime]]$When1
    [datetime]$When2
    [Collections.Generic.List[Cat]]$Kittens = @()

    Cat () {
        stat $This

        function Dump {
            param( [string]$Label )
            ($this.When1)?.GetType() ?? '␀' | Join-String -op "A${Label} " | Write-Host
        }
        function Dump2 {
            param( [string]$Label )
            ($this.When2)?.GetType() ?? '␀' | Join-String -op "B${Label} " | Write-Host
        }
        Dump '1-z'
        $this.When1 = Get-Date
        Dump '1a'
        $this.When1 = $null
        Dump '1b'
        $this.When1 = Get-Date
        Dump '1c'
        $this.When1 = $null
        Dump '1d'
        stat $this

        Dump2 '2a'
        try {
            $this.When2 = $null
        } catch {
            # ERror 0x1
        }
        Dump2 '2b'
        $this.When2 = Get-Date
        Dump2 '2c'

        Dump2 '2d'
        $this.When2 = $null
        Dump2 '2e'
        stat $this

        # ($this.When1)?.GetType() ?? '␀' | Join-String -op '1b: ' | Write-Host

        $this.When1.GetType() | Join-String -op '1c: ' | Write-Host

        stat $This

        $this.When2 = Get-Date
        $this.When2.GetType() | Join-String -op '2a: ' | Write-Host
        ($this.When2)?.GetType() ?? '␀' | Join-String -op '2b: ' | Write-Host
        try {
            $this.When2 = $null
        } catch {
            <# this throws err 0x1
            ThrowInvalidCastException
                Exception setting "When2": "Cannot convert null to type "System.DateTime"."
            #>

        }
        ($this.When1)?.GetType() ?? '␀' | Join-String -op '2c: ' | Write-Host
        $this.When2 = Get-Date
        ($this.When2)?.GetType() ?? '␀' | Join-String -op '2d: ' | Write-Host


        stat $This
        # $this.When2 = get-date
        # $this.When2.GetType() | out-host
        # $this.When2 = $null
        # $this.When2.GetType() | out-host
        # # $this.Lives = 0
        # $this.Kittens.GetType()
        ''
    }

    [string] ToString() {
        return '[Cat{ Name: {0}, Lives: {1}, Kittens: {2} }]' -f @(
            $This.Name ?? 'Bob'
            $this.Lives ?? 0
            $This.Kittens.Count ?? 0
        )

    }

}
# clear
Hr

function __mainTest {
    $C = [Cat]::New()
    $C
}

@'
## Error 0x1

Exception setting "When2": "Cannot convert null to type "System.DateTime"."

System.Management.Automation.SetValueInvocationException: Exception setting "When2": "Cannot convert null to type "System.DateTime"."
 ---> System.Management.Automation.PSInvalidCastException: Cannot convert null to type "System.DateTime".
   at System.Management.Automation.LanguagePrimitives.ThrowInvalidCastException(Object valueToConvert, Type resultType)
   at System.Management.Automation.LanguagePrimitives.ConvertNoConversion(Object valueToConvert, Type resultType, Boolean recurse, PSObject originalValueToConvert, IFormatProvider formatProvider, TypeTable backupTable)
   at CallSite.Target(Closure, CallSite, Object, Object)
   --- End of inner exception stack trace ---
   at System.Management.Automation.ExceptionHandlingOps.CheckActionPreference(FunctionContext funcContext, Exception exception)
   at System.Management.Automation.Interpreter.ActionCallInstruction`2.Run(InterpretedFrame frame)
   at System.Management.Automation.Interpreter.EnterTryCatchFinallyInstruction.Run(InterpretedFrame frame)
   at System.Management.Automation.Interpreter.EnterTryCatchFinallyInstruction.Run(InterpretedFrame frame)
   at System.Management.Automation.Interpreter.Interpreter.Run(InterpretedFrame frame)
   at System.Management.Automation.Interpreter.LightLambda.RunVoid1[T0](T0 arg0)
   at System.Management.Automation.ScriptBlock.InvokeWithPipeImpl(ScriptBlockClauseToInvoke clauseToInvoke, Boolean createLocalScope, Dictionary`2 functionsToDefine, List`1 variablesToDefine, ErrorHandlingBehavior errorHandlingBehavior, Object dollarUnder, Object input, Object scriptThis, Pipe outputPipe, InvocationInfo invocationInfo, Object[] args)
   at System.Management.Automation.ScriptBlock.InvokeWithPipe(Boolean useLocalScope, ErrorHandlingBehavior errorHandlingBehavior, Object dollarUnder, Object input, Object scriptThis, Pipe outputPipe, InvocationInfo invocationInfo, Boolean propagateAllExceptionsToTop, List`1 variablesToDefine, Dictionary`2 functionsToDefine, Object[] args)
   at System.Management.Automation.ScriptBlock.InvokeAsMemberFunction(Object instance, Object[] args)
   at System.Management.Automation.Internal.ScriptBlockMemberMethodWrapper.InvokeHelper(Object instance, Object sessionStateInternal, Object[] args)
   at CallSite.Target(Closure, CallSite, Type)
   at System.Dynamic.UpdateDelegates.UpdateAndExecute1[T0,TRet](CallSite site, T0 arg0)
   at System.Management.Automation.Interpreter.DynamicInstruction`2.Run(InterpretedFrame frame)
   at System.Management.Automation.Interpreter.EnterTryCatchFinallyInstruction.Run(InterpretedFrame frame)

'@ |  new-text -fg '#b48606' -bg '#401e68' | % toString

__mainTest