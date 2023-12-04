'Testing: Do aliases auto-export if the command they are attributes to, are?' | write-host

function Alice.GetCommand {
    gcm Alice.*
    hr
    gcm -m 'Test-DoAliasesAttributesAutoExport'
    hr
}

function InternalFunc {
    [alias('Ini.Func', 'Alice.InKnee')]
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
