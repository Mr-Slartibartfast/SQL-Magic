WITH DiffKeys AS (

    -- Use the Pass 1 query above but only keep UPDATE keys

    SELECT COALESCE(Cur.[year], Arc.[year]) AS key_col
    FROM (
        SELECT [year],
               HASHBYTES('SHA2_256', CONCAT_WS('|',
                   CONVERT(nvarchar(4000), [iso_code]),
                   CONVERT(nvarchar(4000), [population]),
                   CONVERT(nvarchar(4000), [gdp_per_capita])
               )) AS row_hash
        FROM [WorldEconomicData].[dbo].[CA_economic_data]
    ) Cur
    JOIN (
        SELECT [year],
               HASHBYTES('SHA2_256', CONCAT_WS('|',
                   CONVERT(nvarchar(4000), [iso_code]),
                   CONVERT(nvarchar(4000), [population]),
                   CONVERT(nvarchar(4000), [gdp_per_capita])
               )) AS row_hash
        FROM [WorldEconomicData].[dbo].[CA_economic_data_changes]
    ) Arc
      ON Arc.[year] = Cur.[year]
    WHERE Cur.row_hash <> Arc.row_hash
)
SELECT
    k.key_col,
    v.column_name,
    v.current_value,
    v.archive_value
FROM DiffKeys k
JOIN [WorldEconomicData].[dbo].[CA_economic_data] c ON c.[year] = k.key_col
JOIN [WorldEconomicData].[dbo].[CA_economic_data_changes] a ON a.[year] = k.key_col
CROSS APPLY (VALUES
    ('[iso_code]', CONVERT(nvarchar(4000), c.[iso_code]), CONVERT(nvarchar(4000), a.[iso_code])),
    ('[population]', CONVERT(nvarchar(4000), c.[population]), CONVERT(nvarchar(4000), a.[population])),
    ('[gdp_per_capita]', CONVERT(nvarchar(4000), c.[gdp_per_capita]), CONVERT(nvarchar(4000), a.[gdp_per_capita]))
) v(column_name, current_value, archive_value)
WHERE
    ISNULL(v.current_value, '<NULL>') <> ISNULL(v.archive_value, '<NULL>');