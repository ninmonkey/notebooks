@'
Discord asked if you could recreate this in Pwsh
var items = new (string name, string url)[] {
    ("Ubuntu 20.04", "https://releases.ubuntu.com/20.04.1/ubuntu-20.04.1-desktop-amd64.iso"),
    ("Spotify", "https://download.scdn.co/SpotifySetup.exe"),
    ("Windows Terminal", "https://github.com/microsoft/terminal/releases/download/v1.5.3242.0/8wekyb3d8bbwe.msixbundle"),
};

See also:
- [Using Linq.Enumerable::Select\[int, float\]](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_calling_generic_methods?view=powershell-7.3#example)
- [general generics in dotnet](https://learn.microsoft.com/en-us/dotnet/standard/generics/)
'@

class AppTuple {
    [string]$Name
    [string]$Uri
    # partA
    AppTuple ( [string]$Name, [string]$Uri ) {
        $This.Name = $name
        $this.Uri = $uri
    }
    # partB
    AppTuple ( [object[]]$Params ) {
        if($Params.Count -ne 2) { throw "InvalidCtorArgs: $Params" }
        $This.Name = $Params[0]
        $this.Uri = $Params[1]
    }
}

# PartA allows:
$app1 = [AppTuple]::new('Ubuntu 20.04', 'https://releases.ubuntu.com')
$app1

# PartB allows:
$app2 = [AppTuple]::new( @('Ubuntu 20.04', 'https://releases.ubuntu.com') )
$app2 

# Part2 of PartB allows:
[AppTuple]$app4 = 'Ubuntu 20.04', 'https://releases.ubuntu.com'
$app4

( $app5 = [AppTuple]$Items[0] )


class AppTupleGen {
    # add generic invocation test
    [string]$Name
    [string]$Uri
    # partA
    AppTupleGen ( [string]$Name, [string]$Uri ) {
        $This.Name = $name
        $this.Uri = $uri
    }
    # partB
    AppTupleGen ( [object[]]$Params ) {
        if($Params.Count -ne 2) { throw "InvalidCtorArgs: $Params" }
        $This.Name = $Params[0]
        $this.Uri = $Params[1]
    }

    [bool] static 
}
hr
( $app6 = [AppTupleGen]$Items[0])
hr
@'
# static generic methods
[type_name]::MethodName[generic_type_arguments](method_arguments)

# instance generic methods
$object.MethodName[generic_type_arguments](method_arguments)

generic_type_arguments can be a a single type or comma-separated list of types, like
    `[string, int]`, including other generic types like
    `$obj.MethodName[string, System.Collections.Generic.Dictionary[string, int]]()`
'@

return
$allArgs = @(

    'Ubuntu 20.04', 'https://releases.ubuntu.com/20.04.1/ubuntu-20.04.1-desktop-amd64.iso'
    'Spotify', 'https://download.scdn.co/SpotifySetup.exe'
    'Windows Terminal', 'https://github.com/microsoft/terminal/releases/download/v1.5.3242.0/8wekyb3d8bbwe.msixbundle'
)

# class AppTuple { 
#     [string]$Name
#     [string]$Uri
#     AppTuple ( [object[]]$Params ) { 
#         if ($Params.Count -ne 2) { throw "InvalidCtorArgs: $Params" }
#         $This.Name = $Params[0]
#         $this.Uri = $Params[1]
#     }
# }

# [Collections.Generic.List[object]]$Items =@()



'Ubuntu 20.04', 'https://releases.ubuntu.com/20.04.1/ubuntu-20.04.1-desktop-amd64.iso'
'Spotify', 'https://download.scdn.co/SpotifySetup.exe'
'Windows Terminal', 'https://github.com/microsoft/terminal/releases/download/v1.5.3242.0/8wekyb3d8bbwe.msixbundle'