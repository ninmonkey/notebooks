
function NewUser {
    [Cmdletbinding()]
    param(
    [string]$UserName )

    [ArgumentException]::ThrowIfNullOrEmpty(
        <# argument: #> $UserName, <# paramName: #> 'UserName')

    [ArgumentException]::ThrowIfNullOrWhiteSpace(
        <# argument: #> $UserName, <# paramName: #> 'UserName')
}

NewUser 'Bob'
try {
    newUser ''
} catcH {
    'bad stuff'
}
# NewUser ''
