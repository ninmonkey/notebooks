- Some of this renders in Vs Code better than Github.
- github may not syntax highlighted rows, or, there are different language names for code blocks, it's not 1:1

Blcoks

- [basic table](#basic-table)
- [double column code](#double-column-code)
- [single column, code blocks inside](#single-column-code-blocks-inside)
- [todo:](#todo)
  - [Snippet Markdown single item, screenshot and images](#snippet-markdown-single-item-screenshot-and-images)


## basic table

<table>
    <tr>
        <th>col1</th>
        <th>col2</th>
    </tr>
    <tr>
        <td>col1</td>
        <td>col2</td>
    </tr>

</table>


## double column code

<table>
    <tr>
        <th>Power Query</th>
        <th>Output</th>
    </tr>
<tr>
<td>


```ts
[
    string  = "10,300",
    Us = Number.From( string, "en-us" ), 
    German = Number.From( string, "de-de" ),
    ratio = Us / German
]
```

</td><td>

```yaml
string: "10,300"
Us: 10300
German: 10.3
Ratio: 999.99999999999989
```

</td>
</tr>
</table>


## single column, code blocks inside

<table>
    <tr>
        <th>th1</th>
    </tr>
    <tr>
<td>

```yaml
string: "10,300"
Us: 10300
German: 10.3
Ratio: 999.99999999999989
```

</tr>
<tr>
<td>

```ts
[
    string  = "10,300",
    Us = Number.From( string, "en-us" ), 
    German = Number.From( string, "de-de" ),
    ratio = Us / German
]
```


</td>
        <!-- <td>col2</td> -->
</tr>
</table>  

## todo:

### Snippet Markdown single item, screenshot and images

```md
Ascribing extra **metadata** to your `functions`

- [PowerQuery.pq](./pq/joining-text%20as%20pipes%20from%20auto-coerced-column-values.pq)
- [Report.pbix](./joining-text%20as%20pipes%20from%20auto-coerced-column-values.pbix)
- Note: it works, I'm half way through writing it

![thumb-table](./img/joining-text%20as%20pipes%20from%20auto-coerced-column-values-01.png)
[view](./img/joining-text%20as%20pipes%20from%20auto-coerced-column-values-01.png)
```