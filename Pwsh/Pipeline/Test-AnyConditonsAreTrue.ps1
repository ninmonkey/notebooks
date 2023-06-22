
# Normally $Input is to be avoided [asterisk], but I used it here to be succinct
# @() may seem redundant, but it ensures the comparison is always used as a filter
#
# example: first iteration, with dedicated functions

# A question on naming, to you, does 'Any-True' mean zero-to-many true, or one-to-many true?
#
# Note when using non-booleans as inputs,
# When coercion is involved, names like Test-AllFalse and Test-NoneTrue are not exactly the same test
# Maybe I can improve precision by changing LHS/RHS operands
function Test-AnyTrue {
    # $true >= 1
    [Alias('Test-SomeTrue')]
    [OutputType('Boolean')]
    param()
    ( @($Input) -eq $true).Count -gt 0
}
function Test-AnyFalse {
    # $false >= 1
    [Alias('Test-SomeFalse')]
    [OutputType('Boolean')]
    param()
    ( @($Input) -eq $false).Count -gt 0
}
function Test-AllTrue {
    # [Alias('Test-NoneFalse')]
    [OutputType('Boolean')]
    param()
    $all = $Input
    ( @($all) -eq $true).Count -eq $all.Count
}

function Test-AllFalse {
    [Alias('Test-NoneTrue')]
    [OutputType('Boolean')]
    param()
    $all = $Input
    ( @($all) -eq $false).Count -eq $all.Count
}

return
    $strings | ?{ ( $_ -like "*${match}*" ) -eq $true }.count -gt 0

$roots = 'c:\foo', 'c:\bar\dist', 'c:\temp'
$others = 'c:\foo\bar', 'c:\bar\dist\foo', 'c:\temp\foo\bar'

$filtered = $others | ?{
    (( $_ -like "*${_}*" ) -eq $true ).count -gt 0
}