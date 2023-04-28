## Control Flow and Error Handling

```ps1
function LoadConfig {
    [CmdletBinding()]
    param(
        # fatal if missing
        [Parameter(Mandatory)]
        [string]$RequiredImport,

        # extra user preferneces
        [Parameter()]
        [string]$OptionalImport
    )

    # if missing, exits function
    $pathRequired = Get-Item -ea 'stop' $RequiredImport

    # if missing, continues while printing an error
    if($PSBoundParameters.ContainsKey('OptionalImport')) {
        $pathExtra    = Get-Item -ea 'continue' $OptionalImport
    }

    # if missing, sometimes you don't show want to clog up the user's console
    # giving errors without ending execution

    # Here's an optional one that writes an error to the stream (but not visible)
    $pathExtraSilent = Get-Item 'foo/bar.json' -ea 'silentlyContinue'
    # and one that doesn't  don't show errors,
    $pathExtraSilent2 = Get-Item 'foo/bar.json' -ea 'ignore'

    #
    # Sometimes you need to quit even if erroraction is overriden
    $found = Get-Command 'WriteHr' -ea 'ignore'
    if(-not $found) {
        'Missing mandatory command: {0}' -f @( 'WriteHr') | Write-Error
        # here return is used for **control flow**
        return

    }

    # 'continue'
    WriteHr
    'hi world'
    WriteHr
}
```

## sample invokes

```ps1
LoadConfig -require 'config.json' -OptionalImport 'some bad path.json'
LoadConfig -require '.' -OptionalImport 'some bad path.json'
```

```ps1
function WriteHr {
    $w = $host.ui.RawUI.WindowSize.Width
    $chars = '-' * $w -join ''
    $padding = "`n" * 2
    $padding, $chars, $padding -join ''
}

LoadConfig -RequiredImport '.' -OptionalImport '.'
LoadConfig -RequiredImport '.' -OptionalImport 'some bad path.json'
LoadConfig -RequiredImport '.'
LoadConfig -RequiredImport 'bad path'
```