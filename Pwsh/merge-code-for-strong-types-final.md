to merge notes
```ps1
### weak/dynamic typing

    $x = [int]'1233'
    $x.GetType() # [int]
    $x = '213'
    $x.GetType() # [string]

### strongly typing

    [int]$y = '1233'
    $y.GetType() # [int]
    $y = '123'
    $y.GetType() # [int]

This can be important, for instance, you want something to always be an array. Because an empty array verses a null value mean different things. Even if they are both `falsy`.

    [Object[]]$alwaysList = 'a'   # [Object[]]
    [Object[]]$alwaysList = @('a', 'b', 'c' )   # [Object[]]

    [Object[]]$alwaysList = @()   # [Object[]]

    $users = Get-AdUser *         # could be null, a scalar, or a list
    $users = @(Get-AdUser *)      # this is always a list
    $users = get-aduser           # but now might not be a list.
    [Object[]]$alwaysList = @()


I've been using 'list'/'array' interchangeably above. Modern powershell uses generics for arrays.

When you'd normally use `[Object[]]`, you use `[List[Object]]

    using namespace System.Collections.Generic # shorten type names

    [List[Object]]$Users = Get-AdUser
    [List[Object]]$files = Get-ChildItem -recurse

Say you have a custom class named `User` that you have a list of,
that you want to force the list to *only* hold users, preventing bugs like
adding a different type. Or great for web apis /w `json`

    [User[]]$users = @( Get-ADUser )
    # would be
    [List[User]]$Users = @( Get-AdUser )  # @() is actually redundant but it gives intent


```