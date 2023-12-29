class Vehicle {
    [string]$Name = 'none'

    Vehicle () {
        # this works, instance is no longer assigned to 'none'
        $this = [Vehicle]::Spawn('default')
    }
    Vehicle ( [string]$Name ) {
        $this.Name = $Name
    }
    [void] Transform ( [string]$Name ) {
        # this does not mutate the caller's state,
        # because that's not allowed (outside of ctors)
        $this = [Vehicle]::Spawn( $Name )
    }
    static [Vehicle] Spawn ( [string]$Name ) {
        return [Vehicle]::New( $Name )
    }
}

[Vehicle]@{}               # Name: none
[Vehicle]::new($null)      # Name: StrEmpty
[Vehicle]::new()           # Name: none
[Vehicle]::new('blank')    # Name: blank
[Vehicle]@{ Name = 'Car' } # Name: Car
[Vehicle]::Spawn('batmobile') #  : Batmobile

[Vehicle]::Spawn('batmobile').Transform('cat') # emits null


$t = [Vehicle]::Spawn('batmobile') # Name: Batmobile
$t.Transform('yeti')               # Name: Batmobile
    # because
