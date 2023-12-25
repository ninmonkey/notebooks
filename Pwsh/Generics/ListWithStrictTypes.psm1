class ColorInfo {
    [RgbColor]$Fg
    [RgbColor]$Bg
    [string] ToString() {
        return $this.Ansi(
            ($this | Join-String -p { $_.fg, $_.Bg, $_.X11ColorName } ) )
    }
    [string] Ansi( [string]$Text ) {
        return New-Text -Object $Text -fg $this.fg -bg $This.bg | Join-String
    }
}



function Colors.Pairs.List {
    [List[ColorInfo]]$pairs = @(
        [ColorInfo]@{
            Fg = '#6e99aa'
            Bg = '#9e3232'
        }
    )
    return $pairs
}
function Colors.Pairs.List2 {
    [List[ColorInfo]]$final = @()
    [List[ColorInfo]]$pairs = @(
        [ColorInfo]@{
            Fg = '#6e99aa'
            Bg = '#9e3232'
        }
    )

    foreach($cur in $Pairs) {
        $final.Add( $cur )

        $final.AddRange([ColorInfo[]]@(
            [ColorInfo]@{
                Fg = $cur.Fg.GetComplement($false, $false)
                Bg = $cur.Bg
            }
            [ColorInfo]@{
                Fg = $cur.Fg
                Bg = $cur.Bg.GetComplement($false, $false)
            }

        ))
    }

    return $final
}

Export-ModuleMember -func @(
    '*'
    'list.Pairs'
)
