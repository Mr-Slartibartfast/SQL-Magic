
/** 

I added duplicate rows to the table for duplicate removal / identification purposes 
Below is ROW_NUMBER() over Partition By - an incredibly useful SQL operation for finding and removing duplicates from a table



Step One: find duplicates! This data is all of the same country - so I am partitioning by the year. 

The column you partition by determines what rows are compared against. For example, there are two rows for the year 1980, so partitioning the year column 
compares each row with a matching value in the year columnm. 

ORDER typically by a datetime / watermark / timestamp etc. - in this case we are ordering by population. If you want to find the most recent of the 
duplicate rows, order by datetime.

**/

-- Row_Number over Partition By syntax:

SELECT  [SysRecId]
      ,[country]
      ,[year]
      ,[iso_code]
      ,[population]
      ,[gdp]
      ,[gdp_per_capita]
      ,[poverty_rate]
      ,[gini_index]
      ,[income_top1]
      ,[income_top10]
      ,[income_bottom50]
      ,ROW_NUMBER() OVER (PARTITION BY year ORDER BY population DESC) AS rn
  FROM [WorldEconomicData].[dbo].[UK_economic_data]


-- Isolate duplicates by row number (rn) with subquery 

SELECT * FROM (

SELECT  [SysRecId]
      ,[country]
      ,[year]
      ,[iso_code]
      ,[population]
      ,[gdp]
      ,[gdp_per_capita]
      ,[poverty_rate]
      ,[gini_index]
      ,[income_top1]
      ,[income_top10]
      ,[income_bottom50]
      ,ROW_NUMBER() OVER (PARTITION BY year ORDER BY population DESC) AS rn
  FROM [WorldEconomicData].[dbo].[UK_economic_data]
) x
WHERE rn=1

-- Remove Duplicates

DELETE FROM [WorldEconomicData].[dbo].[UK_economic_data]
WHERE SysRecId IN (
    SELECT SysRecId FROM (
        SELECT  [SysRecId]
      ,[country]
      ,[year]
      ,[iso_code]
      ,[population]
      ,[gdp]
      ,[gdp_per_capita]
      ,[poverty_rate]
      ,[gini_index]
      ,[income_top1]
      ,[income_top10]
      ,[income_bottom50]
      ,ROW_NUMBER() OVER (PARTITION BY year ORDER BY population DESC) AS rn
  FROM [WorldEconomicData].[dbo].[UK_economic_data]
  ) x
  WHERE rn > 1
  )

-- Check for duplicates again after the DELETE - they all will have been removed! (42 in this case)
