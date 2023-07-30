[PoshCode.Pansies.Provider.RgbColorProvider]

Find-Type -FullName *RgbColorProvider* | % fullname
Find-Type -ImplementsInterface { [anyof[IPropertyCmdletProvider,ICmdletProviderSupportsHelp, IContentCmdletProvider]] }
Find-Type -ImplementsInterface {
    [anyof[
        Management.Automation.IResourceSupplier,
        Management.Automation.Provider.IPropertyCmdletProvider,
        Management.Automation.Provider.ICmdletProviderSupportsHelp,
        Management.Automation.Provider.IContentCmdletProvider] ]
 } | CountOf


$query = @{}
$query.RgbColorWildcard = @(
    Find-Type -FullName *RgbColorProvider* | % fullname
)

 Find-type -namespace Microsoft.PowerShell.Commands *provider*

find-type -FullName *provider*|% fullname | countof # 145

$bag = @{}
$Bag.JustOne = @(
    'RgbColorProvider'
        | .As.TypeInfo | CountOf
)
$Bag.ImplementsInterface = @(
    # 'IPropertyCmdletProvider'
    # 'ICmdletProviderSupportsHelp'
    # 'IContentCmdletProvider'
    'Management.Automation.IResourceSupplier'
    'Management.Automation.Provider.IPropertyCmdletProvider'
    'Management.Automation.Provider.ICmdletProviderSupportsHelp'
    'Management.Automation.Provider.IContentCmdletProvider'
)
   # | .As.TypeInfo | CountOf
# $Q =

function Dotils.Type.Info {
    [Alias('.As.TypeInfo')]
    [CmdletBinding()]
    param(
        [Parameter(ValueFromPipeline, mandatory)]
        [object]$InputObject,

        [switch]$CompareAsLower,

        [Alias('All')][switch]$WildCard
    )
    process {
        if(-not $WildCard -and ($InputObject -match '\*')) {
            write-error 'wildcard not enabled, are you sure?'
        }
        if($CompareAsLower) {
            $InputObject = $InputObject.ToLower()
        }
        $query = Find-Type $InputObject
        if(-not $query) { write-error 'failed type' ; return }
        return $query
    }
}