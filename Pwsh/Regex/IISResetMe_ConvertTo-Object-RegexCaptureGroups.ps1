
<#
IISResetMe/ConvertTo-Object.ps1
context: <https://discord.com/channels/180528040881815552/447476117629304853/1133536515079807016>
gist: <https://gist.github.com/IISResetMe/654b302383a687bd92faa8c8c3ab28fa>

Quick and dirty regex-based text-to-object parsing using named expressions groups and $Matches 
#>

function ConvertTo-Object {
  param(
    [Parameter(Mandatory=$true,ValueFromPipeline=$true)]
    [AllowEmptyString()]
    [string[]]$InputString,

    [Parameter(Mandatory=$true,ValueFromRemainingArguments=$true)]
    [string[]]$Pattern
  )

  process{
    foreach($string in $InputString |?{$_}){
      foreach($p in $Pattern){
        if($string -match $p){
          if($PropertyNames = $Matches.Keys |Where-Object {$_ -is [string]}){
            $Properties = $PropertyNames |ForEach-Object -Begin {$t = @{}} -Process {$t[$_] = $Matches[$_]} -End {$t}
            [PSCustomObject]$Properties
          }
          break
        }
      }
    }
  }
}
