-- Windowed Aggregations 

SELECT 
    [country],
    [year],
    [gdp_per_capita],
    AVG(CAST([gdp_per_capita] AS FLOAT)) OVER (
        PARTITION BY [country] 
        ORDER BY [year] 
        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
    ) AS MovingAvg
FROM [WorldEconomicData].[dbo].[world_economic_data];
-----------------------------------------------------------------------
-- Lag / Lead


SELECT 
    [country],
    [year],
    [gdp_per_capita],
    LAG([gdp_per_capita]) OVER (PARTITION BY [country] ORDER BY [year]) AS PrevMark,
    [gdp_per_capita] - LAG([gdp_per_capita]) OVER (PARTITION BY [country] ORDER BY [year]) AS Improvement
FROM [WorldEconomicData].[dbo].[world_economic_data];