$regKeyPaths = @(
    "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows Defender",
    'Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System',
    'Registry::HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\CI\Config'
)
$iterCount = 0
# Loop through each registry path
$query =  @( foreach ($regPath in $regKeyPaths) {
    $result = [ordered]@{
        Iter     = ($IterCount++)
        HasError = $false
        NoProps  = $true
        NoValues = $true
        Path     = $RegPath
    }
    try {
        $result.ItemProps = Get-ItemProperty -Path $regPath
        $result.Values    = $result.ItemProps |
            Select-Object -ExcludeProperty PSPath, PSParentPath, PSChildName, PSProvider
    } catch {
        $result.HasError = $true
    } finally {
        $result.NoProps  = $result.ItemProps.Count -eq 0
        $result.NoValues = $result.Values.Count -eq 0
        [pscustomobject]$result
    }
})

$query|Ft -auto
$Query.count

# then you can drill down into individual queries
$Query[0]
