
[Collections.Generic.List[Object]]$queryResults = @()

class QueryCacheItem { 
    [string]$OriginalQuery
    [object]$Result
    [timespan]$Duration
}

class QueryCache {
#    static 
}

function ExSeries {
<#
  .synopsis
    call a series of PowerShellAI queries, but cached when inputs are identical.
   .example
   
        # this caches results, making it easier to use this, or, to re-run queries on the cmdline except auto cache.
        ai 'list of important cats' | ai 'as json' | ai 'to xml powershell'
    
  .notes    
      - I thought there was a $psLazyCache module
     
 #>
   param( 
       [Parameter(Mandatory)][string[]]$Commands,
       [switch]$WhatIf
   )
   $offset = 0 
   
   $Commands | %{ 
      $cur = $_
      $prevResult = if($offset -eq 0) { }
      $offset++

      if($WhatIf) {
        if($PrevResult) { 'whatIf: $curInvoke = $prevInvoke | ai $query' }
        else { 'whatIf: $curInvoke = ai $query' } 
        return
      }
      if($prevResult) { 
         $curInvoke =  $prevResult | ai $cur
      } else {
         $curInvoke = ai $cur
      }
      [QueryCacheItem]@{ OriginalQuery = $cur ; $Result = $curInvoke; }

      'run: {0}' -f @( $cur )
      ai $cur
   }
}

ExSeries -WhatIf @(
    'list of famous cats'
    'to json'
    'to powershell literals'
)
