Import-Module benchpress -PassThru -ea stop
$PSVersionTable.PSVersion | Join-String -op 'Pwsh: '
$Config = @{ Names = 'dev.nin' }

$measureBenchSplat = @{
    OutVariable = 'ovBenchSummary'
    # RepeatCount = 10
    RepeatCount = 2
    GroupName   = 'Root'
}

$TestConfig = @{
    MaxValue = 0x10ffff
    Delims   = ' ▸·⇢⁞ ┐⇽▂'
}
Measure-Benchmark @measureBenchSplat -Technique @{
    # 'Filtering by the Source Command' = {
    'Implicit [] ⇢ empty with Loop' = {
        $Items = @(
            0..$MaxValue | ForEach-Object { $_ }
        )
    }
    'Implicit [] ⇢ empty no Loop'   = {
        $Items = @(
            0..$MaxValue
        )
    }
    'Implicit [] ⇢ Double '         = {
        $Items = @(
            0..$MaxValue | ForEach-Object { $_ * 2 }
        )
    }

} | Sort-Object Time -desc


h1 'as Time'
$ovBenchSummary | Sort-Object Time -Descending | Format-Table -AutoSize
h1 'as RelativeSpeed'
$ovBenchSummary | Sort-Object RelativeSpeed -Descending | Format-Table
# # return
# [object[]]$Items = @(
#     0..0x10ffff | ForEach-Object { $_ * 2 }
# )

return

# return

$PSVersionTable.PSVersion | Join-String -op 'Pwsh: '
$Config = @{ Names = 'dev.nin' }
h1 'variable config module names'
Measure-Benchmark -ov 'ovBenchSummary' -RepeatCount 5 -GroupName 'OuterGroup' -Technique @{
    # 'Filtering by the Source Command' = {
    'Gcm -CommandType Alias'          = {
        Get-Command -m $Config.Names -CommandType Alias
    }
    'Gcm | ? CommandType -eq "alias"' = {
        Get-Command -m $Config.Names
        | Where-Object CommandType -EQ 'alias'
    }
    '2Step $All.Where{}'              = {
        $allCmd = Get-Command -m $Config.Names
        $allCmd.Where({ $_.CommandType -eq 'alias' })
    }
    'Inline $All.Where{} '            = {
        @(Get-Command -m $Config.Names).Where({ $_.CommandType -eq 'alias' })
    }
} | Sort-Object Time -desc

return

h1 'hardcoded module names'
Measure-Benchmark -Technique @{
    # 'Filtering by the Source Command' = {
    'Gcm -CommandType Alias'          = {
        Get-Command -m 'Dev.nin' -CommandType Alias
    }
    'Gcm | ? CommandType -eq "alias"' = {
        Get-Command -m 'Dev.nin'
        | Where-Object CommandType -EQ 'alias'
    }
    '2Step $All.Where{}'              = {
        $allCmd = Get-Command -m 'Dev.nin'
        $allCmd.Where({ $_.CommandType -eq 'alias' })
    }
    'Inline $All.Where{} '            = {
        @(Get-Command -m 'Dev.nin').Where({ $_.CommandType -eq 'alias' })
    }
} | Sort-Object Time -desc




# return
# $results ??= @{}
# $results.AsObject = Measure-Command -Expression { & {

#         [object[]]$Items = @(
#             0..0x10ffff | ForEach-Object { $_ * 2 }
#         )

#         $items.count | Write-Host
#     } } | ForEach-Object TotalSeconds

# $results.AsObject = Measure-Command -Expression { & {

#         $Items = @(
#             0..0x10ffff | ForEach-Object { $_ * 2 }
#         )

#         $items.count | Write-Host
#     } } | ForEach-Object TotalSeconds


# $results