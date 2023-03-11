
function Pick-Object {
    <#
    selects objects piped from fzf -m
    #>
    # [Alias('Pick-Object-v1')]
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, ValueFromPipeline)]
        [Object[]]$InputObject,


        # selector, name is a property of the object, or a script block
        [Parameter(Mandatory, position = 0)]
        $PropertyName,

        [Parameter(Mandatory, position = 1)]
        $DetailsProperty

        # is extra information but not the choice itself
    )
    begin {
        $binFzf = Get-Command 'fzf' -CommandType Application -ea stop
        [Collections.Generic.List[Object]]$FzfArgs = @(
            '--multi'
            '--ansi'
            '--preview-window=right:60%'
            '--preview'
            'echo {}'
        )
        [Collections.Generic.List[Object]]$Items = @()
        $Cfg = @{
            Delim      = ' ▸ '
            FancyColor = $false
        }
    }
    process {
        $items.AddRange( $InputObject )
    }
    end {
        $renderLines = $items | ForEach-Object {
            $name = $_.$PropertyName
            $details = $_.$DetailsProperty
            $renderLine = $_.$PropertyName, $_.$DetailsProperty | Join-String -sep $Cfg.Delim
            if (-not $Cfg.FancyColor) {
                return $renderLine
            }

        }
        $selected = $renderLines | & 'fzf' @fzfArgs

        $selected | ForEach-Object {
            $_ -split ([regex]::escape($Cfg.Delim)) | Select-Object -First 1
        }


    }
}


# render test
$records | s OwnerPair, When, Description | ForEach-Object {
    # write color $PSStyle propery  OwnerPair as gray and Description as yellow
    @(
        ${fg:gray70}
        ${fg:gray80}
        $_.OwnerPair
        ${fg:gray30}
        $Cfg.Delim
        $_.description
        $PSStyle.Reset
    ) -join ''



}

return
# $selected = $records | Pick-Object -PropertyName OwnerPair -DetailsProperty When | fzf -m
$records = gh.repo.List sql-bi
$records | Pick-Object -PropertyName 'OwnerPair' -detailsProperty 'Description'
#  | Out-GridView -Title 'Pick a repo' -PassThru | % { $_.name }\