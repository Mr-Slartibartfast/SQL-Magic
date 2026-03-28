-- Percentiles

USE [WorldEconomicData]
GO

SELECT 
    [country],
    [year],
    [gdp_per_capita],
    PERCENT_RANK() OVER (PARTITION BY [country] ORDER BY [gdp_per_capita] ASC) AS Percentile
FROM [dbo].[world_economic_data];

-------------------------------------------------------
-- Aggregate Stats 
USE [WorldEconomicData]
GO

SELECT 
    [year],
    country,
    MIN([gdp_per_capita]) AS Highest_GDP,
    MAX([gdp_per_capita]) AS Lowest_GDP,
    AVG(CAST([gdp_per_capita] AS FLOAT)) AS Avg_GDP
FROM [dbo].[world_economic_data]
GROUP BY [country],[year],country;

-------------------------------------------------------
-- Z Score

WITH Stats AS (
    SELECT 
        [year],
        [country],
        AVG(CAST([gdp_per_capita] AS FLOAT)) AS Mean,
        STDEV(CAST([gdp_per_capita] AS FLOAT)) AS StdDev
    FROM [WorldEconomicData].[dbo].[world_economic_data]
    GROUP BY [country],[year]
)
SELECT 
    r.[country],
    r.[year],
    r.[gdp_per_capita],
    (CAST(r.[gdp_per_capita] AS FLOAT) - s.Mean) / s.StdDev AS ZScore
FROM [WorldEconomicData].[dbo].[world_economic_data] r
JOIN Stats s ON r.[year] = s.[year];