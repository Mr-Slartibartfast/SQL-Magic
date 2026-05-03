MERGE INTO dbo.TargetTable AS target
USING dbo.StagingTable AS source
ON target.ID = source.ID

WHEN MATCHED THEN
    UPDATE SET 
        target.Name = source.Name,
        target.UpdatedAt = GETDATE()

WHEN NOT MATCHED THEN
    INSERT (ID, Name, CreatedAt)
    VALUES (source.ID, source.Name, GETDATE());