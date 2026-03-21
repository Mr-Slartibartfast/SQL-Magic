
-- Insert all rows from the first table, using HASHBYTES and CONCAT to create a hash of each row
 DROP  TABLE #TableA_Hash 
SELECT 
    SysRecId,
    HASHBYTES(
        'SHA2_256',
        CONCAT(
            ISNULL([country], ''),
            '|',
            ISNULL([year], ''),
            '|',
            ISNULL([iso_code], ''),
            '|',
            ISNULL([population], ''),
            '|',
            ISNULL([gdp], ''),
            '|',
            ISNULL([gdp_per_capita], ''),
            '|',
            ISNULL([poverty_rate], ''),
            '|',
            ISNULL([gini_index], ''),
            '|',
            ISNULL([income_top1], ''),
            '|',
            ISNULL([income_top10], ''),
            '|',
            ISNULL([income_bottom50], ''),
            '|'
        )
    ) AS row_hash
INTO #TableA_Hash
FROM [WorldEconomicData].[dbo].[CA_economic_data]

SELECT * FROM #TableA_Hash


-- Put the rows of the second table into the second temp table using the same method
 DROP  TABLE #TableB_Hash 
SELECT 
    SysRecId,
    HASHBYTES(
        'SHA2_256',
        CONCAT(
            ISNULL([country], ''),
            '|',
            ISNULL([year], ''),
            '|',
            ISNULL([iso_code], ''),
            '|',
            ISNULL([population], ''),
            '|',
            ISNULL([gdp], ''),
            '|',
            ISNULL([gdp_per_capita], ''),
            '|',
            ISNULL([poverty_rate], ''),
            '|',
            ISNULL([gini_index], ''),
            '|',
            ISNULL([income_top1], ''),
            '|',
            ISNULL([income_top10], ''),
            '|',
            ISNULL([income_bottom50], ''),
            '|'
        )
    ) AS row_hash
INTO #TableB_Hash
FROM [WorldEconomicData].[dbo].[UK_economic_data]


-- First compare: If the IDs are the same, you can use the following:
SELECT 
    a.SysRecId,
    'UPDATED' AS change_type
FROM #TableA_Hash a
JOIN #TableB_Hash b
    ON a.SysRecId = b.SysRecId
WHERE a.row_hash <> b.row_hash;

-- This will compare the row hashes against one another
-- You can test this by comparing the same temp table to itself


/**

If the tables have different IDs, you can USE EXCEPT below. This does not use temp tables

The tables must have the same columns to compare using the below. 

This is a good option for comparing an update or staging table against the target to see what data is new in the update table

EXCEPT will select everything in the table above the EXCEPT that does not appear in the table below. 

You can reverse the order to compare in the other direction

**/

SELECT 
    SysRecId,
    HASHBYTES(
        'SHA2_256',
        CONCAT(
            ISNULL([country], ''),
            '|',
            ISNULL([year], ''),
            '|',
            ISNULL([iso_code], ''),
            '|',
            ISNULL([population], ''),
            '|',
            ISNULL([gdp], ''),
            '|',
            ISNULL([gdp_per_capita], ''),
            '|',
            ISNULL([poverty_rate], ''),
            '|',
            ISNULL([gini_index], ''),
            '|',
            ISNULL([income_top1], ''),
            '|',
            ISNULL([income_top10], ''),
            '|',
            ISNULL([income_bottom50], ''),
            '|'
        )
    ) AS row_hash
FROM [WorldEconomicData].[dbo].[CA_economic_data]
--FROM [WorldEconomicData].[dbo].[UK_economic_data]

EXCEPT 

SELECT 
    SysRecId,
    HASHBYTES(
        'SHA2_256',
        CONCAT(
            ISNULL([country], ''),
            '|',
            ISNULL([year], ''),
            '|',
            ISNULL([iso_code], ''),
            '|',
            ISNULL([population], ''),
            '|',
            ISNULL([gdp], ''),
            '|',
            ISNULL([gdp_per_capita], ''),
            '|',
            ISNULL([poverty_rate], ''),
            '|',
            ISNULL([gini_index], ''),
            '|',
            ISNULL([income_top1], ''),
            '|',
            ISNULL([income_top10], ''),
            '|',
            ISNULL([income_bottom50], ''),
            '|'
        )
    ) AS row_hash
FROM [WorldEconomicData].[dbo].[CA_economic_data]