h1 'types'

[Data.DataColumn], [Data.DataTable] | join.UL

$dtab = [Data.DataTable]::new("Employees")

$Cols = @(
    [Data.DataColumn]::new('Name', ([string]))
    [Data.DataColumn]::new('Id', ([int]))
)
$dtab.Columns.AddRange( $Cols )
$row = $dtab.NewRow()
$row['Name'] = 'Bob'
$row['Id'] = 2134
$dtab.Rows.Add( $row )


class Employee {
    [ValidateNotNullOrEmpty()]
    [string]$Name

    [ValidateRange(0,40)]
    [int]$Id
}

[Employee]@{ Name = 'bob'; Id = 20 }
[Employee]@{ Name = 'Jen'; Id = 33 }

$employees = @(
    [Employee]@{ Name = 'bob'; Id = 20 }
    [Employee]@{ Name = 'Jen'; Id = 99 }

    [Employee]@{ Name = 'Jen'; Id = 33 }
)


# function _addRow {
    # param( [Data.DataTable]$TableObj  )
# }

$dtab