/**
Count NULL Values from multiple columns with SQL
https://stackoverflow.com/questions/16528682/count-null-values-from-multiple-columns-with-sql
**/

SET NOCOUNT ON
DECLARE @Schema NVARCHAR(100) = 'dbo'
DECLARE @Table NVARCHAR(100) = 'world_economic_data'
DECLARE @sql NVARCHAR(MAX) =''
IF OBJECT_ID ('tempdb..#Nulls') IS NOT NULL DROP TABLE #Nulls

CREATE TABLE #Nulls (TableName sysname, ColumnName sysname , ColumnPosition int ,NullCount int , NonNullCount int)

 SELECT @sql += 'SELECT  '''+TABLE_NAME+''' AS TableName , '''+COLUMN_NAME+''' AS ColumnName,  '''+CONVERT(VARCHAR(5),ORDINAL_POSITION)+''' AS ColumnPosition, SUM(CASE WHEN '+COLUMN_NAME+' IS NULL THEN 1 ELSE 0 END) CountNulls , COUNT(' +COLUMN_NAME+') CountnonNulls FROM '+QUOTENAME(TABLE_SCHEMA)+'.'+QUOTENAME(TABLE_NAME)+';'+ CHAR(10)
 FROM INFORMATION_SCHEMA.COLUMNS
 WHERE TABLE_SCHEMA = @Schema
 AND TABLE_NAME = @Table
 and COLUMN_NAME not in  ('year','country','gdp')



 INSERT INTO #Nulls 
 EXEC sp_executesql @sql

 SELECT * 
 FROM #Nulls

 DROP TABLE #Nulls