
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

$bases =
    'c:\a', 'c:\foo\bin', 'c:\temp'
        | Sort-Object -Unique
        | CountOf 'Bases'

$all_items = @(
        'g:\foo', 'c:\foo\dist\bin', 'c:\b', 'c:\e\z', 'c:\aa\b'
        'c:\foo\bar', 'c:\bar\dist\foo', 'c:\temp\foo\bar',
        'c:\foo\bin\bar\a', 'c:\tempstuff'
    )
        | Sort-Object -Unique
        | CountOf 'AllItems'

$prefixes = foreach($pattern in $bases) {
    '^' + [regex]::Escape($pattern)
}

h1 'Example0: ...'

$bases      | CountOf 'bases' | Grid
$all_items  | CountOf 'all'   | Grid


h1 'Example1: -Regex: using Block{ Block{} }'

foreach($item in $all_items) {
   foreach($regex in $prefixes) {
      if($item -match $regex) { $item; break; }
   }
}

h1 'Example2: -Regex: using Func{ Block{} }'

$all_items | ?{
   foreach($regex in $prefixes) {
      if($_ -match $regex) { return $true; }
   }
}


return
    # | Sort-Object -Unique
    # | CountOf 'all'
<#

h1 'Example3: -like: Func{ Block{} }'

$all_items | ?{
    foreach($pattern in $bases) {
        # @{ L = $_ ; R = $pattern; } | Json | write-host -bg darkred
        $_ -like "*${pattern}*" | Test-AnyTrue
    }
}


$all_items | %{
    foreach($pattern in $bases) {
        # @{ L = $_ ; R = $pattern; } | Json | write-host -bg darkred
        $_ -like "*${pattern}*" | Test-AllTrue
    }
}


 #| CountOf 'prefixes'

$all_items | %{
    $cur  = $_
    foreach($pattern in $bases) {
        # @{ L = $cur ; R = $pattern; } | Json | write-host -bg darkred
        $cur -like "*${pattern}*" | Test-AnyTrue
    }
}

return

$strings | ?{ ( $_ -like "*${match}*" ) -eq $true }.count -gt 0
$filtered = $others | ?{
    (( $_ -like "*${_}*" ) -eq $true ).count -gt 0
}
#>