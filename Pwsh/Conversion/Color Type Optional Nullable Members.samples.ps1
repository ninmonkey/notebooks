function __generateMany {
    [Collections.Generic.List[Object]]$Samples = @(
        @{ ColorString      = '#c99069'
            ExpectValidCtor = $true
            ExpectHasAlpha  = $false
        }
        @{ ColorString      = 'c99069'
            ExpectValidCtor = $true
            ExpectHasAlpha  = $false
        }
        @{ ColorString = '00000000'
            Expect     = @{
                IsValidCtor = $true
                HasAlpha    = $True
            }
        }
        @{ ColorString = '' ; Expect = @{
                IsValidCtor = $true
                HasAlpha    = $True
            }
        }
    )
}

__generateMany