using namespace System.Collections.Generic
using namespace System.Text
using namespace System.Text.Json
using namespace System.Text.Json.Serialization
$assembly = Add-type -AssemblyName System.Text.Json -PassThru -ea 'stop'

'If you made it this far, it should work'

[JsonAttribute].FullName
    | Should -Be 'System.Text.Json.Serialization.JsonAttribute'
