<#
IISResetMe:
    Case-discriminating-comparer.ps1
    from: <https://gist.github.com/IISResetMe/1202a26269442a0e96bee9138191cf89>
#>

<#
IISResetMe:
    $dType = $dict.GetType()
    if ($dType -eq [hashtable] -or $dType.IsGenericType -and $dType.GetGenericTypeDefinition() -eq [System.Collections.Generic.Dictionary`2]) {
        $cmp = $dict.Comparer
    }
    else {
        # use reflection to discover non-public members of type IEqualityComparer
    }
#>

class OneAComparer : System.Collections.IEqualityComparer
{
    [scriptblock]
    $Comparer

    OneAComparer() {
        $this.Comparer = {
            param($a, $b)
            return [object]::Equals($a, $b) -or ($a -eq 'A' -and $b -eq 'A') } }

    [bool]
    Equals( $a, $b ) {
        return & $this.Comparer $a $b
    }

    [int]
    GetHashCode( $obj ) {
        if( $obj -is [object] ){
            if ( $obj.Equals('a') ) {
                return $this.GetHashCode('A') }

            return $obj.GetHashCode()
        }
        throw [System.ArgumentNullException]::new('obj') }
}

$ht = [hashtable]::new([OneAComparer]::new())

$ht['a'] = Get-Random
$ht['A'] = Get-Random
$ht['b'] = Get-Random
$ht['B'] = Get-Random

# how many entries does the hashtable contain now?
$ht.psbase.Count

<#
santisq:
    from <https://discord.com/channels/180528040881815552/447475598911340559/1177305079376793730>
#>

$ht,
[System.Collections.Generic.Dictionary[string, string]]::new(),
[ordered]@{},
@{},
[System.Collections.Concurrent.ConcurrentDictionary[string, string]]::new(),
[System.Collections.Generic.SortedDictionary[string, string]]::new() |
    ForEach-Object {
        $type = $_.GetType()
        if ($type.IsGenericType -and $type.GetGenericTypeDefinition() -in $supportedGenericTypes) {
            $comparer = $_.Comparer
            # need to cover any custom type implementing `IDicitonary<TKey, TValue>` here...
        }
        elseif (-not $type.IsGenericType ) {
            $instance = $_

            switch ($type) {
                ([hashtable]) {
                    $comparer = [hashtable].
                        GetField('_keycomparer', [System.Reflection.BindingFlags] 'NonPublic,Instance').
                        GetValue($instance)
                }
                ([ordered]) {
                    $comparer = [ordered].
                        GetField('_comparer', [System.Reflection.BindingFlags] 'NonPublic,Instance').
                        GetValue($instance)
                }
                # need to cover any custom type implementing `IDicitonary` here...
            }
        }
        else {
            write-error 'OperationNotImplemented'
            # throw [System.NotImplementedException]::new()
        }

        [pscustomobject]@{
            Type     = $type
            Comparer = $comparer
        }
    }
    | ft -auto
