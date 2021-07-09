USE BWSdb
GO

EXEC [sp_ProductionScheduleDateShift]
	@Line = 'T1',
	@StartDate = '2021-06-07',
	@Days = 3
;

SELECT DATEPART(weekday, '2007-05-10  00:00:01.1234567 +05:10'),
	DATEPART(weekday, '2007-05-11  00:00:01.1234567 +05:10'),
	DATEPART(weekday, '2007-05-12  00:00:01.1234567 +05:10'),
    DATEPART(weekday, '2007-05-13  00:00:01.1234567 +05:10');  


DECLARE @Prod1Date DATE;
DECLARE @Tomorrow DATE;
SET @Prod1Date = '2021-07-07'
SET @Tomorrow = '2021-07-08'
SELECT DATEDIFF(d, @Tomorrow, @Prod1Date) AS [Date Diff];
SELECT [dbo].NEXT_BUSINESS_DAY(@Prod1Date, DEFAULT) AS [Next Business Day];

SELECT * FROM [Production];
SELECT * FROM [dtProductionSchedule];



-- Insure that the update criteria matched the query results
DECLARE @Line VARCHAR(3);
DECLARE @StartDate DATE;
SET @Line = 'T1'
SET @StartDate = '2021-07-08'

SELECT
	*
FROM
	[dtProductionSchedule]
Where
	@Line LIKE [WO Line 1]
	AND @StartDate <= [Prod Date 1]
;
SELECT
	*
FROM
	[Production]
Where
	@Line LIKE [Prod Line]
	AND @StartDate <= [Prod Date]
;

EXEC [dbo].[sp_ProductionScheduleDateShift]
	@Line = @Line,
	@StartDate = @StartDate,
	@Days = 1