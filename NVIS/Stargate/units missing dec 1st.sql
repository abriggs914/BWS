USE Stargatedb
GO


DECLARE @dateOfEndProd AS DATETIME;
SELECT @dateOfEndProd = '2022-12-01';

SELECT '[Stargatedb].[dbo].[dtProductionSchedule]',	* FROM [Stargatedb].[dbo].[dtProductionSchedule] WITH (NOLOCK);
SELECT '[Stargatedb].[dbo].[dtProductionScheduleV2]', * FROM [Stargatedb].[dbo].[dtProductionScheduleV2] WITH (NOLOCK);
--SELECT '[Stargatedb].[dbo].[Orders]', * FROM [Stargatedb].[dbo].[Orders] WITH (NOLOCK);
--SELECT '[BWSdb].[dbo].[dtProductionSchedule]', * FROM [BWSdb].[dbo].[dtProductionSchedule] WITH (NOLOCK);
SELECT '[BWSdb].[dbo].[ProductionV2]', * FROM [BWSdb].[dbo].[ProductionV2] WITH (NOLOCK);
--SELECT '[BWSdb].[dbo].[Production]', * FROM [BWSdb].[dbo].[Production] WITH (NOLOCK);
--SELECT '[BWSdb].[dbo].[Orders]', * FROM [BWSdb].[dbo].[Orders] WITH (NOLOCK);
SELECT '[BWSdb].[dbo].[OrdersV2]', * FROM [BWSdb].[dbo].[OrdersV2] WITH (NOLOCK);


SELECT
	[FD A],
	[JobFinishDate],
	[PO Date],
	*
FROM (
	SELECT
		[OrdersV2].[Finish Date] AS [FD A],
		[dtProductionScheduleV2].[JobFinishDate],
		[OrdersV2].* 
	FROM
		[BWSdb].[dbo].[OrdersV2] WITH (NOLOCK)
	LEFT JOIN
		[Stargatedb].[dbo].[dtProductionScheduleV2] WITH (NOLOCK)
	ON
		[OrdersV2].[SGQuote] = [dtProductionScheduleV2].[SGQuote]
) AS [A]
ORDER BY
	[A].[FD A] DESC
;




SELECT
	*
FROM (
	SELECT
		[Prod Date 1],
		[Prod Date 2],
		ISNULL([Prod Date 1], [Prod Date 2]) AS [PD],
		[OrdersV2].* 
	FROM
		[BWSdb].[dbo].[OrdersV2] WITH (NOLOCK)
	LEFT JOIN
		[dtProductionScheduleV2] WITH (NOLOCK)
	ON
		[OrdersV2].[SGQuote] = [dtProductionScheduleV2].[SGQuote]
	LEFT JOIN
		[Stargatedb].[dbo].[dtProductionSchedule] WITH (NOLOCK)
	ON
		[OrdersV2].[SGQuote] = [dtProductionSchedule].[SGQuote]
	WHERE
		--ISNULL([Prod Date 1], [Prod Date 2]) > @dateOfEndProd
		[PO Date] > @dateOfEndProd
) AS [A]
ORDER BY
	[PD] DESC
;
