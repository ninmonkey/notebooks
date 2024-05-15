Add-Type -AssemblyName System.Windows.Forms

[Windows.Forms.OpenFileDialog]$Dlg = @{
    InitialDirectory = get-item $PSScriptRoot
    Title = 'select file to upload'
    Filter = 'ZIP files|*.zip|Text Documents|*.txt|Shell Scripts|*.*sh|All Files|*.*'
    FilterIndex = 4

    AddToRecent      = $false
    CheckFileExists  = $true
    CheckPathExists  = $true
    Multiselect      = $false
    ShowHelp         = $true
    ShowHiddenFiles  = $false
    ShowPinnedPlaces = $true
    ShowPreview      = $true
}

$Dlg.ShowDialog() | Out-null
'You chose file[s]: {0}' -f $Dlg.FileNames -join ', '
