$RunCfg = @{

    JsonToMd_OnlyRows = $false
}
$source_json = @'
{
    "powershell.helpCompletion": "BlockComment",
    "powershell.integratedConsole.focusConsoleOnExecute": true,
    "powershell.integratedConsole.forceClearScrollbackBuffer": false,
    "powershell.integratedConsole.showOnStartup": true,
    "powershell.integratedConsole.useLegacyReadLine": false,
    "powershell.startAutomatically": true,
    "terminal.integrated.allowChords": true,
    "terminal.integrated.customGlyphs": true,
    "terminal.integrated.defaultLocation": "editor",
    "terminal.integrated.fastScrollSensitivity": 5,
    "terminal.integrated.lineHeight": 1,
    "terminal.integrated.mouseWheelScrollSensitivity": 1,
    "terminal.integrated.persistentSessionReviveProcess": "never",
    "terminal.integrated.sendKeybindingsToShell": true,
    "terminal.integrated.shellIntegration.decorationsEnabled": "both", // new features: <https://code.visualstudio.com/updates/v1_66#_terminal-shell-integration
    "terminal.integrated.shellIntegration.history": 200,
    "terminal.integrated.smoothScrolling": true,
}
'@


if ( $RunCfg.JsonToMd ) {
    $doc = $source_json | ConvertFrom-Json
    $joinStr_MdTable_Row = @{
        Separator    = ' | '
        OutputPrefix = '| '
        OutputSuffix = ' |'
    }
    function md.NewTable.0 {
        param(
            $InputObject
        )

        $InputObject | io | ForEach-Object {
            $Td1 = $_.Name
            $Td2 = $_.Value


            $Td1, $Td2 | Join-String @joinStr_MdTable_Row
        }
    }

    md.NewTable $doc

}
if ( $RunCfg.JsonToMd_OnlyRows ) {
    $doc = $source_json | from->Json
    $joinStr_MdTable_Row = @{
        Separator    = ' | '
        OutputPrefix = '| '
        OutputSuffix = ' |'
    }
    function md.NewTable.0 {
        param(
            $InputObject
        )

        $InputObject | io | ForEach-Object {
            $Td1 = $_.Name
            $Td2 = $_.Value


            $Td1, $Td2 | Join-String @joinStr_MdTable_Row
        }
    }

    md.NewTable $doc
}