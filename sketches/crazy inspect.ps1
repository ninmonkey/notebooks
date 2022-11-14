'crazy inspect '

function _inspectResult {
    [cmdletbinding()]
    param(
        [Parameter()]
        
        $InputList
    )
}

. { 

    $Samples = @(
        "a`r`nb" 
        "a`rb" 
        "ab" 
    )
    function procItem {
        [pscustomobject]@{

        }
    }

    class Stuff
"a`r`nb" | Out-String | Format-ControlChar
  "a`rb" | Out-String | Format-ControlChar
  "ab" | Out-String | Format-ControlChar

,"a`r`nb" | Out-String | Format-ControlChar
  ,"a`rb" | Out-String | Format-ControlChar
  ,"ab" | Out-String | Format-ControlChar


"a`r`nb" | Out-String -Stream | Format-ControlChar
  "a`rb" | Out-String -Stream | Format-ControlChar
  "ab" | Out-String -Stream | Format-ControlChar

,"a`r`nb" | Out-String -Stream | Format-ControlChar
  ,"a`rb" | Out-String -Stream | Format-ControlChar
  ,"ab" | Out-String -Stream | Format-ControlChar
}
