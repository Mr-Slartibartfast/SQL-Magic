CREATE PROCEDURE usp_LoadIncrementalData
AS
BEGIN
    SET NOCOUNT ON;

    MERGE INTO dbo.FactSales AS target
    USING (
        SELECT *
        FROM dbo.StagingSales
        WHERE LastModifiedDate > (
            SELECT ISNULL(MAX(LastModifiedDate), '1900-01-01')
            FROM dbo.FactSales
        )
    ) AS source
    ON target.SalesID = source.SalesID

    WHEN MATCHED THEN
        UPDATE SET 
            target.Amount = source.Amount,
            target.LastModifiedDate = source.LastModifiedDate

    WHEN NOT MATCHED THEN
        INSERT (SalesID, Amount, LastModifiedDate)
        VALUES (source.SalesID, source.Amount, source.LastModifiedDate);
END;