. (gi -ea stop 'H:\data\2022\Pwsh\My_Github\nintility\enter.psstyle.ps1')

# function ex.hi {
#     @(
#     # $PSStyle.Foreground.FromRgb( '#d8cd48' )

#     ) -join ''
# }
# $PSStyle.OutputRendering = 

# $PSStyle.OutputRendering = 'plaintext'
# $ENV:NO_COLOR 

$gray1 = .9 * 255
$gray2 = .7 * 255
$gray3 = .5 * 255
$gray4 = .3 * 255


$c = @{
    fgBright = $PSStyle.Foreground.FromRgb($gray1, $gray1, $gray1)
    fg       = $PSStyle.Foreground.FromRgb($gray2, $gray2, $gray2)
    fgDim    = $PSStyle.Foreground.FromRgb($gray3, $gray3, $gray3)
    fgDim2   = $PSStyle.Foreground.FromRgb($gray4, $gray4, $gray4)
    bgBright = $PSStyle.Background.FromRgb($gray1, $gray1, $gray1)
    bg       = $PSStyle.Background.FromRgb($gray2, $gray2, $gray2)
    bgDim    = $PSStyle.Background.FromRgb($gray3, $gray3, $gray3)
    bgDim2   = $PSStyle.Background.FromRgb($gray4, $gray4, $gray4)
    reset    = $PSStyle.Reset
}



function _renderMessage {
    param(
        [Parameter( Position = 0, ValueFromPipeline )]
        [String]$TextMessage
    )
    process { 
        @(
            $quote = '"' | Join-String -op $C.fgBright -os $c.reset
            $c.fgBright
            '"'    
            $c.fg
            $TextMessage
            $c.fgBright
            '"'    
            $c.fgBright
        )
    }
}


# $script:__original_OutputRendering = $PSStyle.OutputRendering