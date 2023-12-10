$CommandName = 'pwsh'
Measure-Benchmark -Group A -ov 'ovSummary' -RepeatCount 2 -Technique @{
    'ExContext: GetCommand_QuitOnFirst' = {
        $ExecutionContext.InvokeCommand.GetCommand(
            <# commandName: #> $CommandName,
            <# type: #> 'Application' )
    }
    'ExContext: GetCommandName_WithoutPattern' = {
        $ExecutionContext.InvokeCommand.GetCommandName(
            <# name: #> $CommandName,
            <# nameIsPattern: #> $false,
            <# returnFullName: #> $false )
    }
# }
# Measure-Benchmark -Group B -ov 'ovResultsB' -RepeatCount 2 -Technique @{
    'ExContext: GetCommandName_WithoutPattern_ReturnFull' = {
        $ExecutionContext.InvokeCommand.GetCommandName(
            <# name: #> $CommandName,
            <# nameIsPattern: #> $false,
            <# returnFullName: #> $true )
    }
    # 'GetCommands_WithoutPattern_ReturnFull' = {
    'ExContext: GetCommands_IsApplication_withoutPattern' = {
        $ExecutionContext.InvokeCommand.GetCommands(
            <# name: #> $CommandName,
            <# commandTypes: #> 'Application',
            <# nameIsPattern: #> $false)
    }
    'Get-Command: Kind: ApplicationInfo' = {
        Get-Command -CommandType Application $CommandName
    }

    'Get-Command: Kind: ApplicationInfo, TotalCount: 1' = {
        Get-Command -CommandType Application $CommandName -TotalCount 1
    }
    'Get-Command: Kind: ApplicationInfo | Select -first 1' = {
        Get-Command -CommandType Application $CommandName
            | Select -first 1
    }
    'Get-Command: Kind: ApplicationInfo -All' = {
        Get-Command -CommandType Application $CommandName -All
    }
    'Get-Command: Kind: ApplicationInfo -All | Select -first 1' = {
        Get-Command -CommandType Application $CommandName -All
            | Select -first 1
    }
} | sort-Object Time -desc

hr
h1 (Join-String -in $PSCommandPath -f "File: {0}")
h1 'ByName'
$ovSummary | sort-Object Technique | ft -auto
h1 'ByTime'
$ovSummary | sort-Object Time | ft -auto
