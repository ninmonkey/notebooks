using namespace System.Collections.Generic

class Node {
    [string]$Title = 'node'
    [List[Object]]$Children = @()
}

$tree = @(
    [Node]@{
        Title = 'Root'
        Children = @(
            [Node]@{
                Title = 'style'
                Children = @(
                    [Node]@{
                        Title = 'SomeFont'
                    }
                )
            }
            [Node]@{
                Title = 'body'
                Children = @(
                    [Node]@{
                        Title = 'flex-item'
                    }
                )
            }
        )
    }
)

# json used
$tree | json -Depth 99 -Compress

$tree | Show-ObjectTree
