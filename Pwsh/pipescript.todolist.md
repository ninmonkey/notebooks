# Toc

## was <file:///H:\env\code\tmp\keep\pipescript-wishlist-or-checklist.to-ask.md>

## [ ] is blankable 

```ps1
$null -eq $obj
[String]::IsNullOrWhitespadce( $obj ) 
```


## [ ] array slice python notation sort of

```python
x[start:end:increment]
implicit values are 
    start = 0
    end = self.length
    increment exists? anything?

x[::]  # creates a copy of the list/array

x[]
```

## [ ] dates, times etc

```ps1
date now - 2hours
    # (get-date).addHours(-2)

do something within 30minutes
    # once, rough time
do something every  30minutes
    # repeated

all files where modified within 4 hours

date days until halloween   
    # (date 'haloween') - now |  % TotalDays
```


## [ ] set operators

all numbers shouldExist inSet anyReals
all 0..4 shouldExist inSet anyInteger
## [ ] all must not be falsy 

~~all $tests where [bool]$_~~
```
not any tests are false
    all tests are not false 
    any tests are true
    


all tests are true
all $tests where [bool]$_
```

all $nums where areOdd
all $nums where areOdd are 2
all $nums where .. listLength is none
None $nums where areAdd Count4

```ps1
$conditions = @(
    $someVaslue -eq 32
    SomeFunc
    $z -in 'a', 'b', 'z'
)

if( ($conditions -eq $false).Count ) {

}
if($c)
$null -eq $obj
[String]::IsNullOrWhitespadce( $obj ) 



```
## [ ] set and math text

- <https://en.wikipedia.org/wiki/Set_(mathematics)#Basic_operations>
```md
union A ∪ B 
intersection A ∩ B
    If A ∩ B = ∅, then A and B are said to be disjoint.

set difference A \ B (also written A − B)
symmetric difference A Δ B is

symmetric difference A Δ B is the set of all things that belong to A or B but not both. One has

    A Δ B == (A \ B) u (B \ A)

cartesian product A × B is the set of all ordered pairs (a,b) such that a is an element of A and b is an element of B.

### Numbers

    {\displaystyle \mathbf {N} } or N \mathbb N, the set of all natural numbers: N = { 0 , 1 , 2 , 3 , . . . } {\displaystyle \mathbf {N} =\{0,1,2,3,...\}} (often, 

    {\displaystyle \mathbf {Z} } or Z \mathbb {Z} , the set of all integers (whether positive, negative or zero): Z = { . . . , − 2 , − 1 , 0 , 1 , 2 , 3 , . . . } {\displaystyle \mathbf {Z} =\{...,-2,-1,0,1,2,3,...\}}
```