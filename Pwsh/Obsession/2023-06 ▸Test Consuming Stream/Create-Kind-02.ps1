Remove-Item StreamTest.dll -ErrorAction SilentlyContinue
@'
Context: <https://discord.com/channels/180528040881815552/447476117629304853/1118014759946690570>

Seems like creating a runspace with a module in the initial session state breaks streams like verbose of the cmdlet
seeminglyscience — Today at 10:17 PM
think it might be too late for me to be able to follow that 😁 definitely curious though
jborean — Today at 10:18 PM
all good, super edge case and really just weird as to why it's happening
I might change the code to not use InitialSessionState if I can and see if that helps
weird thing is the output and error streams are fine, just seems to only affect the others

'@

Add-Type -TypeDefinition @"
using System;
using System.Management.Automation;
using System.Management.Automation.Runspaces;

namespace StreamTest
{
    [Cmdlet(VerbsDiagnostic.Test, "Function")]
    public sealed class TestFunction : PSCmdlet
    {
        [Parameter()]
        public string ModulePath { get; set; }

        protected override void EndProcessing()
        {
            InitialSessionState iss = InitialSessionState.CreateDefault2();
            if (!string.IsNullOrWhiteSpace(ModulePath))
            {
                iss.ImportPSModule(new string[] { ModulePath });
            }

            using Runspace rs = RunspaceFactory.CreateRunspace(Host, iss);
            rs.Open();
            WriteVerbose("verbose");
        }
    }
}
"@ -OutputAssembly StreamTest.dll

$modulePath = Get-Item StreamTest.dll

$ps = [PowerShell]::Create()
$ps.AddScript(@'
param($Assembly)
Import-Module $Assembly

Test-Function -Verbose
'@).AddArgument($modulePath).Invoke()
$ps.Streams  # verbose is present


$ps = [PowerShell]::Create()
$ps.AddScript(@'
param($Assembly, $Module)
Import-Module $Assembly

Test-Function -ModulePath $Module -Verbose
'@).AddArgument($modulePath).AddArgument((Get-Module PSReadline).ModuleBase).Invoke()
$ps.Streams  # verbose is empty