h1 'begin'
hr
& { 
    [System.Linq.Enumerable]::Any[object]((0..10), [System.Func[object, bool]] { $args[0] -gt 5 })
}
hr 
& { 
    $str = 'pre: '
    [Collections.Generic.List[Object]]$lob = @()
    [Collections.Generic.List[String]]$lobSTeR = @()

    $letters = @('a'..'e')

    $lob.Add( $letters )
    $lob | to->Json -Compress

    $lob.AddRange( $letters )
    $lob | to->Json -Compress
    hr
    
    $lobSTeR.Add( $letters) 
    $lobSTeR | to->Json -Compress
    
    # this errors
    $lobSTeR.AddRange( $letters) 
    $lobSTeR.AddRange[String]( $letters) 
    

}
hr -fg yellow
# hr
#| Join-String -sep (hr 1)

@'
see also:

- docs: [about_calling_generic_methods Pwsh 7.3](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_calling_generic_methods?view=powershell-7.4)
- learn: [Generics in .Net - Top level](https://learn.microsoft.com/en-us/dotnet/standard/generics/)
- [Method overload selection involving delegates should use scriptblock parameters for selection hints #16940](https://github.com/PowerShell/PowerShell/issues/16940)
'@