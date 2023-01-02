$Paths = @{
    Source = Join-Path $PSScriptRoot 'discord_parse_markdown.md' | Get-Item -ea stop
}

$Paths

$Doc = ConvertFrom-Markdown -Path $Paths.Source -Verbose
$doc
$doc | io | Format-List *name*, *type*, *reported*, *Value*

