
$script:CountersList ??= @{}

function TestCoal {
    [CmdletBinding()]
    param(
        [Parameter(Position = 0)]
        [Alias('Pt')]
        [string]$ParamText
    )
    $meta = [ordered]@{
        PSTypeName = 'Silly.ParamSwitch.CompareResult'
        TrueNull =
            $Null -eq $ParamText

        # TrueEmptyString =
        Len = ( $ParamText )?.Length ?? 'null'
        EmptyStr =
            $ParamText -is 'string' -and $ParamText.Length -eq 0
        BoundKeyName =
            $PSBoundParameters.ContainsKey('ParamText')
        BoundKeyAlias =
            $PSBoundParameters.ContainsKey('Pt')
        PSBound =
            $PSBoundParameters | ConvertTo-Json -depth 2 -Compress
    }

    return [pscustomobject]$meta
}
function TestCoalSwitch {
    [CmdletBinding()]
    param(
        [Parameter(Position = 0)]
        [Alias('St')]
        [switch]$ParamState
    )
    $meta = [ordered]@{
        PSTypeName = 'Silly.ParamSwitch.CompareResult'
        TrueNull =
            $Null -eq $ParamState

        # TrueEmptyString =
        Len = ( $ParamState )?.Length ?? 'null'
        EmptyStr =
            $ParamState -is 'string' -and $ParamState.Length -eq 0
        BoundKeyName =
            $PSBoundParameters.ContainsKey('ParamState')
        BoundKeyAlias =
            $PSBoundParameters.ContainsKey('St')
        PSBound =
            $PSBoundParameters | ConvertTo-Json -depth 2 -Compress
    }

    return [pscustomobject]$meta
}

function AddLabel {
    <#
    .SYNOPSIS
        add properties, or, names to results
    .EXAMPLE
        gci . | select Name, Length
            | AddLabel -Name 'User' -Value 'Bob'
    .EXAMPLE
        gci . | select Name, Length
            | AddLabel -Name 'test' -AsCounter -ResetCounter
    .EXAMPLE
        gci . | select Name, Length
            | AddLabel -Name 'test' -AsCounter
    #>
    param(
        [Parameter(Position=0)]
        [Alias('Text')]
        [ValidateNotNull()]
        [string]$Value,

        [Alias('Key')]
        [ValidateNotNull()]
        [string]$Name = 'Name',

        [Parameter(ValueFromPipeline)]
        [object]$InputObject,

        [switch]$AsCounter,
        [switch]$ResetCounter
    )
    begin {
        if($AsCounter) {
            $script:CountersList[ $Name ] ??= 0
            if($ResetCounter) {
                $script:CountersList[ $Name ] = 0
            }
        }
    }
    process {
        $members = [ordered]@{}
        if( -not $AsCounter ) {
            $members[ $Name ] = $Value
        } else {
            # $script:CountersList[ $Name ] ??= 0
            $members[ $Name ] = $script:CountersList[ $Name ]++
        }
        # $members = @{
        #     $LabelName = $Label
        # }

        $InputObject
            | Add-Member -Pass -Force -TypeName 'SillyLabel' -NotePropertyMembers $members # sorry
    }
}
# [List[Object]]$results = @()

#     TestCoal -Pt 'foo'

hr -fg Magenta
[object[]]$Results =
    @(
        TestCoal
        TestCoal -ParamText 'foo'
        TestCoal -ParamText $Null
    )
        | AddLabel -name 'Order' -AsCounter -ResetCounter
        | AddLabel -Name 'TestName' -Value 'StringParam'
        | AddLabel -Name 'Desc' -Value 'Comparing whether PSBound diverges on params as alias, first full name'

$Results += # forgive me
    @(
        TestCoal
        TestCoal -Pt 'foo'
        TestCoal -Pt $Null
    )
        | AddLabel -name 'Order' -AsCounter
        | AddLabel -Name 'TestName' -Value 'StringParamAlias'
        | AddLabel -Name 'Desc' -Value 'Comparing whether PSBound diverges on params as alias, using param alias'

$results | ft -auto
hr -fg Orange
$Results2 = @()
$Results2 +=
    @(
        TestCoalSwitch
        TestCoalSwitch -ParamState
        TestCoalSwitch -ParamState:$true
        TestCoalSwitch -ParamState:$false
        TestCoalSwitch -ParamState:$null
    )
        | AddLabel -name 'Order' -AsCounter -ResetCounter
        | AddLabel -Name 'TestName' -Value 'SwitchParam'
        | AddLabel -Name 'Desc' -Value 'Comparing whether PSBound diverges on params as alias, first full name'

$Results2 += # forgive me
    @(
        TestCoalSwitch
        TestCoalSwitch -St
        TestCoalSwitch -St:$true
        TestCoalSwitch -St:$false
        TestCoalSwitch -St:$null
    )
        | AddLabel -name 'Order' -AsCounter -ResetCounter
        | AddLabel -Name 'TestName' -Value 'SwitchParamAlias'
        | AddLabel -Name 'Desc' -Value 'Comparing whether PSBound diverges on params as alias, first full name'

function Format-RenderBool {
    <#
    .SYNOPSIS
        hack, do not use for anything. mutates object, summarizes bools as symbols
    #>
    param(
        [Parameter(ValueFromPipeline)]
        [object[]]$InputObject
    )
    begin {
        $c = @{
            Red = "${fg:#8b6756}"
            Green = "${fg:#445a49}"
        }

    }
    process {
        foreach($CurObj in $InputObject) {
            $CurObj.PSObject.Properties | %{
                $CurProp = $_
                $Val = $CurProp.Value
                # if( $Val -is 'string')  {
                #     $newVal = 'stuff'
                #     # $newVal =
                #     #     $val -replace 'true|ok|\b1\b|yes', {
                #     #             @(
                #     #                 $c.Red
                #     #                 $_
                #     #                 "${fg:reset}"
                #     #             ) -join ''
                #     #         }
                #     # $newVal = $val -replace 'true', 'y'

                # }
                if($Val -is 'bool') {
                    $NewVal = switch ( $Val ) {
                        { $_ -eq $true -or $_ -match 'true|ok|\b1\b|yes' } {
                            @(
                                $c.Green
                                $Switch # $Val
                                '✔'
                            ) -join ''
                        }
                        { $null -eq $_ -or  $_ -eq $false -or $_ -match 'false|0|\no' } {
                            @(
                                $c.Red
                                $Switch # $Val
                                '✘'
                            ) -join ''
                        }
                        default {
                            $Switch # $val
                                                        # @(
                            #     $c.Red
                            #     $Switch # $Val
                            #     '✘'
                            # ) -join ''
                        }
                    }
                    # $newVal =
                    #     $Val -replace 'True', '✔' -replace 'False', '✘'

                    #     $Val -replace 'True', '✔' -replace 'False', '✘'

                    $curProp.Value = $newVal
                    #  @(
                    #     $c.Red
                    #     $newVal
                    # ) -join ''
                }
            }
            $curObj
        }
    }
}


$results | ft -auto
$results2 | ft -auto
hr -fg 'blue'
$results2
    | Format-RenderBool
    | ft -auto

return



















$results2 = @(
    TestCoal
    TestCoal -ParamText 'foo'
)
    | AddLabel -name 'Order' -AsCounter
    | AddLabel -Name 'TestName' -Value 'StringAsParam'
    | AddLabel -Name 'Desc' -Value 'Comparing whether PSBound diverges on params as alias'

$results | ft -auto