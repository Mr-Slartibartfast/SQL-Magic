DECLARE @sql nvarchar(max) = N'';

 

SELECT @sql += '

UPDATE Database.dbo.TableName

SET ' + QUOTENAME(c.name) + ' = NULL

WHERE ' + QUOTENAME(c.name) + ' = ''null'';'

FROM sys.columns c

JOIN sys.types t

    ON c.user_type_id = t.user_type_id

WHERE c.object_id = OBJECT_ID('Database.dbo.TableName')

  AND t.name IN ('varchar', 'nvarchar', 'char', 'nchar');

 

EXEC sp_executesql @sql;DECLARE @sql nvarchar(max) = N'';

 

SELECT @sql += '

UPDATE Database.dbo.TableName

SET ' + QUOTENAME(c.name) + ' = NULL

WHERE ' + QUOTENAME(c.name) + ' = ''null'';'

FROM sys.columns c

JOIN sys.types t

    ON c.user_type_id = t.user_type_id

WHERE c.object_id = OBJECT_ID('Database.dbo.TableName')

  AND t.name IN ('varchar', 'nvarchar', 'char', 'nchar');

 

EXEC sp_executesql @sql;