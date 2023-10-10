
DECLARE @t AS TABLE(
	[ID] INT IDENTITY(0, 1),
	[DealerID] INT,
	
	[USDealer] BIT,
	[CDNDealer] BIT,
	[TtlQuotes] INT,
	[TtlOrders] INT,
	[PeriodGrouping] INT,
	[USSale] BIT,
	[TtlPrice] DECIMAL(18, 8),
	[FirstDate] DATETIME,
	[lastDate] DATETIME
)

INSERT INTO @t
EXEC sp_DSR_DealerCounts
	@dateIn='2023-10-10',
	@mode=-1,
	@maxYearsBack=2
;

SELECT
	*
FROM
	@t
;

SELECT
		[Dealers].[COMPANY NAME],
		Sum([dt_DSD_DealerCounts_BWS].[TtlQuotes]) AS [SumOfTtlQuotes],
		Sum([dt_DSD_DealerCounts_BWS].[TtlOrders]) AS [SumOfTtlOrders],
		[dt_DSD_DealerCounts_BWS].[USDealer],
		[dt_DSD_DealerCounts_BWS].[CDNDealer]
	FROM (
			SELECT
				*
			FROM
				@t

		) AS [dt_DSD_DealerCounts_BWS]
	INNER JOIN 
		[Dealers]
	ON
		[dt_DSD_DealerCounts_BWS].[DealerID] = [Dealers].[ID]
	GROUP BY
		[Dealers].[COMPANY NAME],
		[dt_DSD_DealerCounts_BWS].[USDealer],
		[dt_DSD_DealerCounts_BWS].[CDNDealer]


SELECT
[COMPANY NAME],
	SUM([qd_DSD_QuotesVsOrdersByCountry].[SumOfTtlQuotes]) AS [SumOfSumOfTtlQuotes],
	SUM([qd_DSD_QuotesVsOrdersByCountry].[SumOfTtlOrders]) AS [SumOfSumOfTtlOrders],
	COUNT(*) AS [CountOfDealers]
	,(CASE WHEN [COMPANY NAME] = 'Remorques Lewis Inc.' THEN
		0
	ELSE (CASE WHEN [CDNDealer] = 1 THEN 1 ELSE 2 END)
	END) AS [DELETE ME]
FROM (
	
	SELECT
		[Dealers].[COMPANY NAME],
		Sum([dt_DSD_DealerCounts_BWS].[TtlQuotes]) AS [SumOfTtlQuotes],
		Sum([dt_DSD_DealerCounts_BWS].[TtlOrders]) AS [SumOfTtlOrders],
		[dt_DSD_DealerCounts_BWS].[USDealer],
		[dt_DSD_DealerCounts_BWS].[CDNDealer]
	FROM (
			SELECT
				*
			FROM
				@t

		) AS [dt_DSD_DealerCounts_BWS]
	INNER JOIN 
		[Dealers]
	ON
		[dt_DSD_DealerCounts_BWS].[DealerID] = [Dealers].[ID]
	GROUP BY
		[Dealers].[COMPANY NAME],
		[dt_DSD_DealerCounts_BWS].[USDealer],
		[dt_DSD_DealerCounts_BWS].[CDNDealer]

) AS [qd_DSD_QuotesVsOrdersByCountry]
GROUP BY 
[COMPANY NAME],
	--(CASE WHEN [COMPANY NAME] = 'Northeast Truck & Trailer Sales' THEN
	(CASE WHEN [COMPANY NAME] = 'Remorques Lewis Inc.' THEN
		0
	ELSE (CASE WHEN [CDNDealer] = 1 THEN 1 ELSE 2 END)
	END)
	--IIF([COMPANY NAME] = "Northeast Truck & Trailer Sales",
	--0,
	--IIF([CDNDealer], 1, 2));
ORDER BY
	[COMPANY NAME]
