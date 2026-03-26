

/**
	Data Engineer SQL Toolkit
**/

-- Create a log table

CREATE TABLE ETL_Log (
    LogID INT IDENTITY(1,1) PRIMARY KEY,
    ProcessName VARCHAR(100),
    StepName VARCHAR(100),
    Status VARCHAR(20), -- STARTED, SUCCESS, FAILED
    RowCount INT,
    Message VARCHAR(MAX),
    StartTime DATETIME,
    EndTime DATETIME
);


----------------------------------------------------------------------------
-- Logging Stored Procedure

CREATE PROCEDURE usp_LogEvent
    @ProcessName VARCHAR(100),
    @StepName VARCHAR(100),
    @Status VARCHAR(20),
    @RowCount INT = NULL,
    @Message VARCHAR(MAX) = NULL
AS
BEGIN
    INSERT INTO ETL_Log (
        ProcessName,
        StepName,
        Status,
        RowCount,
        Message,
        StartTime,
        EndTime
    )
    VALUES (
        @ProcessName,
        @StepName,
        @Status,
        @RowCount,
        @Message,
        GETDATE(),
        CASE WHEN @Status IN ('SUCCESS', 'FAILED') THEN GETDATE() ELSE NULL END
    );
END;

----------------------------------------------------------------------------

-- Data Validation
-- NULL check
CREATE PROCEDURE usp_CheckNulls
    @TableName VARCHAR(100),
    @ColumnName VARCHAR(100)
AS
BEGIN
    DECLARE @SQL NVARCHAR(MAX);

    SET @SQL = '
    SELECT COUNT(*) AS NullCount
    FROM ' + @TableName + '
    WHERE ' + @ColumnName + ' IS NULL';

    EXEC sp_executesql @SQL;
END;

----------------------------------------------------------------------------
-- Check for duplicates

CREATE PROCEDURE usp_CheckDuplicates
    @TableName VARCHAR(100),
    @ColumnName VARCHAR(100)
AS
BEGIN
    DECLARE @SQL NVARCHAR(MAX);

    SET @SQL = '
    SELECT ' + @ColumnName + ', COUNT(*) AS DuplicateCount
    FROM ' + @TableName + '
    GROUP BY ' + @ColumnName + '
    HAVING COUNT(*) > 1';

    EXEC sp_executesql @SQL;
END;

----------------------------------------------------------------------------
-- Row Count comparison

CREATE PROCEDURE usp_CompareRowCounts
    @TableA VARCHAR(100),
    @TableB VARCHAR(100)
AS
BEGIN
    DECLARE @SQL NVARCHAR(MAX);

    SET @SQL = '
    SELECT
        (SELECT COUNT(*) FROM ' + @TableA + ') AS TableA_Count,
        (SELECT COUNT(*) FROM ' + @TableB + ') AS TableB_Count';

    EXEC sp_executesql @SQL;
END;

----------------------------------------------------------------------------
-- hash based compare

CREATE PROCEDURE usp_CompareTablesHash
    @TableA VARCHAR(100),
    @TableB VARCHAR(100),
    @ColumnList VARCHAR(MAX)
AS
BEGIN
    DECLARE @SQL NVARCHAR(MAX);

    SET @SQL = '
    SELECT HASHBYTES(''SHA2_256'', CONCAT(' + @ColumnList + ')) AS RowHash
    INTO #A
    FROM ' + @TableA + ';

    SELECT HASHBYTES(''SHA2_256'', CONCAT(' + @ColumnList + ')) AS RowHash
    INTO #B
    FROM ' + @TableB + ';

    SELECT * FROM #A
    EXCEPT
    SELECT * FROM #B;
    ';

    EXEC sp_executesql @SQL;
END;

----------------------------------------------------------------------------
-- data profiling

CREATE PROCEDURE usp_ProfileColumn
    @TableName VARCHAR(100),
    @ColumnName VARCHAR(100)
AS
BEGIN
    DECLARE @SQL NVARCHAR(MAX);

    SET @SQL = '
    SELECT 
        COUNT(*) AS TotalRows,
        COUNT(' + @ColumnName + ') AS NonNullCount,
        COUNT(*) - COUNT(' + @ColumnName + ') AS NullCount,
        MIN(' + @ColumnName + ') AS MinValue,
        MAX(' + @ColumnName + ') AS MaxValue
    FROM ' + @TableName;

    EXEC sp_executesql @SQL;
END;

----------------------------------------------------------------------------
-- full table profiling

SELECT 
    COLUMN_NAME,
    DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'YourTable';

----------------------------------------------------------------------------
-- date utility

CREATE FUNCTION fn_StartOfMonth (@InputDate DATE)
RETURNS DATE
AS
BEGIN
    RETURN DATEFROMPARTS(YEAR(@InputDate), MONTH(@InputDate), 1);
END;

--------------

CREATE FUNCTION fn_EndOfMonth (@InputDate DATE)
RETURNS DATE
AS
BEGIN
    RETURN EOMONTH(@InputDate);
END;

------------

-- Calendar table

CREATE TABLE DimDate (
    DateValue DATE PRIMARY KEY,
    Year INT,
    Month INT,
    Day INT,
    MonthName VARCHAR(20),
    DayOfWeek VARCHAR(20)
);
------------

-- populate it

WITH Dates AS (
    SELECT CAST('2020-01-01' AS DATE) AS dt
    UNION ALL
    SELECT DATEADD(DAY, 1, dt)
    FROM Dates
    WHERE dt < '2030-12-31'
)
INSERT INTO DimDate
SELECT 
    dt,
    YEAR(dt),
    MONTH(dt),
    DAY(dt),
    DATENAME(MONTH, dt),
    DATENAME(WEEKDAY, dt)
FROM Dates
OPTION (MAXRECURSION 3650);

----------------------------------------------------------------------------
-- ETL LOAD PATTERN TEMPLATE


BEGIN TRY

    EXEC usp_LogEvent 'CustomerLoad', 'START', 'STARTED';

    -- Step 1: Load staging
    INSERT INTO StagingTable
    SELECT * FROM SourceTable;

    EXEC usp_LogEvent 'CustomerLoad', 'STAGING_LOAD', 'SUCCESS', @@ROWCOUNT;

    -- Step 2: Validate
    EXEC usp_CheckNulls 'StagingTable', 'CustomerID';

    -- Step 3: Merge into target
    MERGE TargetTable AS t
    USING StagingTable AS s
    ON t.ID = s.ID
    WHEN MATCHED THEN
        UPDATE SET t.Name = s.Name
    WHEN NOT MATCHED THEN
        INSERT (ID, Name)
        VALUES (s.ID, s.Name);

    EXEC usp_LogEvent 'CustomerLoad', 'MERGE', 'SUCCESS', @@ROWCOUNT;

END TRY
BEGIN CATCH

    EXEC usp_LogEvent 
        'CustomerLoad',
        'ERROR',
        'FAILED',
        NULL,
        ERROR_MESSAGE();

END CATCH;
-----------------------------------

-- Data quality rules table

CREATE TABLE DataQualityRules (
    RuleID INT IDENTITY(1,1),
    TableName VARCHAR(100),
    ColumnName VARCHAR(100),
    RuleType VARCHAR(50), -- NOT_NULL, POSITIVE, etc.
    IsActive BIT
);