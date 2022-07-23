Import-Module NameIt -ea stop

Label 'basically the problem is


[list[Cat]]$cats = 0..5 |%{ [Cat]::new() }

then breaks
    [list[Herd]]$Herd = $cats
evver
works
    [list[Herd]]$Herd = @($cats | %{ [Herd]::New($cats) })

works
    [list[Herd]]$Herd = @($cats)
'
Hr -fg 'magenta'

H1 'meaning: class just needs an IEnumerable ?'

class Cat {
    [string]$Name = 'bob'
    [string]$Color
    [object[]]$kittens = @()

    Cat () {
        $this.name = ig '[person]'
        $this.Color = ig '[color]'
    }
    Cat ([bool]$IncludeChildren) {
        $this.name = ig '[person]'
        $this.Color = ig '[color]'
        # Label 'parent' | Write-Verbose
        if ($IncludeChildren) {
            if ($true) {
                $This.kittens = @(
                    [Cat]::New()
                    [Cat]::New()
                )
            }
            if ($false) {
                $this.kittens = 0..(Get-Random -min 0 -max 6) | ForEach-Object {
                    Label 'kitten' 'new' | Write-Verbose
                    [Cat]::new()
                }
            }
        }
    }

    [string] ToString () {
        $template = '[Cat(Name = {0}, Kittens = {1})]'
        $render = $template -f @(
            $this.Name
            if ($This.Kittens.count -gt 0) {
                $this.kittens.Count
            } else {
                'none'
            }
        )
        return $render

    }
}

[list[Cat]]$catList = 0..4 | ForEach-Object {
    [Cat]::New($true)
}

$catList | to->Json


# $APIResponse = @(
#     @{ 'Name' = 'Cat' }
# )

# [JCUserUpdate_CsvRecord[]]$jcUserUpdate = $payloEInfo | ForEach-Object {
#     [JCUserUpdate_CsvRecord]::new($_)
# }
