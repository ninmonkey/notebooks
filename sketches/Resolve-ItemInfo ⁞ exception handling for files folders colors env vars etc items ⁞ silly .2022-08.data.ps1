using namespace System.Management.Automation

throw 'actually, this is probably duplicate of <C:\Users\cppmo_000\SkyDrive\Documents\2022\My_Github\notebooks\sketches\experiment\InspectingExceptionTypes  - WhenUsingFakeItemPaths.ps1>'


$dir = Get-Item . ; $file = Get-ChildItem . -File | Select-Object -First 1



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

Resolve-FileInfo 'c:\red', (Get-Item 'env')
return;
function Resolve-FileInfo.0 {
    [OutputType('IO.FileSystemInfo')]
    param(
        [Parameter(Mandatory)]
        [string]$Path,

        [switch]$Directory
    )
    process {
        try {
            if ($Directory) {
                [System.IO.DirectoryInfo]::new('c:\')
            }
            $maybeItem = Get-Item $Path
        } catch [PathNotFound] {
            return $Path
        }
        return $maybeItem
    }
}


Resolve-FileInfo 'c:/foo/bar', 'fg:\red', (Get-Item 'env')

Resolve-FileInfo 'c:\red', (Get-Item 'env')
return


# # $p = 'temp:\1.png', 'temp:\2.png'
# # # $resp = Invoke-Re
# # stMethod -Uri http.org/img/png -Headers @{ 'accept' = 'image/png' }


# # switch ('cat') {
# #     { $_ } {
# #         0..4 | ForEach-Object {
# #             $_.GetType()
# #             $switch.GetType()
# #         }
# #     }
# #     default { }
# # }

# "C:\Users\rmcduffee\Desktop\Switch_Backups\$($Switch.Name)\$Date_config.txt"

# $name = 'foo'
# $dateConfig = '2343412'
# Join-Path 'C:\Users\rmcduffee\Desktop\Switch_Backups' $name "$dateConfig.txt"


Goto 'C:\nin_temp\now'
$invokeRestMethodSplat = @{
    Uri     = 'httpbin.org/image/png'
    Headers = @{ 'accept' = 'image/png' }
    # Verbose = $true
    # Infa    = 'Continue'
    # Debug   = $true
    # PassThru = $true    #OutFile = 'temp:\last.png'
}

$x1 ??= Invoke-RestMethod @invokeRestMethodSplat -OutFile (Join-Path (Get-Item .) './1.png')
$x2 ??= Invoke-RestMethod @invokeRestMethodSplat -OutFile (Join-Path (Get-Item .) './2.png') -PassThru
$x2 | Sc -Path (Join-Path (Get-Item .) '2_pass.png')
New-BurntToastNotification -Text 'Step1', 'Complete'
$x1, $x2 | ForEach-Object Gettype | Label 'items?'
Hr 3

$invokeRestMethodSplat = @{
    Uri     = 'httpbin.org/image/svg'
    Headers = @{ 'accept' = 'image/svg+xml' }
    # PassThru = $true    #OutFile = 'temp:\last.png'
}

$x4 ??= Invoke-RestMethod @invokeRestMethodSplat -OutFile (Join-Path (Get-Item .) './1.svg')
$x5 ??= Invoke-RestMethod @invokeRestMethodSplat -OutFile (Join-Path (Get-Item .) './2.svg') -PassThru
$x5 | Sc -Path (Join-Path (Get-Item .) '2_pass.svg')
New-BurntToastNotification -Text 'Step2', 'Complete'

$x4, $x5 | ForEach-Object Gettype | Label 'items?'

