using namespace System.Management.Automation
$dir = Get-Item . ; $file = Get-ChildItem . -File | Select-Object -First 1

@'
Summarize using

    $error[1] |  Get-Error | io -SortBy Name | ft Name, ShortType, ShortValue, is*, Value -AutoSize

'@

function eyeIt {

    $val = $Input ?? $global:error[0]
    $val | Get-Error
    | io -SortBy Name -SkipMost -SkipPrimitive
    | Format-Table Name, ShortType, ShortValue, is*, Value -AutoSize


    #     $Input | Get-
    #     <##>
    # $err    or[1] |  Get-Error | io -SortBy Type -SkipMost -SkipPrimitive | ft Name, ShortType, ShortValue, is*, Value -AutoSize
    #     $err    or[1] |  Get-Error | io -SortBy Type -SkipMost -SkipPrimitive | ft Name, ShortType, ShortValue, is*, Value -AutoSize

}

function Resolve-FileInfo {
    <#
    .notes
        inheritance:
            FileInfo : FileSystemInfo
            DirectoryInfo : FileSystemInfo

        Pwsh>
            gi 'c:\foo\bar'


        Err
            $error[0].CategoryInfo

            Cannot find path 'C:\foo\bar' because it does not exist.

                Category   : ObjectNotFound
                Activity   : Get-Item
                Reason     : ItemNotFoundException
                TargetName : C:\foo\bar
                TargetType : String
    .LINK
        https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/get-error?view=powershell-7
    .LINK
        https://learn.microsoft.com/en-us/powershell/scripting/learn/deep-dives/everything-about-exceptions?view=powershell-7
    .link
        https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/write-error?view=powershell-7
    #>

    [cmdletbinding()]
    [OutputType('IO.FileSystemInfo')]
    param(
        [Alias('PSPath')]
        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [object]$Path,

        [switch]$Directory
    )
    process {
        try {
            $maybeItem = Get-Item -ea stop $Path
            return $maybeItem
            # } catch [IO.PathNotFound] {
        } catch [System.Management.Automation.ItemNotFoundException] {
            Write-Debug "[ItemNotFoundException] gi => s $_"
            return $Path
        } catch {
            "UnhandledException: Gi -> $_" | Write-Warning
            return $Path
        }
        if ($Directory) {
            return [IO.DirectoryInfo]::new( $Path )
        } else {
            return [IO.FileInfo]::new( $Path )
        }
    }
}


Resolve-FileInfo 'c:/foo/bar', (Get-Item .), '.' -ov 'res'
Hr
$samples = @(
    'c:/foo/bar', (Get-Item .), '.'
    '~'
    'C:\nin_temp'
)
$samples | Resolve-FileInfo -ov 'res'
$res | Group-Object { $_.GetType() } | Format-Table -auto
return

# (Get-Item 'env')
Resolve-FileInfo 'c:/foo/bar', 'fg:\red'

Resolve-FileInfo 'c:\red', (Get-Item 'env')3！7.2.6 C:\nin_temp\now
Pwsh> $error[2] | io | Format-Table Type, Name, Value

Get-Content Name Value
