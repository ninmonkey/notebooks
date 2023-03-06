# delims uni:

function enumerateSupportedEventNames {
    <#
    .SYNOPSIS
        get events from the objects metadata
    #>
    [Alias('prof.iterEvents')]
    param(
        [Parameter(Mandatory, ValueFromPipeline, position=0)]
        [object]$InputObject,
        # pretty print
        [switch]$AsText
    )
    end {
        $originalObject = $InputObject
        $origTypeName = $originalObject.GetType().FullName
        [Collections.Generic.List[Object]]$eventNames = $originalObject | Sort-Object { $_.GetType().FullName } -Unique
        | Get-Member -MemberType Event | ForEach-Object Name | sort -Unique
        if (-not $AsText) {
            return $eventNames
        }
        $eventNames
        | Join-String -op "PossibleEvents from a [$(  $origTypeName )]: `n  • " -sep "`n  • " -SingleQuote
    }
}

# booK:
Get-Process | enumerateSupportedEventNames -asText

$filewatcher = $null
if($Null -eq $fileWatcher ) {
    # $fileWatcher = [System.IO.FileSystemWatcher]::new('g:\temp\xl')
    $fileWatcher ??= [System.IO.FileSystemWatcher]::new('g:\temp\xl')
    Register-ObjectEvent -InputObject $fileWatcher -EventName 'Changed'
    Register-ObjectEvent -InputObject $fileWatcher -EventName 'Created'
}
$fileWatcher | enumerateSupportedEventNames -asText
hr
New-Item 'g:\temp\xl\fooo.txt' | out-null
hr

function prof.renderEvent {
    <#
    .EXAMPLE
    PS> Get-event | prof.renderEvent

    ChangeType FullPath             Name
    ---------- --------             ----
    Changed g:\temp\xl\other.png other.png

    ComputerName     :
    RunspaceId       : 061c6c83-4651-48a0-8716-e557e04b1670
    EventIdentifier  : 5
    Sender           : System.IO.FileSystemWatcher
    SourceEventArgs  : System.IO.FileSystemEventArgs
    SourceArgs       : {System.IO.FileSystemWatcher, other.png}
    SourceIdentifier : b3288091-6a90-4d98-9f5f-324a74ee139b
    TimeGenerated    : 2/25/2023 4:34:57 PM
    MessageData      :

    #>
    param()
    process {
        $_ | fl
        $_.SourceEventArgs | ft -auto
    }
}

Get-event | prof.renderEvent

throw 'finish me, sample is in the book'