/*

Use this script to search all objects, in all databases on the server, that
are SQL language-defined modules in SQL Server.  These include the following:

 

DDEFAULT (constraint or stand-alone)
PSQL Stored Procedure
RFReplication-filter-procedure
VView
TRSQL DML Trigger
FNSQL scalar function
IFSQL inline table-valued function
TFSQL table-valued function (2012 - 2016)
RRule (old-style, stand-alone)

*/

 

DECLARE @cmd varchar(1000),
@search_string varchar(200)

 
 -- set up temp table to store results in 
IF OBJECT_ID('tempdb.dbo.#temp', 'U') IS NOT NULL
                        DROP TABLE #temp
CREATE TABLE #temp(
[Database_Name]sysname,
[Schema_Name]sysname,
[Object_Name]sysname,
[Object_Type]nvarchar(60))

 
 -- tHIS IS THE ONLY INPUT NEEDED - THE SCRIPT WILL SEARCH ALL CONNECTED DATABASES FOR THE SEARCH STRING BELOW
-- Set the search string
SET @search_string = 'paygroup' -- THIS IS WHERE YOU PUT IN WHAT YOU ARE SEARCHING FOR
SET @cmd = 'INSERT INTO #temp SELECT DISTINCT ''?'', s.name AS Schema_Name, o.name AS Object_Name, o.type_desc FROM [?].sys.sql_modules m INNER JOIN [?].sys.objects o ON m.object_id = o.object_id INNER JOIN [?].sys.schemas s ON o.schema_id = s.schema_id WHERE m.definition Like ''%' + @search_string + '%'''

 

-- Uncomment the following if you have problems with your command and want to see the command
--PRINT @cmd

 

-- Run for every database on the server
EXEC sp_msforeachdb @cmd


-- *** Retrieve your results from the temp table
--SELECT *
--FROM #temp
----where [Object_Type] != 'view'
--ORDER BY [Database_Name], [Object_Name], [Object_Type]

-- If you want to omit certain databases from your results, simply add
-- the appropriate WHERE clause, as in the following:

----SELECT *
----FROM #temp
----WHERE db NOT IN ('DB1', 'DB4', 'DB7')
----ORDER BY db, obj_type, obj_name

 

SELECT *
FROM #temp

--WHERE [Database_Name]  IN ('ENT_RD_WeCheck_DataSpring')
ORDER BY [Database_Name], [Object_Type], [Object_Name]

 

--DROP TABLE #temp

GO