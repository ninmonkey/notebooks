# All images

## -- ## 


~~~PipeScript{
    $stuff = ps.Gci.FilesOfType -Extensions png, gif, jpeg, jpg, svg -BaseDirectory .. -OptionalConfig AbsolutePath
    $stuff | sort lastwritetime -Descending:$true
    | %{ '<file:///{0}>' -f @( $_ ) }
    | join.ul
}

## -- ## 


$q = fd --base-directory (gi ..) -tf --absolute-path | gi 
$q | group extension -NoElement | sort count -Descending

