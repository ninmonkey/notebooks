
using namespace System.Collections.Generic
using namespace System.Text

Import-Module ClassExplorer -ea stop 

# $tinfoSB = find-type 'System.Text.StringBuilder'
$t = $tinfo_sb = [System.Text.StringBuilder]



[System.Text.StringBuilder]
| Find-Member -ParameterType { [Span[any]] }