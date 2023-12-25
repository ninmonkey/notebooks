Import-Module NameIt -ea 'stop'

'Weird stuff with String builders' | write-host -fg '#745074' -bg '#555759'
'Weird stuff with String builders' | write-host -fg '#745074' -bg '#7aa1b9'
'Weird stuff with String builders' | write-host -fg '#745074' -bg '#2e3440'
# SillyStringBuilderParams

function AsBuilder {
    param( [Text.StringBuilder]$InText )
    $name = Get-Process | % Name | Get-Random
    [void]$InText.AppendLine( $Name )
    [void]$inText.Append( ( $strId++ ))

    return $InText
    # return $inText.ToString()
}

function SB.Append {
    # you can pass regular strings to string builder parameters
    param(
        [Parameter(Mandatory)]
        [Alias('Str', 'Text', 'InObj', 'String', 'Name', 'ToString')]
        [Text.StringBuilder]$InSb,

        [Alias('Str', 'Text', 'InObj', 'String', 'Name', 'ToString')]
        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [string[]]$InputObject
    )

    # $InText.AppendLine(
}
