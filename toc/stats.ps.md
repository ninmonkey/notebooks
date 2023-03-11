# Stats for ```.<{ Get-date | % tostring u }>.```

## ... 

~~~PipeScript{
   
}
~~~

## Files by type

~~~PipeScript{

$q = fd --base-directory (gi ..) -tf --absolute-path | gi 
$q | group extension -NoElement | sort count -Descending

}
~~~



## -- ## 

~~~PipeScript{

    function md.Path.escapeSpace { process { $_ -replace ' ', '%20' } }

    Get-ChildItem . -Recurse -File
    | Where-Object extension -Match '\.(pbix|pq|xlsx|png|md|dax)'#
    | Where-Object Extension -NotMatch '\.ps\.(md|pbix|pq|dax)'  # ignore pipescript
    | Sort-Object BaseName | ForEach-Object name
    | ForEach-Object {
        '[{0}]({1})' -f @(
            $_
            $_ | md.Path.escapeSpace
        )
    } | Join.UL
}
~~~
