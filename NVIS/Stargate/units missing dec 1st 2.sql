
DECLARE @dateOfEndProd AS DATETIME;
SELECT @dateOfEndProd = '2022-12-01';
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