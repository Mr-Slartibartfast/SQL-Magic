SELECT 'null_name' AS check_name, COUNT(*) AS failed_records
FROM silver_cleaned
WHERE name IS NULL

UNION ALL

SELECT 'invalid_age', COUNT(*)
FROM silver_cleaned
WHERE age < 0 OR age > 120

UNION ALL

SELECT 'duplicate_ids', COUNT(*)
FROM (
    SELECT id
    FROM silver_cleaned
    GROUP BY id
    HAVING COUNT(*) > 1
) t;