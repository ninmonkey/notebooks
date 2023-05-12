Remove-Module pipescript, pipeworks -ea Ignore
function DoStuff {
    # first example is regular / non-cmdletbinding
    # in my test, $path does not exist in the script scope
    # so script:script is
    param(
        [Parameter(Mandatory)]
        [System.IO.FileSystemInfo]
        $Path
    )
    $Path.GetType()

    # 🔴 MetadataError: InvalidArgument
    # [sma.ArgumentTransformationMetadataException]
    $Path = '.'

    # 🟢 [System.IO.FileSystemInfo]
    $Path = Get-Item '.'
    $Path.GetType()

    [string]$Path = '.'
    # 🟢 [string]gm
    $Path.GetType()
}

function DoCmdletStuff {
    # this example is the behavior as non-cmdletbinding
    # in my test, $path does not exist in the script scope
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [System.IO.FileSystemInfo]
        $Path
    )
    $Path.GetType()

    # 🔴 MetadataError: InvalidArgument
    # [sma.ArgumentTransformationMetadataException]
    $Path = '.'

    # 🟢 [System.IO.FileSystemInfo]
    $Path = Get-Item '.'
    Wait-Debugger

    $Path.GetType()

    [string]$Path = '.'
    # 🟢 [string]
    $Path.GetType()
}

# see more: $PSCmdlet.MyInvocation.BoundParameters | iot2
# DoStuff -Path (Get-Item '.' )
DoCmdletStuff -Path (Get-Item '.' ) -ea Break


