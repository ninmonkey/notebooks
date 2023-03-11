'See types: '
[System.Management.Automation.PSTraceSource]
[System.Management.Automation.PSTraceSourceOptions]

'options'
[System.Management.Automation.PSTraceSourceOptions]::All
[System.Management.Automation.PSTraceSourceOptions]::Assert
[System.Management.Automation.PSTraceSourceOptions]::Constructor
[System.Management.Automation.PSTraceSourceOptions]::Data
[System.Management.Automation.PSTraceSourceOptions]::Delegates
[System.Management.Automation.PSTraceSourceOptions]::Dispose
[System.Management.Automation.PSTraceSourceOptions]::Error
[System.Management.Automation.PSTraceSourceOptions]::Errors
[System.Management.Automation.PSTraceSourceOptions]::Events


'
- <file:///https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/set-tracesource?view=powershell-7.3&viewFallbackFrom=powershell-7.1>
'
$Path_log = 'g:\temp\trace.log'
remove-item $Path_log -ea 'ignore'
# enable
Set-TraceSource -Name "ParameterBinding" -Option ExecutionFlow -PSHost -ListenerOption "ProcessId,TimeStamp"
# Set-TraceSource -Name "ParameterBinding" -Option ExecutionFlow -PSHost -ListenerOption "ProcessId,TimeStamp" -Debugger
# or filepath
# Set-TraceSource -Name "ParameterBinding" -Option ExecutionFlow -PSHost -ListenerOption "ProcessId,TimeStamp" -file $Path_log
Set-TraceSource -Name "ParameterBinding" -Option ExecutionFlow -PSHost -ListenerOption none -file $Path_log

gi .
0..4 | %{ $_ }
# disable
Set-TraceSource -Name "ParameterBinding" -RemoveListener "Host"
gi $Path_log | Join-string -op 'wrote: '