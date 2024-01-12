using namespace System.Collections.Generic

class Node {
    [string]$Name = 'node'
    [List[Object]]$Children = @()
}

$tree = @(
    [Node]@{
        Name = 'Root'
        Children = @(
            [Node]@{
                Name = 'style'
                Children = [Node]@{
                    Name = 'SomeFont'
                }
            }
            [Node]@{
                Name = 'body'
                Children = @(
                    [Node]@{
                        Name = 'flex-item'
                    }
                )
            }
        )
    }
)

$tree | Show-ObjectTree
