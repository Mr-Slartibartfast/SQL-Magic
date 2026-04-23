CREATE PROCEDURE usp_CheckDataQuality
AS
BEGIN
    SET NOCOUNT ON;

    -- Null check
    SELECT COUNT(*) AS NullCustomerIDs
    FROM dbo.Customers
    WHERE CustomerID IS NULL;

    -- Duplicate check
    SELECT CustomerID, COUNT(*) AS CountDupes
    FROM dbo.Customers
    GROUP BY CustomerID
    HAVING COUNT(*) > 1;

    -- Invalid email check
    SELECT *
    FROM dbo.Customers
    WHERE Email NOT LIKE '%@%.%';
END;