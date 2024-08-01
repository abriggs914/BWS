-- Tue Oct 29th 2024

DECLARE @d1 DATETIME = '2024-10-29'


SELECT
	[SysproCompanyS].[dbo].[GetNthBusinessDay](@d1, 3)

	
SELECT
	*
FROM
	[BWSDB].[dbo].[Calendar]
;


SELECT
	*
FROM
	[SysproCompanyS].[dbo].[v_CalendarWorkDays]
;



SELECT
	[C].[Date] AS [C_Date]
	,[C].[Day] AS [C_Day]
	,[C].[DayOfWeek] AS [C_DayOfWeek]
	,[C].[SAT Holiday] AS [C_SATHoliday]
	,[C].[STAT Holiday] AS [C_STATHoliday]
	,[C].[HolidayName] AS [C_HolidayName]

	,[vC].[CalendarDate] AS [vC_DateCalendar]
	,[vC].[WorkDay] AS [vC_WorkDay]
FROM
	[BWSDB].[dbo].[Calendar] AS [C] WITH (NOLOCK)
FULL OUTER JOIN
	[SysproCompanyS].[dbo].[v_CalendarWorkDays] AS [vC] WITH (NOLOCK)
ON
	[C].[Date] = [vC].[CalendarDate]
WHERE
	[C].[Date] IS NOT NULL
ORDER BY
	[C].[Date]
;




SELECT
	[Available Date],
	[JobAvailableLine],
	[JobAvailableScheduled],
	[JobAvailableScheduledBy]
FROM
	[BWSdb].[dbo].[OrdersV2]
WHERE
	[SGQuote] = 'SG101461'


SELECT
	*
FROM
	[Stargatedb].[dbo].[PDS Valid Updaters]