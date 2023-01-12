function Kat { 
   [CmdletBinding()]   
   param(
      $InputObject
   )
   begin { '> GO 🐈' }
   process { '    item: 🐈' }
   end { '< End 🐈' }
}
0..3 |  Kat
function bat { 
   begin { '> GO 🦇' }
   process { '    item: 🦇 is {0}' -f $_ }
   end { '< End 🦇' }
}
0..3 |  Bat | bat |   Bat | bat   Bat

function batHost { 
   begin { '> GO 🦇' | write-host }
   process { '    item: 🦇 is {0}' -f $_ | write-host }
   end { '< End 🦇' | write-host }
}
0..3 |  BatHost | BatHost |  BatHost | BatHost | BatHost