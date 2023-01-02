#Requires -Modules @{ ModuleName = 'ImportExcel' ; ModuleVersion = '7.0.0' }
#Requires -Modules @{ ModuleName = 'NameIt' ; ModuleVersion = '2.3.2' }
$script:playerId = 0 # for basic GUIDs
$script:stadiumId = 0

@'
future: create custom generators

    Get-Random: C:\Users\cppmo_000\SkyDrive\Documents\PowerShell\Modules\NameIt\2.3.2\Generators\synonym.ps1:14:16
    Line |
    14 |      $synonyms[(Get-Random -Minimum 0 -Maximum $max)]
'@

function ToNameItInvokeGenerate {
    <#
    .synopsis
        Pipe a template, creating N instances
    .LINK
        https://github.com/dfinke/NameIt#v233
    #>
    [Alias('ToIg')]
    param(
        [int]$Count = 1
    )
    process {
        # future: What is -CustomData, -CustomDataFile ?
        NameIt\Invoke-Generate $_ -Count $Count
    }
}

'hi world'



function Rand.Stadium.0 { 
    param(
        [int]$Count = 1
    )
    # sugar
    [pscustomobject]@{
        # Name = NameIt\Ig -Template '[color]-[person]'
        Name = NameIt\Ig -Template '[color]-[adjective]-[state]'                
        Id   = $script:stadiumId++
    }
}
function Rand.Stadium.1 { 
    # sugar
    param(
        [int]$Count = 1
    )
    # Location = [state]_[color]_[synonym cat]
    $TemplateStadium0 = '
        Location = [adjective]_[color]_[synonym cat]
        Id = {0}
    ' 
    $TemplateStadium1 = '
        Location = [adjective]_[color]_[synonym cat]
        Location2 = [state]''s [adjective]-[synonym fighting]-[synonym cat]
        Id = {0}
    ' 
    $TemplateStadium2 = '
        Location = [adjective]_[color]_[synonym cat]
        Location2 = [state]''s [adjective]-[synonym fighting]-[synonym <animal>]
        Id = {0}
    '
    $selectedTemplate = $TemplateStadium2
    foreach ($i in 1..$Count) { 
        # Maybe I can create a custom provider
        $nextAnimal = Get-Random -count 1 -InputObject @(
            'cat'
            'dog'
            'zebra'
            'goat'
        )
        $preTemplate = $selectedTemplate -replace ([regex]::Escape('<animal>')), {
            $nextAnimal
        }
        $preTemplate | write-host -fore red
        $Template = $preTemplate -f @(
            $script:stadiumId++
        )
        $Template | Join-String -op 'using template: ' | Write-Verbose
        
        # because -Count template doesn't work because the Id is the same for 5
        NameIt\Ig -Template $Template -AsPSObject 
    }
}
function Rand.Stadium { 
    # sugar
    [CmdletBinding()]
    param(
        [int]$Count = 1
    )
    # Location = [state]_[color]_[synonym cat]
    $TemplateStadium0 = '
        Location = [adjective]_[color]_[synonym cat]
        Id = {0}
    ' 
    $TemplateStadium1 = '
        Location = [adjective]_[color]_[synonym cat]
        Location2 = [state]''s [adjective]-[synonym fighting]-[synonym cat]
        Id = {0}
    ' 
    $TemplateStadium2 = '
        Location = [adjective]_[color]_[synonym cat]
        Location2 = [state]''s [adjective]-[synonym <action>]-[synonym <animal>]
        Id = {0}
    '
    $selectedTemplate = $TemplateStadium2
    foreach ($i in 1..$Count) { 
        # Maybe I can create a custom provider
        $nextAnimal = Get-Random -count 1 -InputObject @(
            'cat'
            'dog'
            'zebra'
            'goat'
        )
        $preTemplate = $selectedTemplate -replace ([regex]::Escape('<animal>')), {
            $nextAnimal
        } -replace ([regex]::Escape('<action>')), {
            Get-Random -count 1 -InputObject @(
                'fighting'
                'loving'
                'sneaky'
                'loud'
                'bold'
            )
        }
        # $preTemplate | write-verbose
        $Template = $preTemplate -f @(
            $script:stadiumId++
        )
        $Template | Join-String -op 'using template: ' | Write-Verbose
        
        # because -Count template doesn't work because the Id is the same for 5
        NameIt\Ig -Template $Template -AsPSObject 
    }
}
Rand.Stadium -Count 10 -ov 'ovStadium' | ft
function Rand.Player {
    # sugar
    [pscustomobject]@{
        Name = NameIt\Ig -Template '[person]'
        Id   = $script:playerId++
    }
}

function New.Template {
    New-NameItTemplate -sb {
        [PSCustomObject]@{
            Company = ''      
            Name    = ''
            Age     = 0
            address = ''
            state   = ''
            zip     = ''
        }        
    }
}


# Ig '
# '
# Id = 
#  -AsPSObject

$playerId = 0 
0..10 | % {
    Rand.Player
    
} | Ft  -auto
$DocsMd = @"
## Docs

[alpha]; selects a random character (constrained by the -Alphabet parameter).
[numeric]; selects a random numeric (constrained by the -Numbers parameter).
[vowel]; selects a vowel from a, e, i, o or u.
[phoneticVowel]; selects a vowel sound, for example ou.
[consonant]; selects a consonant from the entire alphabet.
[syllable]; generates (usually) a pronouncable single syllable.
[synonym word]; finds a synonym to match the provided word.
[person]; generate random name of female or male based on provided culture like <FirstName><Space><LastName>.
[person female]; generate random name of female based on provided culture like <FirstName><Space><LastName>.
[person female first]
[person female last]
[person male]; generate random name of male based on provided culture like <FirstName><Space><LastName>.
[person male first]
[person male last]
[person both first]
[person both last]
[address]; generate a random street address. Formatting is biased to US currently.
[space]; inserts a literal space. Spaces are striped from the templates string by default.
"@
# $DocsMd ; $DocsMd | ToIg