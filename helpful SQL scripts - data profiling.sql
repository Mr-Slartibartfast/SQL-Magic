
-- data profiling

SELECT 
    COUNT(*) AS TotalRows,
    COUNT([population]) AS NonNullCount,
    COUNT(*) - COUNT([year]) AS NullCount,
    MIN([gdp]) AS MinValue,
    MAX([gdp]) AS MaxValue
FROM [WorldEconomicData].[dbo].[world_economic_data];

-- date ranges
WITH Dates AS (
    SELECT CAST('2025-01-01' AS DATE) AS dt
    UNION ALL
    SELECT DATEADD(DAY, 1, dt)
    FROM Dates
    WHERE dt < '2025-12-31'
)
SELECT * FROM Dates
OPTION (MAXRECURSION 365);



-- row number over partition by : top 3 per partition

SELECT *
FROM (
    SELECT *,
           ROW_NUMBER() OVER (PARTITION BY [country] ORDER BY [year] DESC) AS rn
    FROM [WorldEconomicData].[dbo].[world_economic_data]
) t
WHERE rn <= 3;




-- delete duplicates 

WITH cte AS (
    SELECT *,
           ROW_NUMBER() OVER (PARTITION BY ColumnName ORDER BY (SELECT NULL)) AS rn
    FROM [WorldEconomicData].[dbo].[world_economic_data]
)
DELETE FROM cte WHERE rn > 1; -- Always use SELECT FIRST to ensure you delete what you expect to delete



-- identify gaps

SELECT t1.[year] + 1 AS MissingID
FROM [WorldEconomicData].[dbo].[world_economic_data] t1
LEFT JOIN [WorldEconomicData].[dbo].[UK_CA_economic_data] t2
    ON t1.[year] + 1 = t2.[year]
WHERE t2.[year] IS NULL;


-- MERGE


MERGE [WorldEconomicData].[dbo].[UK_economic_data] AS t
USING [WorldEconomicData].[dbo].[world_economic_data] AS s
ON t.[iso_code] = s.[iso_code]

WHEN MATCHED THEN
    UPDATE SET t.[gdp] = s.[gdp]

WHEN NOT MATCHED THEN
    INSERT ([iso_code], [gdp])
    VALUES (s.[iso_code], s.[gdp]);



-- find long running queries

SELECT 
    start_time,
    total_elapsed_time / 1000 AS DurationMs,
    text
FROM sys.dm_exec_requests r
CROSS APPLY sys.dm_exec_sql_text(r.sql_handle)
ORDER BY DurationMs DESC;


-- index usage

SELECT 
    OBJECT_NAME(i.object_id) AS TableName,
    i.name AS IndexName,
    s.user_seeks,
    s.user_scans
FROM sys.indexes i
LEFT JOIN sys.dm_db_index_usage_stats s
    ON i.object_id = s.object_id
    AND i.index_id = s.index_id
WHERE OBJECTPROPERTY(i.object_id, 'IsUserTable') = 1;