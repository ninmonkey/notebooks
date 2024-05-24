Add-Type -AssemblyName PresentationFramework
$xaml = [xml]@'
<?xml version="1.0" encoding="utf-8"?>
<Window
 xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
 xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
 Width="350" Height="350">
    <DockPanel>
        <Image Name="Chart" Width="350" Height="270" DockPanel.Dock="Top" />
        <Button Name="Run" Content="Run" DockPanel.Dock="Bottom" />
    </DockPanel>
</Window>
'@

$window = [System.Windows.Markup.XamlReader]::Load(
    [System.Xml.XmlNodeReader]$xaml )

function Get-Chart {
    # returns as a Uri for the form
    param( [string]$Path = 'H:\data\2024\art\Walls\2017\2017-09-07 tileable fractal elephant.png')
    $Path = Get-Item -ea 'stop' $Path
    [Uri]( ('file://{0}' -f $Path) )
}
$window = [Windows.Markup.XamlReader]::Load(
    [Xml.XmlNodeReader]$xaml
)

$button = $window.FindName('Run')
$image  = $window.FindName('Chart')
# $this is [Windows.Controls.Button], image is a [Windows.Controls.Image], Get-Chart is a [Uri], [Windows.Controls.Button]
$button.Add_Click{
    $image.Source = [System.Windows.Media.Imaging.BitMapImage]::new( (Get-chart) )
}

$window.ShowDialog()
