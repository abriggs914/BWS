-- holiday this week?


CREATE PROCEDURE [sp_CheckUpcomingHolidays]
	@sd AS DATETIME
	, @d AS INT = 9
AS BEGIN

--DECLARE @sd AS DATETIME = '2023-04-01';
--DECLARE @d AS INT = 9;

SELECT DISTINCT
	[Date]
	, [HolidayName]
FROM
	[Calendar]
WHERE
	[HolidayName] IS NOT NULL
	AND [Date] BETWEEN @sd AND DATEADD(DAY, @d, @sd)
	--[Date] BETWEEN @sd AND DATEADD(DAY, @d, @sd)

END
