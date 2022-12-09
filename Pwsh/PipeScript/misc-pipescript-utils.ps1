Import-Module PipeScript -MinimumVersion 0.1.7 # maybe earlier
function transpileTillCooked { 
    <#
    .synopsis
        repeat transpiling, until fully done. should be redundant in newer versions.
    .DESCRIPTION
        it's sugar for:

            $src.Transpile().Transpile().Transpile().Transpile() | invoke-formatter

        exit early with max iteration count
        returns script block, while optionally printing each state
    .EXAMPLE
        $finalSrc = transpileTillCooked.2 -ScriptBlock $src -MaxIters 3 -Pretty
    #>
    [OutputType('System.Management.Automation.ScriptBlock')]
    [Alias('Pipes.transpileTillCooked.2')]
    param( 
        [Parameter(Mandatory)]
        [ScriptBlock]$ScriptBlock,
        [int]$MaxIters = 7,

        # This shows changes before each transpile step
        # with any value, final output is always a [scriptblock]
        [switch]$Pretty
    )
    $last = $ScriptBlock
    $iter = 0

    while($true) { 
        if($iters++ -gt $MaxIters) { break } 
        $next = $last.Transpile()
        if($Pretty) { 
            $InformationPreference = 'continue'
            hr | Write-Information
            $next | Write-Information
            $InformationPreference = 'silentlycontinue'
        }
        if($next.ToString() -eq $last.ToString()) { break }
        $last = $Next
    }
    return $next
}