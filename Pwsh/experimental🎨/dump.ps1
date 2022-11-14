
'see also: <H:\env\code\env_md\addons\ms-vscode.powershell-preview-2022.10.1\modules\PowerShellEditorServices\Commands\Public\Import-EditorCommand.ps1>'

function transpileTillCooked { 
    param( 
        [Parameter(Mandatory)]
        [ScriptBlock]$ScriptBlock,
        [int]$MaxIters = 7,
        [switch]$Pretty
    )
    $last = $ScriptBlock
    $iter = 0
    # foreach($i in 0..$MaxIters) { 
    #     $temp = $last
    #     $now = $last.Transpile()
    #     if($temp.ToString() -eq $now.ToString()) { break }
    #     $last = $now        
    #     if($Pretty) { 
    #         hr;
    #         $now.ToString()
    #     }
    # }
    while($true) { 
        if($iters++ -gt $MaxIters) { break } 
        $next = $last.Transpile()
        if($next.ToString() -eq $last.ToString()) { break }
        $last = $Next
    }
    return $next
    # $Current = $ScriptBlock
    # $last = $current
    # while($true) { 
    #     $next = $last.Transpile()        
    #     $last = $Next
    #     if($next.ToString() -eq $last.ToString()) { return $next }
    # }
}