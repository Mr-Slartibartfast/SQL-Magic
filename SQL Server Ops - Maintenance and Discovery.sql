-- index evaluation

SELECT * FROM sys.dm_db_missing_index_details
where statement like '%table_name%'
order by statement

SELECT * FROM sys.dm_db_missing_index_group_stats
order by avg_user_impact desc

SELECT * FROM sys.dm_db_missing_index_groups
where index_group_handle=1170

SELECT mig.*, statement AS table_name, column_id, column_name, column_usage
FROM sys.dm_db_missing_index_details AS mid
CROSS APPLY sys.dm_db_missing_index_columns (mid.index_handle)
INNER JOIN sys.dm_db_missing_index_groups AS mig ON mig.index_handle = mid.index_handle
--where index_group_handle=1170
where statement like '%table_name%'
ORDER BY mig.index_group_handle, mig.index_handle, column_id; 

-----------------------------------------------------------------------------------------------

-- find all running queries

SELECT text, GETDATE(), *
FROM sys.dm_exec_requests
CROSS APPLY sys.dm_exec_sql_text(sql_handle)

-----------------------------------------------------------------------------------------------
-- find tables on a server by name

SET NOCOUNT ON
DECLARE @AllTables table (DbName sysname,SchemaName sysname, TableName sysname)
DECLARE
     @SearchDb nvarchar(200)
    ,@SearchSchema nvarchar(200)
    ,@SearchTable nvarchar(200)
    ,@SQL nvarchar(4000)
SET @SearchDb='%'
SET @SearchSchema='%'
SET @SearchTable='%table_name%'
SET @SQL='select ''?'' as DbName, s.name as SchemaName, t.name as TableName from [?].sys.tables t inner join sys.schemas s on t.schema_id=s.schema_id WHERE ''?'' LIKE '''+@SearchDb+''' AND s.name LIKE '''+@SearchSchema+''' AND t.name LIKE '''+@SearchTable+''''

INSERT INTO @AllTables (DbName, SchemaName, TableName)
    EXEC sp_msforeachdb @SQL
SET NOCOUNT OFF
SELECT * FROM @AllTables 
--where TableName like '%table%'
ORDER BY DbName, SchemaName, TableName

-----------------------------------------------------------------------------------------------
-- database sizes

 SELECT d.NAME
    ,ROUND(SUM(CAST(mf.size AS bigint)) * 8 / 1024, 0) Size_MBs
    ,(SUM(CAST(mf.size AS bigint)) * 8 / 1024) / 1024 AS Size_GBs
FROM sys.master_files mf
INNER JOIN sys.databases d ON d.database_id = mf.database_id
WHERE d.database_id > 4 -- Skip system databases
GROUP BY d.NAME
ORDER BY Size_MBs desc,d.NAME

-----------------------------------------------------------------------------------------------
-- function to search database by keyword

use WorldEconomicData -- database
go

/**
TR - trigger
FN - scalar function
IF - table valued function
V - view
P - procedure
**/

DECLARE @ObjectType VARCHAR(25)= 'IF'; -- TR, FN, IF, V, P
DECLARE @Code VARCHAR(25)= 'PIVOT';
SELECT 
     s.name + '.' + o.name, m.definition
FROM
   sys.sql_modules AS m
   INNER JOIN sys.objects AS o ON m.object_id = o.object_id
   INNER JOIN sys.schemas AS s ON o.schema_id = s.schema_id
WHERE o.type = @ObjectType
      AND o.name NOT LIKE 'sp_%'
      AND m.definition LIKE '%' + @Code + '%'
ORDER BY
     s.name
   , o.name;

-----------------------------------------------------------------------------------------------
-- list all tables by schema

select schema_name(t.schema_id) as schema_name,
       t.name as table_name,
       t.create_date,
       t.modify_date
from sys.tables t
--where schema_name(t.schema_id) = 'Production' -- put schema name here
order by schema_name,table_name;