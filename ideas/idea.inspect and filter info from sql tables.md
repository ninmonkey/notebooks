```sql
select
	[sc].[TABLE_NAME] 'Table', [sc].[COLUMN_NAME] 'Column',
    [sc].[DATA_TYPE] 'Datatype', *
from
	INFORMATION_SCHEMA.COLUMNS as [sc]
where
	( [sc].[TABLE_NAME] in ('table1', 'table2') )
	and 
	( lower(COLUMN_NAME) like lower('%stuff%') )			
order by
	TABLE_NAME, COLUMN_NAME, ORDINAL_POSITION, DATA_TYPE
```