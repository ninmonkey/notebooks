$sb = {}
$sb2 = { }
[ordered]@{
    'IsNullOrEmpty $sb '       = [String]::IsNullOrEmpty( $sb )
    'IsNullOrWhiteSpace $sb '  = [String]::IsNullOrWhiteSpace( $sb )
    'IsNullOrEmpty {} '        = [String]::IsNullOrEmpty( {} )
    'IsNullOrWhiteSpace {} '   = [String]::IsNullOrWhiteSpace( {} )
    'IsNullOrEmpty $sb2 '      = [String]::IsNullOrEmpty( $sb2 )
    'IsNullOrWhiteSpace $sb2 ' = [String]::IsNullOrWhiteSpace( $sb2 )
    'IsNullOrEmpty { } '       = [String]::IsNullOrEmpty( { } )
    'IsNullOrWhiteSpace { } '  = [String]::IsNullOrWhiteSpace( { } )
}|ft -auto
hr
[ordered]@{
    'IsNullOrEmpty {} '        = [String]::IsNullOrEmpty( {} )
    'IsNullOrEmpty { } '       = [String]::IsNullOrEmpty( { } )
    'IsNullOrWhiteSpace {} '   = [String]::IsNullOrWhiteSpace( {} )
    'IsNullOrWhiteSpace { } '  = [String]::IsNullOrWhiteSpace( { } )
    'IsNullOrEmpty $sb '       = [String]::IsNullOrEmpty( $sb )
    'IsNullOrEmpty $sb2 '      = [String]::IsNullOrEmpty( $sb2 )
    'IsNullOrWhiteSpace $sb '  = [String]::IsNullOrWhiteSpace( $sb )
    'IsNullOrWhiteSpace $sb2 ' = [String]::IsNullOrWhiteSpace( $sb2 )
}|ft -auto


| Name | Value |
| - | - |
| `IsNullOrEmpty {}`         | True |
| `IsNullOrEmpty { }`        | False |
| `IsNullOrWhiteSpace {}`    | True |
| `IsNullOrWhiteSpace { }`   | True |
| `IsNullOrEmpty $sb`        | True |
| `IsNullOrEmpty $sb2`       | False |
| `IsNullOrWhiteSpace $sb`   | True |
| `IsNullOrWhiteSpace $sb2`  | True |