[hashtable]$script:Cache = @{}
$Cache.Modules = Get-Module
$Cache.Cults = Get-Culture -ListAvailable
$Cache.User = 'nin'

function FormatTooltip {
    [outputType('String')]
    param( $Obj )

    $Name = $Obj.GetType().Name
    $Len = $Obj.Count
    $FirstChild = @( $Obj )[0]?.GetType().Name
    [string]$Render = @"
Type: $Name [ Namespace: $Namespace ]
Len: $Len
FirstChild: $FirstChild $(
    @( $Obj )[0]?.GetType().Namespace
)
Enumerable? $(
    [System.Management.Automation.LanguagePrimitives]::IsObjectEnumerable( $Obj )
)
"@
    return $render
}
class DynamicKeyArgumentCompleter : System.Management.Automation.IArgumentCompleter {
    <#
        it supports names with spaces
    #>
    [IEnumerable[CompletionResult]] CompleteArgument(
        [string] $CommandName,
        [string] $ParameterName,
        [string] $WordToComplete,
        [CommandAst] $CommandAst,
        [IDictionary] $FakeBoundParameters
    ) {
        [List[CompletionResult]]$Completions = @()
        $script:Cache.GetEnumerator() | % {
            $toMatch = $_.Key
            $toCompleteAs  = $_.key
            $tooltip = FormatTooltip $Cache[$_.Key]
            if( $toMatch -notmatch [regex]::escape( $WordToComplete )) {
                return
            }
            $Completions.Add(
                [CompletionResult]::new(
                    $toCompleteAs,
                    $toMatch,
                    'ParameterValue',
                    $tooltip
                ) )
        }
        return $Completions
    }
}
function DynamicTooltip {
    [CmdletBinding()]
    param(
        [Parameter(Position=0, Mandatory)]
            [Alias('Name')]
            [ArgumentCompleter( [DynamicKeyArgumentCompleter] )]
            [string]$KeyName,
            [switch]$ErrorWhenMissing
    )
    [bool]$exists? = $script:Cache.ContainsKey( $KeyName )
    if( $ErrorWhenMissing -and -not $exists? ) {
        $KeyName
            | Join-String -f 'CacheMe::_Read: Tried reading from a key that does not exist! Key = "{0}"'
            | Write-Error
                # | Write-Debug
    }
    return $script:Cache[ $KeyName ]
}
'
to use, type:

    DynamicTooltip <ctrl+space>
'
