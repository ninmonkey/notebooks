h1 'Pansies Compares'
Find-type -Namespace PoshCode.Pansies.* -Name *compar*
    | sort namespace, name
    | ft -AutoSize -GroupBy Namespace

h1 'Pansies Convert'
Find-type -Namespace PoshCode.Pansies.* -Name *conver*
    | sort namespace, name
    | ft -AutoSize -GroupBy Namespace

h1 'Pansies Enum'
[PoshCode.Pansies.Harmony]
    | Find-Member | select -skip 1 | Join-String Name ' '

h1 'others'
Find-type -Namespace PoshCode.Pansies | ft -AutoSize
