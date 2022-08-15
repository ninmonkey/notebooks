using namespace System.Collections.Generic

Import-Module benchpress -PassThru -ea stop
$PSVersionTable.PSVersion | Join-String -op 'Pwsh: '
$Config = @{ Names = 'dev.nin' }

# if slow
$TestConfigSlow = @{
    MaxValue    = 0x10ffff
    RepeatCount = 200
    Delims      = ' ▸·⇢⁞ ┐⇽▂'
    ExportPath  = (Join-Path $PSScriptRoot './.output/Summary-Slow.xlsx')
}
# if fast
$TestConfigFast = @{
    MaxValue    = 0x10ff
    RepeatCount = 3
    Delims      = ' ▸·⇢⁞ ┐⇽▂'
    ExportPath  = (Join-Path $PSScriptRoot './.output/Summary-Fast.xlsx')
}
$measureBenchSplat = @{
    OutVariable = 'ovBenchSummary'
    RepeatCount = $TestConfig.RepeatCount
    GroupName   = 'Root'
}
if ($true -or 'fastOnly') {
    'Fast' | Label 'Config?'
    $TestConfig = $TestConfigFast
} else {
    'Slow' | Label 'Config?'
    $TestConfig = $TestCOnfigSlow
}
$TestConfig | Format-Table -auto

Measure-Benchmark @measureBenchSplat -Technique @{
    'Generic<Object>[] ⇢  += empty with Loop' = {
        [list[object]]$Items = @(
            0..$MaxValue | ForEach-Object { $Items.add( $_ ) }
        )
    }
    'Generic<Object>[] ⇢  += div with Loop'   = {
        [list[object]]$Items = @(
            0..$MaxValue | ForEach-Object { $Items.add( ($_ / 3) ) }
        )
    }
    'Generic<Object>[] ⇢ empty with Loop'     = {
        [list[object]]$Items = @(
            0..$MaxValue | ForEach-Object { $_ }
        )
    }
    'Generic<Object>[] ⇢ empty no Loop'       = {
        [list[object]]$Items = @(
            0..$MaxValue
        )
    }
    'Generic<Object>[] ⇢ Double '             = {
        [list[object]]$Items = @(
            0..$MaxValue | ForEach-Object { $_ * 2 }
        )
    }
    'Generic<Int>[] ⇢ empty with Loop'        = {
        [list[int]]$Items = @(
            0..$MaxValue | ForEach-Object { $_ }
        )
    }
    'Generic<Int>[] ⇢ empty no Loop'          = {
        [list[int]]$Items = @(
            0..$MaxValue
        )
    }
    'Generic<Int>[] ⇢ Double '                = {
        [list[int]]$Items = @(
            0..$MaxValue | ForEach-Object { $_ * 2 }
        )
    }
    'Object[] ⇢ empty with Loop'              = {
        [object[]]$Items = @(
            0..$MaxValue | ForEach-Object { $_ }
        )
    }
    'Object[] ⇢ empty no Loop'                = {
        [object[]]$Items = @(
            0..$MaxValue
        )
    }
    'Object[] ⇢ Double '                      = {
        [object[]]$Items = @(
            0..$MaxValue | ForEach-Object { $_ * 2 }
        )
    }
    'Implicit[] ⇢ empty with Loop'            = {
        $Items = @(
            0..$MaxValue | ForEach-Object { $_ }
        )
    }
    'Implicit[] ⇢ empty no Loop'              = {
        $Items = @(
            0..$MaxValue
        )
    }
    'Implicit[] ⇢ Double '                    = {
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

try {
    $ovBenchSummary | Export-Excel -Path $TestConfig.ExportPath -ea 'continue'
} catch {
    Write-Warning 'Excel is still open.'
}
$TestConfig.ExportPath | Get-Item | ForEach-Object FullName | Label 'Wrote Summary...' -fg2 'gray30' -bg2 'gray80'

$TestConfig.ExportPath | Get-Item | Invoke-Item

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