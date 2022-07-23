Import-Module NameIt -ea stop

class Cat {
    [string]$Name = 'bob'
    [string]$Color
    [object[]]$kittens = @()

    Cat () {
        $this.name = ig '[person]'
        $this.Color = ig '[color]'
    }
}

[Cat]::new()

# $APIResponse = @(
#     @{ 'Name' = 'Cat' }
# )

# [JCUserUpdate_CsvRecord[]]$jcUserUpdate = $payloEInfo | ForEach-Object {
#     [JCUserUpdate_CsvRecord]::new($_)
# }
