<# future: todo: . 2023-05-14
    find vars in script block
    ensure values null
    then output at the end
#>
function Run.Test {
    <#
    .example
        Run.Test -Expression { $x = 100; $y++; } -VariableNames 'x', 'y'
    #>
    param(
        [Parameter(Mandatory, Position = 0)]
        [string[]]$VariableNames,

        [Parameter(Mandatory, Position = 1)]
        [ScriptBlock]$Expression,

        [Parameter(Position = 2)]
        [ValidateSet('', 'Md.Table', 'Text.Table')]
        [string]$OutputMode = 'Text.Table'

    )

    $result = & {
        # should be redundant
        Remove-Variable $VariableNames -ea 'ignore'


        $state = & $Expression
        $result = Get-Variable -Name $VariableNames -ea ignore
        return $result
    }
    switch ($OutputMode) {
        'Md.Table' {
            $x = '.'

        }
        { $_ -in @('', 'Text.Table') } {
            $result | Format-Table -auto
            | Out-String | Write-Information -infa 'continue'
        }
        default {
            throw "UhandledOutputMode: $OutputMode"
        }
    }
}

# Run.Test -Expression { $x = 100; $y++; } -VariableNames 'x', 'y'

# Run.Test 'a' -Expression {
#     $x = 3
#     $y = $x * 3
# }

function Fmt.Md.Table {
    param(
        [object]$InputObject
    )
    throw 'left off'
}

function TestIt {
    param( [string[]]$VarName, [Alias('Expression')][scriptBlock]$ScriptBlock )
    if ( -not $VarName ) { $VarName = 'a'..'z' }
    Remove-Variable -Scope local -Name ('a'..'z') -ea ignore
    . $ScriptBlock
    Hr
    $ScriptBlock | bat -l ps1 --file-name 'Test'
    Get-Variable -Scope local -Name ('a'..'z') -ea ignore | Format-Table -AutoSize
}

function FormatTest {
    [CmdletBinding()]
    param(
        [Alias('ScriptBlock')][Parameter(Mandatory, ValueFromPipelineByPropertyName, ValueFromPipeline)]
        $Expression
    )
    process {
        TestIt -ScriptBlock $Expression
    }
}

@(
    { $a = $i++ }
    { $a = ++$i }
    { $a = $i++ }
) | FormatTest