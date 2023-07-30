$ps = [PowerShell]::Create()
$ps.AddScript(@'
New-Module -Name MyModule -ScriptBlock {
    Function Test-Function {
        [CmdletBinding()]
        param()

        Write-Debug debug
        Write-Verbose verbose
        Write-Warning warning
    }

    Export-ModuleMember -Function Test-Function
} | Import-Module

Test-Function -Debug -Verbose -WarningAction Continue
'@).Invoke()
$ps.Streams