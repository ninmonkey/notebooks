'Testing: Do aliases auto-export if the command they are attributes to, are? Nope.' | write-host

function InternalFunc {
    [alias('Ini.Func')]
    param()
    $MyInvocation.MyCommand.Name
}
function Alice.TestExternal {
    [alias(
        'Ini.Exter',
        'Alice.Exter'
    )]
    param()
    $MyInvocation.MyCommand.Name
}

Export-ModuleMember -Function @('Alice.*') -Alias ('Alice.*') -Variable @('Alice.*')
