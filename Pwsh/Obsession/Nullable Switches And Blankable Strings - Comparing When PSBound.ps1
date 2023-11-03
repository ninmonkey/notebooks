using namespace System.Collections.Generic

$script:CountersList ??= @{}
$binBat ??= Get-Command 'bat' -CommandType Application -TotalCount 1 -ea 'stop'

if( -not (gcm 'hr' -ea 'ignore')){
    function Hr {
        $w = $host.ui.RawUI.WindowSize.Width
        return '-' * $w -join ''
    }
}
if( -not (gcm 'Json.Colorize' -ea 'ignore')) {
    function Json.Colorize {
        <#
        .NOTES
            original:
                '{"ParamState":{"IsPresent":true}}' | bat -l json --force-colorization --style plain | echo
        #>
        param()

        [List[Object]]$BatArgs = @(
            # will use an Inline render, colors, without any headers
            '--language', 'json',
            '--force-colorization',
            '--style', 'plain'
        )

        return $Input | & $binBat @BatArgs
    }
}

function TestCoal {
    <#
    .synopsis
        Can you treat [switch] as a nullable bool, or not? Compare related case of empty string
    #>

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
    <#
    .synopsis
        Can you treat [switch] as a nullable bool, or not? Compare related case of empty string
    #>

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
if( -not (gcm 'Json.Colorize' -ea 'ignore')) {
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
        | AddLabel -name 'TestOrder' -AsCounter -ResetCounter
        | AddLabel -Name 'TestName' -Value 'String.FullName'
        | AddLabel -Name 'Desc' -Value 'Param As String, using full name'

$Results += # forgive me
    @(
        TestCoal
        TestCoal -Pt 'foo'
        TestCoal -Pt $Null
    )
        | AddLabel -name 'TestOrder' -AsCounter
        | AddLabel -Name 'TestName' -Value 'String.Alias'
        | AddLabel -Name 'Desc' -Value 'Param As String, using alias'

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
        | AddLabel -name 'TestOrder' -AsCounter -ResetCounter
        | AddLabel -Name 'TestName' -Value 'Switch.FullName'
        | AddLabel -Name 'Desc' -Value 'Param As Switch, using fullname'

$Results2 += # forgive me
    @(
        TestCoalSwitch
        TestCoalSwitch -St
        TestCoalSwitch -St:$true
        TestCoalSwitch -St:$false
        TestCoalSwitch -St:$null
    )
        | AddLabel -name 'TestOrder' -AsCounter -ResetCounter
        | AddLabel -Name 'TestName' -Value 'Switch.Alias'
        | AddLabel -Name 'Desc' -Value 'Param as Switch, using alias'

function Format-RenderBool.Inline {
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
                if($CurProp.Name -eq 'PSBound') {
                    $curProp.Value =
                        $val | Json.Colorize
                }
            }
            $curObj
        }
    }
}

$results
    | Format-RenderBool.Inline
    | ft -auto

hr -fg 'blue'

$results2
    | Format-RenderBool.Inline
    | ft -auto


'see $Results, and $Results2' | write-host -fore 'magenta'
# return


















# $results2 = @(
#     TestCoal
#     TestCoal -ParamText 'foo'
# )
#     | AddLabel -name 'Order' -AsCounter
#     | AddLabel -Name 'TestName' -Value 'StringAsParam'
#     | AddLabel -Name 'Desc' -Value 'Comparing whether PSBound diverges on params as alias'

# $results | ft -auto