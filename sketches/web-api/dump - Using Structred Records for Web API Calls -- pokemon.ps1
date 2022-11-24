    @{ 
        'type'  = 'container'
        'items' = @(
            @{
                'type' = 'TextBlock'
                'text' = 'Weight: {0}' -f @( $PokemonData.weight)    
            }
        )
    }

class jsonItem {
    [ValidateSet('Container', 'TextBlock')]
    [string]$Type = 'Container'
    [string]$Weight = 'Weight: 0'

    jsonItem () {
        # if you need any other default constructor
        $this.Weight = 'Weight: 0'
    }
    jsonItem ( $type, $Weight ) {
        $this.Type =  $type
        $this.Weight = 'Weight: {0}' -f $Weight
    }
}

class jsonContainer {
    [string]$Type = 'Container'
    [object[]]$Items = @()
}


[jsonContainer]@{ 
    Items = @(
        'a'..'c'
    )
} | ConvertTo-Json


# works
[jsonItem]@{ Type = 'container' } | ConvertTo-Json

# error
# Cannot create object of type "cat". The argument "container"
# does not belong to the set "Container,TextBlock"
[jsonItem]@{ Type = 'cat' } | ConvertTo-Json

[jsonItem]::new('container', '9.3') | ConvertTo-Json


[jsonContainer]@{ 
    Items = @(
        [jsonItem]::New()

        [jsonItem]::New( 'TextBlock', 4.5)
        
        [jsonItem]::New( 'invalid', 'z') # "Type": "The argument "invalid" does not belong to the set "Container,TextBlock"
    )
} | ConvertTo-Json

return

enum itemType {
    Container
    TextBlock
}



hr


class jsonContainer2 {
    [ValidateNotNull()]
    [itemType]$Type = 'Container'    

    [object[]]$Items = @()
}
class jsonItem2 {
    [ValidateSet('Container', 'TextBlock')]
    [string]$Type = ''
    [string]$Weight 
}