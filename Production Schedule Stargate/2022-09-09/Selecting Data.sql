USE Stargatedb
GO


--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------


-- Undated units to populate combo box with


SELECT
	[OrdersV2].*,
	[ProductionV2].*
FROM
	[BWSdb].[dbo].[OrdersV2]
LEFT JOIN
	[BWSdb].[dbo].[ProductionV2]
ON
	[OrdersV2].[SGQuote] = [ProductionV2].[SGQuote]
WHERE
	[Prod Date] IS NULL
	AND [Prod Date2] IS NULL
	AND [OrdersV2].[Order Date] IS NOT NULL
;


--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------


-- All units that currently have a production date slotted.


SELECT
	[OrdersV2].*
FROM
	[BWSdb].[dbo].[OrdersV2]
LEFT JOIN 
	[dtProductionSchedule]
ON
	[dtProductionSchedule].[SGQuote] = [OrdersV2].[SGQuote]
WHERE
	ISNULL([dtProductionSchedule].[Prod Date 1], [dtProductionSchedule].[Prod Date 2]) IS NOT NULL
ORDER BY
	ISNULL([dtProductionSchedule].[Prod Date 1], [dtProductionSchedule].[Prod Date 2])
;


--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------


SELECT
	*
FROM
	[dtProductionScheduleV2]
WHERE
	[dtProductionScheduleV2].[JobFinishDate] IS NOT NULL
ORDER BY [JobFinishDate] DESC
;


SELECT
	*
FROM
	[dtProductionSchedule]
LEFT JOIN
	[BWSdb].[dbo].[OrdersV2]
ON
	[dtProductionSchedule].[SGQuote] = [OrdersV2].[SGQuote]
WHERE
	ISNULL([dtProductionSchedule].[Prod Date 1], [dtProductionSchedule].[Prod Date 2]) IS NOT NULL
ORDER BY
	ISNULL([dtProductionSchedule].[Prod Date 1], [dtProductionSchedule].[Prod Date 2])
;



SELECT
	*
FROM
	[dtProductionSchedule]
WHERE
	ISNULL([dtProductionSchedule].[Prod Date 1], [dtProductionSchedule].[Prod Date 2]) IS NOT NULL
ORDER BY
	ISNULL([dtProductionSchedule].[Prod Date 1], [dtProductionSchedule].[Prod Date 2])
;

SELECT * FROM [Prod Lines]

DECLARE @lines AS TABLE ([ID] INT IDENTITY(1, 1), [Name] NVARCHAR(500));
INSERT INTO @lines ([Name]) VALUES ('T1'), ('T2'), ('T3'), ('T4'), ('T5'), ('T6');

SELECT * FROM @lines
SELECT * FROM [Production Days]
SELECT * FROM [SysproCompanyS].[dbo].[v_CalendarWorkDays] ORDER BY [CalendarDate] DESC


SELECT
	*
FROM
	[SysproCompanyS].[dbo].[v_CalendarWorkDays]
LEFT JOIN (

	SELECT
		[OrdersV2].*,
		[dtProductionSchedule].[Prod Date 1],
		[dtProductionSchedule].[Prod Date 2]
	FROM
		[BWSdb].[dbo].[OrdersV2]
	LEFT JOIN 
		[dtProductionSchedule]
	ON
		[dtProductionSchedule].[SGQuote] = [OrdersV2].[SGQuote]
	WHERE
		ISNULL([dtProductionSchedule].[Prod Date 1], [dtProductionSchedule].[Prod Date 2]) IS NOT NULL
	--ORDER BY
	--	[v_CalendarWorkDays].[CalendarDate]
		--ISNULL([dtProductionSchedule].[Prod Date 1], [dtProductionSchedule].[Prod Date 2])
) AS [Src]
	ON
		ISNULL([Src].[Prod Date 1], [Src].[Prod Date 2]) = [v_CalendarWorkDays].[CalendarDate]
ORDER BY
	[v_CalendarWorkDays].[CalendarDate] DESC
;


SELECT
	[CalendarDate]
FROM
	[SysproCompanyS].[dbo].[v_CalendarWorkDays]
LEFT JOIN (

	SELECT
		[OrdersV2].*,
		[dtProductionSchedule].[Prod Date 1],
		[dtProductionSchedule].[Prod Date 2]
	FROM
		[BWSdb].[dbo].[OrdersV2]
	LEFT JOIN 
		[dtProductionSchedule]
	ON
		[dtProductionSchedule].[SGQuote] = [OrdersV2].[SGQuote]
	WHERE
		ISNULL([dtProductionSchedule].[Prod Date 1], [dtProductionSchedule].[Prod Date 2]) IS NOT NULL
	--ORDER BY
	--	[v_CalendarWorkDays].[CalendarDate]
		--ISNULL([dtProductionSchedule].[Prod Date 1], [dtProductionSchedule].[Prod Date 2])
) AS [Src]
	ON
		ISNULL([Src].[Prod Date 1], [Src].[Prod Date 2]) = [v_CalendarWorkDays].[CalendarDate]
GROUP BY
	[v_CalendarWorkDays].[CalendarDate]
HAVING 
	COUNT(*) > 1
;



