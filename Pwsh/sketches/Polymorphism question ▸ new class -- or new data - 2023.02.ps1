class Animal {
    [string]$Species
    [string]$Greeting

    Animal () {
        $this.Species = 'ghost'
        $this.Greeting = 'boo!'
    }
    Animal ( [string]$Species, [string]$Greeting ) {
        $this.Species = $Species
        $this.Greeting = $Greeting
    }
    [string] AnimalSound () {
        return 'the {0} says {1}' -f @(
            $this.Species,
            $this.Greeting
        )
    }
    [string] ToString() {
        return '[Animal( Species: {0} )]' -f @(
            $this.species
        )
    }
}

function New-Animal {
    <#
    this is a factory
    Sometimes it makes more sense to put that logic inside [Animal]
    Other times it's data-driven by external data

    You can still return customized instances that derive, or are [Animal]'s

    [Animal]::New()
    [Dog]::new()
    [Cat]::New()

You can get similar results with a factory pattern, ex:
    New-Animal 'Animal'
    New-Animal 'Dog'
    New-Animal 'Cat'

    #>
    [CmdletBinding()]
    param(
        [ArgumentCompletions('Cat', 'Dog', 'Other')]
        [string]$Species ) {
    }
    $Greeting = switcH ($Species) {
        'Cat' { 'Meow' }
        'Dog' { 'woof' }
        default { 'Moo? Woof?' }
    }
    return [Animal]::New( $Species, $Greeting )
}
