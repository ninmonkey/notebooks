## inherit 


<table>
    <tr>
        <th>Name</th>
        <th>Desc</th>
    </tr>
    <tr>
        <td><a href='https://github.com/StartAutomating/PipeScript/tree/main/Transpilers'>Transpilers</a></td>
        <td><a href="https://github.com/StartAutomating/PipeScript/blob/main/Transpilers/Inherit.psx.ps1">Inherit.psx.ps1</a></td>
    </tr>
    <tr>
        <td><a href='https://github.com/StartAutomating/PipeScript/tree/main/Transpilers/Parameters'>T/Parameters</a></td>
        <td>desc</td>
    </tr>

</table>

- [Dot notation<s>](https://github.com/StartAutomating/PipeScript/blob/main/Transpilers/Syntax/Dot.psx.ps1)


```ps1
&   {
        [inherit("ipconfig",Overload)]
        param()
        begin { "ABOUT TO CALL GH"}
        end { "JUST CALLED GH" }
    }.Transpile()
```

## Inherit, like a proxy

```ps1
Invoke-PipeScript {
    [inherit("Get-Command")]
    param()
}
Invoke-PipeScript -Parameter @{name = '*python*'} {
    [inherit("Get-Command")]
    param()
}
```