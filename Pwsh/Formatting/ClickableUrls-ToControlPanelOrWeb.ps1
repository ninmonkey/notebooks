<#
About:
    These all work on WindowsTerminal
    Other terms might support them but filter out urls by default, check your settings
#>

function Render.FileUrl { process { $_ | Join-String -f 'file:///{0}' } }

$file = Get-Item $PSCommandPath
# opens a file in an editor
$PSStyle.FormatHyperlink( 'edit-code', ($file | Render.FileUrl ) )

# opens control panel
$PSStyle.FormatHyperlink( 'sounds', 'ms-settings:sound')

# opens EverythingSearch query if you enabled the 'es' protocol in settings.  <https://www.voidtools.com/>
$PSStyle.FormatHyperlink( 'recent-items', 'es:dm:last2weeks ext:code-workspace' )
