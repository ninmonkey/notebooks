#require -Modules 'Pansies'

. (gi 'H:\data\2023\dotfiles.2023\pwsh\src\autoloadNow_butRefactor.ps1')



class FzfChoice {
    [string]$Name
    [string]$Details
    hidden [hashtable]$Metadata # tagged info, maybe GUIDs

    FzfChoice([string]$Name) {
        $this.Name = $Name
        if ( [string]::IsNullOrEmpty($this.Details) ) {
            $this.Details = '[empty]'
        }
    }
    FzfChoice([string]$Name, [string]$Details) {
        $this.Name = $Name
        $this.Details = $Details
        if ( [string]::IsNullOrEmpty($this.Details) ) {
            $this.Details = '[empty]'
        }
    }
    FzfChoice([string]$Name, [string]$Details, [hashtable]$Metadata) {
        $this.Name = $Name
        $this.Details = $Details
        $this.Metadata = $Metadata ?? @{}
        if ( [string]::IsNullOrEmpty($this.Details) ) {
            $this.Details = '[empty]'
        }
    }
    [string] ToString() {
        return $this.Name
    }
    [string] ToAnsiString() {
        $Color = @{
            Fg          = ${fg:gray70}
            FgPrimary   = ${fg:gray80}
            FgSecondary = ${fg:gray30}
        }
        $VisibleJoiner = ' '
        # write color $PSStyle propery  OwnerPair as gray and Description as yellow
        $render =
        @(
            $Color.Fg
            if( $this.Metadata.Prefix ) {
                $this.Metadata.Prefix
                $VisibleJoiner
            }
            $Color.FgPrimary
            $this.Name
            $VisibleJoiner

            $Color.FgSecondary
            $this.Details
            $VisibleJoiner
            $script:PSStyle.Reset
            '.'

            # ${fg:gray80}
            # $_.OwnerPair
            # ${fg:gray30}
            # $Cfg.Delim
            # $_.description
        ) -join ''

        return $render
    }
}

function Pick-Object {
    <#
    selects objects piped from fzf -m
    #>
    [Alias('Pick-Object-v2')]
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
            # 'echo {}' # basic

            $script:cacheView
            # '$script:cacheView'
            # 'echo {}'
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
$script:__fzfPreviewCache ??= @{}
function renderPreviewForRepoDescription {
    <#
    .SYNOPSIS
        recieves a repo name,
    .example
        renderPreviewForRepoDescription ninmonkey/pynin
        renderPreviewForRepoDescription ExcelAnt
    #>
    [Alias('gh.repo.View')]
    [CmdletBinding()]
    param( [string]$RepoName )

    $cache = $script:__fzfPreviewCache
    if( -not $cache.ContainsKey($RepoName) ) {
        '{0} is not cached, requesting...'
        | write-warning

        $renderResponse = & gh @(
            'repo'
            'view'
            $RepoName
        ) # *>&1
        | bat -p

        $cache[$RepoName] = $renderResponse
    }
    return $cache[$RepoName] # $cache = gh repo view marking *>&1 |bat -p

}

# render test
# $selected = $records | Pick-Object -PropertyName OwnerPair -DetailsProperty When | fzf -m
$records ??= gh.repo.List sql-bi
'hard coded render test'
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
$records | Pick-Object -PropertyName 'OwnerPair' -detailsProperty 'Description'
#  | Out-GridView -Title 'Pick a repo' -PassThru | % { $_.name }\