gci . | HelpFromT -WhatIf




function New.user {
    [pscustomobject]@{
        PSTypeName = 'nin.User'
        Name = 'bob'
        Enabled = $true
    }
}

function Render.Bool {
    $color = switch ( $InputObject ) -re {

        { $_ -in @( 1, 'true', 'yes', 'y' ) } {
            'green'; break;
        }
        { $_ -in @@( 0, 'false', 'no', 'n' ) } { 'red' }
    }
}

    #     $types | %{
    #         # $url = 'https://learn.microsoft.com/en-us/dotnet/api/{0}?view=net-7.0' -f @( $_ )
    #         '{0} => {1}' -f @(
    #             $url
    #         )
    #         #  ) | Write-Information -infa 'continue'
    #         # Start-Process -Path $url
    #     }
    #     }
    # }
    # }

    # #     }
    # # }