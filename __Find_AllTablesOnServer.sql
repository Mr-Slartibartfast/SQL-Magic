declare @sql nvarchar(max);

select @sql = 
    (select ' UNION ALL
        SELECT ' +  + quotename(name,'''') + ' as database_name,
               s.name COLLATE DATABASE_DEFAULT
                    AS schema_name,
               t.name COLLATE DATABASE_DEFAULT as table_name 
               FROM '+ quotename(name) + '.sys.tables t
               JOIN '+ quotename(name) + '.sys.schemas s
                    on s.schema_id = t.schema_id'
    from sys.databases 
    where state=0
    order by [name] for xml path(''), type).value('.', 'nvarchar(max)');

set @sql = stuff(@sql, 1, 12, '') 
+ ' order by database_name, 
                                               schema_name,
                                               table_name';

execute (@sql);