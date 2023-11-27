
function ConvertTo-HSV {
    <#
    .synopsis
        example to demonstrate another way to pipe array values
    .NOTES
        from JustinGrote in discord: <https://discord.com/channels/180528040881815552/447476117629304853/1178486715581734993>
    .EXAMPLE
        Pwsh> $c =
            [Pscustomobject]@{
                Red = 100
                Green = 200
                Blue = 128
                Alpha = 9
            }

        Pwsh> $c

            Red Green Blue Alpha
            --- ----- ---- -----
            100   200  128     9

        Pwsh> $c | ConvertTo-HSV

            Hue Saturation Value
            --- ---------- -----
            136.80       0.48  0.59
    #>
    [CmdletBinding(DefaultParameterSetName='ByValue')]
    param (
        [Parameter(Mandatory, ValueFromPipelineByPropertyName, ParameterSetName='ByValue')]
        [ValidateRange(0, 255)]
        [int]$Red,

        [Parameter(Mandatory, ValueFromPipelineByPropertyName, ParameterSetName = 'ByValue')]
        [ValidateRange(0, 255)]
        [int]$Green,

        [Parameter(Mandatory, ValueFromPipelineByPropertyName, ParameterSetName = 'ByValue')]
        [ValidateRange(0, 255)]
        [int]$Blue,

        [Parameter(ValueFromPipelineByPropertyName, ParameterSetName = 'ByValue')]
        [ValidateRange(0, 255)]
        [int]$Alpha = 0,

        [Parameter(Mandatory, ValueFromPipeline, ParameterSetName='ByColor')]
        [System.Drawing.Color]$Color
    )

    process {

        if ($PSCmdlet.ParameterSetName -eq 'ByValue') {
            $Color = [Drawing.Color]::FromArgb($Alpha, $Red, $Green, $Blue)
        }

        [PSCustomObject]@{
            Hue        = $Color.GetHue()
            Saturation = $Color.GetSaturation()
            Value      = $Color.GetBrightness()
            PSTypeName = 'HSV'
        }
    }
}
$c =  [Pscustomobject]@{
    Red = 100
    Green = 200
    Blue = 128
    Alpha = 9
}


$c | ft -auto
$c | ConvertTo-HSV | ft -auto
