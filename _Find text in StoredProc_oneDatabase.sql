--USE [DHG_DL_Storage]
--go

--select NEWID()
DECLARE @SearchText nvarchar(300)
SET @SearchText='tab'

---- find text in stored proc
--SELECT DISTINCT  
--       o.name AS Object_Name,
--       o.type_desc
--FROM sys.sql_modules m with (nolock)
--       INNER JOIN
--       sys.objects o
--         ON m.object_id = o.object_id
--WHERE m.definition Like '%'+@SearchText+'%';


-- find text in stored proc
SELECT DISTINCT 
		o.name AS Object_Name,
       o.type_desc
	   --,o.*
FROM sys.sql_modules m with (nolock)
       INNER JOIN
       sys.objects o
         ON m.object_id = o.object_id
WHERE m.definition Like '%'+@SearchText+'%'
order by Object_Name


-- find table
SELECT 'Table',* FROM INFORMATION_SCHEMA.TABLES   with (nolock)
WHERE TABLE_NAME LIKE '%'+@SearchText+'%'
order by TABLE_SCHEMA,TABLE_NAME
