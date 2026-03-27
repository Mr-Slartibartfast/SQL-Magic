
-- find where the value of a column is empty but not null
SELECT *
FROM [WorldEconomicData].[dbo].[world_economic_data]
WHERE LEN(LTRIM(RTRIM([gini_index]))) <= 0 




-- Use COALESCE instead of ISNULL where ISNULL cannot be used - OR if you need more than 2 arguments
-- COALESCE can use multiple arguments/options 

SELECT [country],
[year],
COALESCE([gdp],0.0) as gdp
FROM [WorldEconomicData].[dbo].[world_economic_data]
WHERE [income_top10] > 10



----ISNULL is slightly faster (SQL Server-specific)
----COALESCE is more portable and flexible

SELECT [country],
[year],
[population],
ISNULL([poverty_rate],0)
FROM [WorldEconomicData].[dbo].[world_economic_data]