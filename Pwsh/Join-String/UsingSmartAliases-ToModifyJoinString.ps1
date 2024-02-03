function JoinText { 
   [Alias('UL', 'Csv', 'Quote')]
   param()
   switch( $MyInvocation.InvocationName )  { 
       'UL' { 
           $Input | Join-String -f " - {0}" -sep "`n"
       }
       'Quote' { $input | Join-String -sep ', ' -SingleQuote -Property Name }
       default { 
           $Input | Join-String -sep ', ' 
       }
   } 
   
}

# usage:

'a'..'e' | JoinText
'a'..'e' | Csv
'a'..'e' | UL
ps | select -First 15  
   | Quote

