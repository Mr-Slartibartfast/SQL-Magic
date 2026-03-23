-- SQL DATE MATH

-- Get the Current year and previous year from the date as ints

SELECT CAST(YEAR(DATEADD(YEAR,-1,CAST(GETDATE() as date))) as int) 

SELECT CAST(YEAR(CAST(GETDATE() as date)) as int)

-------------------------------------------------------------------------

-- Get current date 

SELECT GETDATE()        -- current date + time
SELECT SYSDATETIME()    -- more precision
SELECT CURRENT_TIMESTAMP -- ANSI standard (same as GETDATE)

-------------------------------------------------------------------------
-- Extract parts of a date

SELECT YEAR(GETDATE())
SELECT MONTH(GETDATE())
SELECT DAY(GETDATE())

SELECT DATEPART(YEAR, GETDATE())
SELECT DATEPART(MONTH, GETDATE())
SELECT DATEPART(WEEK, GETDATE())
SELECT DATEPART(QUARTER, GETDATE())

-------------------------------------------------------------------------

-- Add / Subtract TIME

SELECT DATEADD(DAY, -7, GETDATE())   -- 7 days ago
SELECT DATEADD(MONTH, 1, GETDATE())  -- next month
SELECT DATEADD(YEAR, -1, GETDATE())  -- last year

-------------------------------------------------------------------------
-- Differences between dates

SELECT DATEDIFF(DAY, '2025-01-01', GETDATE())
SELECT DATEDIFF(MONTH, '2024-01-01', GETDATE())
SELECT DATEDIFF(YEAR, '2000-01-01', GETDATE())

-------------------------------------------------------------------------
-- Cast dates formatting

SELECT CAST(GETDATE() AS DATE)        -- removes time
SELECT CONVERT(DATE, GETDATE())

SELECT CONVERT(VARCHAR, GETDATE(), 23) -- yyyy-mm-dd
SELECT FORMAT(GETDATE(), 'yyyy-MM')    -- slower but flexible

-------------------------------------------------------------------------
-- Get start of a date

-- start of the month
SELECT DATEFROMPARTS(YEAR(GETDATE()), MONTH(GETDATE()), 1)

-- end of the month
SELECT EOMONTH(GETDATE())

-------------------------------------------------------------------------
-- working with weekdays - what day of the week is the date

SELECT DATENAME(WEEKDAY, GETDATE())  -- Monday, Tuesday
SELECT DATEPART(WEEKDAY, GETDATE())  -- numeric

-------------------------------------------------------------------------
-- Last 30 days

WHERE 'ColumnName' >= DATEADD(DAY, -30, GETDATE())
--Current Month

WHERE 'ColumnName' >= DATEFROMPARTS(YEAR(GETDATE()), MONTH(GETDATE()), 1)

-- Year to date
WHERE 'ColumnName' >= DATEFROMPARTS(YEAR(GETDATE()), 1, 1)

-- Same period previous year
WHERE 'ColumnName' >= DATEADD(YEAR, -1, DATEFROMPARTS(YEAR(GETDATE()), MONTH(GETDATE()), 1))
-------------------------------------------------------------------------

