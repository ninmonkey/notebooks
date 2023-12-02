#requires -Modules Pansies
# Pushd $PSScriptRoot -ea 'ignore'
'
tangent after this discord thread: <https://discord.com/channels/180528040881815552/447475598911340559/1180410764075466793>
which mentions his WIP
    <https://github.com/JustinGrote/ModuleFast/blob/f6e2623c5db0edcad6576264d889475722b21a73/ModuleFast.psm1#L39>


template from: <https://github.com/ninmonkey/notebooks/tree/main/Pwsh/questions_from_discord/Passing%20Arrays%20as%20both%20Parameters%20and%20ValueFromPipeline>
'
$Conf = @{
    Compress = $true
}
$C = @{
    Fg = '#a4dcff'
    Fg2 = '#576e7d'
    Fg3 = '#c99176'
    Fg4 = '#3d9b69'
    Fg5 = '#d8821f'
    False = '#a84c1f'
    True = '#577859'
}
function Format.Bool {
    <#
    .SYNOPSIS
        'afs', $true, 'True', $false, 'truefalse', 'falsetrue' | Format.Bool
    #>
    # param( $Text )
    process {
        $Text = $_
        if($Text -match 'false') {
            $Text | New-Text -fg $c.False | Join-String ; return
        }
        if($Text -match 'true') {
            $Text | New-Text -fg $C.True | Join-String ; return
        }
        $Text
    }
}
$Str = @{
    TrueNull = "[␀.True]"
    Null = "[␀]"
    Empty = "[␠]"
    Blank = "[␠.Blank]"
}
function Format.Null {
    <#
    .SYNOPSIS
        render null-like values for the console
    .EXAMPLE
        $cases = "`n", '', "`u{0}", "`n", "a`nb", $Null, @(), $null
        foreach($cur in $cases) { $cur | Format.Null }
    #>
    # param( $Text )
    process {
        $Text = $_ # technically a maybe-text
        if($null -eq $Text) {
            return $Str.TrueNull
        }
        if( $Text -is 'string' -and [String]::IsNullOrEmpty( $Text ) ) {
            return $Str.Null
        }
        if( $Text -is 'string' -and [String]::IsNullOrWhiteSpace( $Text ) ) {
            return $Str.Empty
        }

        if( $Text -isnot 'string' -and [string]::IsNullOrWhiteSpace( $Text )) {
            return $Str.Blank
        }
        return $Text
    }
}



function Get-Test {
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(
            Mandatory,
            ParameterSetName = 'Specification', Position = 0, ValueFromPipeline)]
        [AllowEmptyCollection()]
        [AllowNull()]
        [int[]]
        $InputObject
    )
    begin {


        $JsonSplat = @{
            Compress = $Conf.Compress
            WarningAction = 'SilentlyContinue'
            Depth = 2
        }

        'Enter: -Begin' | Write-Host -fg $C.Fg4
        $PSBoundParameters
            | ConvertTo-Json @JsonSplat
            | Write-Host -fg $C.Fg3

        '   ExpectingInput? {0}' -f ( $PSCmdlet.MyInvocation.ExpectingInput | Format.Bool )
            | write-host -fg $C.Fg2
        '   ParameterSetName = {0}' -f $PSCmdlet.ParameterSetName
            | write-host -fg $C.Fg
    }
    process {
        'Enter: -Process' | Write-Host -fg $C.Fg4
        $PSBoundParameters
            | ConvertTo-Json @JsonSplat
            | Write-Host -fg $C.Fg3

        '   ExpectingInput? {0}' -f ( $PSCmdlet.MyInvocation.ExpectingInput | Format.Bool )
            | write-host -fg $C.Fg2
        '   ParameterSetName = {0}' -f $PSCmdlet.ParameterSetName
            | write-host -fg $C.Fg


        foreach ($item in $InputObject) {
            Write-Host "  Item: $item"
        }
    }
    end {
        'Enter: -End' | Write-Host -fg $C.Fg4
        $PSBoundParameters
            | ConvertTo-Json @JsonSplat
            | Write-Host -fg $C.Fg3

        '   ExpectingInput? {0}' -f ( $PSCmdlet.MyInvocation.ExpectingInput | Format.Bool )
            | write-host -fg $C.Fg2
        '   ParameterSetName = {0}' -f $PSCmdlet.ParameterSetName
            | write-host -fg $C.Fg



    }
}
function GetStuff {
    param(
        [ValidateSet(
            'Emit.Null',
            'Emit.Void',
            'NothingWithReturn',
            'NothingWithoutReturn',
            'AutomationNull'
        )]
        [string]$Mode
    )
    switch( $Mode) {
        'AutomationNull' {
            throw 'nyi: Find the right exception name'
        }
        {
            $_ -in @( 'Emit.Void', 'NothingWithoutReturn' )
        } {
            # no-op
        }
        'NothingWithReturn' {
            return
        }
        'Emit.Null' {
            return $Null
        }
        default { "throw: unhandled: $Mode" }
    }
}

$null | Get-Test -WhatIf -Verbose -Debug
,@()| Get-Test -Whatif -Verbose -Debug

# Get-Test
