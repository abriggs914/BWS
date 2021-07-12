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

EXEC [dbo].[sp_ProductionScheduleDateShift]
	@Line = 'TS1',
	@StartDate = '2021-07-14',
	@Days = -12

SELECT *, [dbo].NEXT_BUSINESS_DAY([CalendarDate], DEFAULT) AS [Next Day] FROM [SysproCompanyA].[dbo].[v_CalendarWorkDays] ORDER BY [CalendarDate]


SELECT [dbo].NEXT_BUSINESS_DAY('2021-06-30', DEFAULT) AS [Next Business Day];
SELECT [dbo].NEXT_BUSINESS_DAY('2021-06-30', 2) AS [Next Business Day];
SELECT [dbo].NEXT_BUSINESS_DAY('2021-06-30', 3) AS [Next Business Day];
SELECT [dbo].NEXT_BUSINESS_DAY('2021-07-12', -131) AS [Next Business Day];


DECLARE @DateIn DATETIME
DECLARE @NDays INT = 5
SET @DateIn = '2021-07-12'
SELECT TOP(1)
	[CalendarDate]
FROM (
	SELECT
		TOP(ABS(@NDays)) [CalendarDate]
	FROM
		[SysproCompanyA].[dbo].[v_CalendarWorkDays]
	WHERE
		@DateIn > [CalendarDate]
		AND [WorkDay] = 1
	ORDER BY
		[CalendarDate] DESC
) AS [CalendarDate]
ORDER BY
	[CalendarDate] ASC
	
SELECT * FROM [Defects_Location] WHERE [Location] LIKE '%T11  T11%'
SELECT * FROM [Defects] WHERE [Location] LIKE '%tll  tll%' OR [LocationID] LIKE '%tll  tll%'


SELECT * FROM [Defects_Location] WHERE [Location] LIKE '%T11%'
