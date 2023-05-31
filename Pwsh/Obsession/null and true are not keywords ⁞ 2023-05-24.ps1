function Debug.Var
    { param( [ArgumentCompletions('null', 'true', 'false')]
             [string[]]$Name
    )
        # foreach($varName in $Name) {
        $Name | sort-object -Unique | %{
            $varName = $_
            $var_info = Get-Variable $varName ;
            $var_info
                | iot2 -NotSkipMost
                | out-string
                | Write-Information -InformationAction 'Continue'
            }
            return $var_info
    }

if($false) {
    get-variable | group Options
    ( $vinfo_null = Debug.Var Null )
    ( $vinfo_true = Debug.Var true )
    ( $vinfo_false= Debug.Var false )

# $info_null, $vinfo_true, $vinfo_false =
# hr

}
hr
get-variable | group Options

Get-Variable | group Description
        Debug.Var -Name null, true, false

$info_null,
    $vinfo_true,
    $vinfo_false =
        Debug.Var -Name null, true, false

hr -fg magenta

$g = Get-Variable | Group Description
$g  | select -Skip 1
| %{

    $_.Group.GetEnumerator()
    | Join-String   -op 'variableGroup = '
    | % Name | Join-String -sep ', '
    $_.Values
    "`n"
   #$_.Values | Join-String -sep ', '
}

$g2 = get-variable | group Options

function Dotils.Debug.FindVariable {
    <#
    .notes

    query kind:
        [System.Management.Automation.ScopedItemOptions]

    #>
    param(
        [ValidateSet(
            'All',
            'Under',
            'Dunder',
            'Constant'
            # 'InModuleScope'
        )]
        [Parameter(Mandatory, Position=0)]
        [string]$VariableKind,

        [Parameter(Position=1)]
        [ArgumentCompletions('0', '1', '2', '3', 'local', 'script', 'global')]
        $Scope = 0,

        [Parameter()]
        [ArgumentCompletions(
            'ImportExcel', 'Ninmonkey.Console', 'Typewriter', 'GitLogger'
        )]
        [string]$UsingModuleScope
    )

    # values of: System.Management.Automation.ScopedItemOptions
        # 'AllScope', 'Constant', 'None', 'Private', 'ReadOnly', 'Unspecified', 'value__'

    if($UsingModuleScope) {
        $query = &  ( Get-Module $UsingModuleScope  ) { Get-Variable -Scope $Scope }
    } else {
        $query = Get-Variable -Scope $Scope
    }

    $addMemberSplat = @{
            Force = $true
            ErrorAction = 'ignore'
            TypeName = 'Dotils.Debug.FindVariableRecord'
        }
    $scoped_enum = [System.Management.Automation.ScopedItemOptions]

    function hasBitFlag.Scoped {
        param(
            [Parameter(Mandatory, Position=0)]
            $InputObject,

            # [ArgumentCompletions('')]
            [Alias('Has')]
            [Parameter(Mandatory, Position=1)]
            [System.Management.Automation.ScopedItemOptions]$TestKind
        )
        <#
        original test
        $_.Options -band $scoped_enum::ReadOnly -eq $scoped_enum::ReadOnly
        #>
        # $InputObject -band $TestKind -ne 0
        ($InputObject -band $TestKind) -eq $TestKind
    }

    $query | %{
        $item = $_
        $newMembers = @{
            HasDesc = -not [String]::IsNullOrWhiteSpace( $item.Description )

            Has = @{
                ScopedOption = @{
                    'AllScope'    = hasBitFlag.Scoped $item.Options -TestKind AllScope
                    'Constant'    = hasBitFlag.Scoped $item.Options -TestKind Constant
                    'None'        = hasBitFlag.Scoped $item.Options -TestKind None
                    'Private'     = hasBitFlag.Scoped $item.Options -TestKind Private
                    'ReadOnly'    = hasBitFlag.Scoped $item.Options -TestKind ReadOnly
                    'Unspecified' = hasBitFlag.Scoped $item.Options -TestKind Unspecified
                }
            }
            Is = @{
                Constant = $item.IsConstant
                Private = $item.IsPrivate
                ReadOnly = $item.IsReadOnly
                Unspecified = $item.IsUnspecified
            }
        }
        $item | Add-Member @addMemberSplat $newMembers
    }


    # switch($VariableKind) {
    #     '' { Get-Variable -Name Foo }
    #     'bar' { Get-Variable -Name bar }
    #     'InModuleScope' {

    #     }
    #     default { throw "NotYetImplemented query kind: $VariableKind" }
    # }
}

# Dotils.Debug.FindVariable All -Scope 0 -UsingModuleScope ImportExcel
Dotils.Debug.FindVariable All -Scope 0
| Select -first 3
| Json