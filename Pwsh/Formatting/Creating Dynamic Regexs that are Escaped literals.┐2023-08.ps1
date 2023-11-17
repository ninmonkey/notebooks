# First I create two hastables to store my patterns
# $Extensions gives the file names
# $Regex will contain regex patterns
# I'm using the Pwsh syntax for pipeline prefixes for readability
# but most of this code is easily convertable to WinPS
# the only issues should be Join-String, but that's easy to replace
# it's essentially sugar for -join ''
$regex = @{}
$extensions = @{
    IsNotMusic = @(
         '.3gp', '.aiff', '.ape', '.dsd', '.flac', '.mp3', '.mp4',
         '.ra', '.ogg', '.opus', '.tta', '.wav', '.wma', '.wv'
    )
    IsMusic = @(
        '.3gp', '.aiff', '.ape', '.dsd', '.flac', '.mp3', '.mp4', '.ra',
        '.ogg', '.opus', '.tta', '.wav', '.wma', '.wv'
    )
}

function Summarize.Extensions {
    param(
        [Parameter(Mandatory, ValueFromPipeline)]
        [hashtable]$InputObject
    )
    process {
    # $Extensions.GetEnumerator() | %{
        $InputObject.GetEnumerator() | %{
            $joinStringSplat = @{
                InputObject  = $_.Value
                OutputPrefix = "{0} => " -f $_.Key
                Separator    = ', '
            }

            Join-String @joinStringSplat
        }
    }
}

function fileCategory {
    param(

    )
    {
        switch($Extension) {
            default {}
        }
}
}

gci . %| {
    switch($_.Extension) {
        default {}
    }
}

return
$extensions | Summarize.Extensions
<# output
IsNotMusic => .3gp, .aiff, .ape, .dsd, .flac, .mp3, .mp4, .ra, .ogg, .opus, .tta, .wav, .wma, .wv
IsMusic => .3gp, .aiff, .ape, .dsd, .flac, .mp3, .mp4, .ra, .ogg, .opus, .tta, .wav, .wma, .wv
#>

$regex.IsMusic =
    $extension.IsMusic
        | %{ [regex]::Escape( $_ ) }
        | Join-String -sep '|'

# you couold make the pattern match only endings for use onfull file names
$regex.IsMusic_FullName =
    $extension.IsMusic
        | %{
            '({0})$' -f  [Regex]::Escape( $_ )
        }
        | Join-String -sep '|'


function newRegexLiteral {
    [OutputType('String')]
    param(
        [ValidateSet('AlwaysEnding', 'FullMatch', 'NoAnchor')]
        [Parameter(Mandatory)]
        [string]$OutputFormat
        # [switch]$WrapItems
    )
    # normally you'd avoid $input, but in super simple functions its sort of sugar
    $items = @( $Input  )
    if( -not $WrapItems ) {
        $items
            | %{ [regex]::Escape( $_ ) }
            | Join-String -sep '|'
        return
    }
    $formatString = @{
        AlwaysEnding = '({0}$)'
        FullMatch    = '^({0}$)'
        NoAnchor     = '({0})'
    }

    if($OutputFormat) {
        $template = $FormatString.$OutputFormat
        $items
            | Join-String -sep '|' {
                $template -f  [Regex]::Escape( $_ )
            }
    }

    $items
        | Join-String -sep '|' { '({0})' -f  [Regex]::Escape( $_ ) }
}



# return


# # This store our regular expressions
# $Regex.isNotMusic = @(

#     | %{ [regex]::Escape( $_ ) }
#     | Join-String -sep '|'
# )
# $nonMusicExtensions -replace '\.', '\.' -join '|'


