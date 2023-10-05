USE BWSdb
GO


DECLARE @dpm AS TABLE([Month] INT, [Days] INT);
INSERT INTO @dpm ([Month], [Days]) VALUES
(1, 31),
(2, 28),
(3, 31),
(4, 30),
(5, 31),
(6, 30),
(7, 31),
(8, 31),
(9, 30),
(10, 31),
(11, 30),
(12, 31)

-- 2023-10-05 1850
-- Every daily quote for each currently active dealer
-- Answers "How many quotes became units for this dealer grouped by one of (Annual, Quarterly, Monthly, Weekly)."
-- Dealer specifics

DECLARE @dealerID AS INT;
DECLARE @mode AS NVARCHAR(MAX);
DECLARE @dateIn AS DATETIME;
DECLARE @dateMonth AS INT;
DECLARE @dateYear AS INT;
DECLARE @periodLen AS DECIMAL(10, 6);

-- mode
-- 0 - annual
-- 1 - quarterly
-- 2 - monthly
-- 3 - weekly
-- 4 - Daily

SELECT
	@dateIn = '2023-09-30'
	, @dealerID = NULL
	, @mode = 0
	, @dateMonth = MONTH(@dateIn)
	, @dateYear = YEAR(@dateIn)
	, @periodLen = (
		CASE @mode
			WHEN 1 THEN 365/4
			WHEN 2 THEN 365/12
			WHEN 3 THEN 365/52
			WHEN 4 THEN 1
			ELSE 365
		END)
;

--SELECT
--	MIN([Date])
--	, MAX([Date])
--	, DATEDIFF(DAY, MAX([Date]), MIN([Date]))
--FROM 
--	[Calendar]
--WHERE
--	[Date] <= @dateIn

SELECT
	[ID]
	, SUM([QuotesFromDay]) AS [TtlQuotes]
	, SUM([OrdersFromDay]) AS [TtlOrders]
	, [DFQByPeriod]
	, [US Sale]
	, SUM([Price]) AS [TtlPrice]
	, MIN([Date]) AS [FirstDate]
	, MAX([Date]) AS [LastDate]
FROM (
	SELECT
		[C].[Date]
		, [Quote Date]
		, [ID]
		, [DealerID]
		, DAY([C].[Date]) AS [D]
		, MONTH([C].[Date]) AS [M]
		, YEAR([C].[Date]) AS [Y]

		, [Decline/Rejected] 
		, [Date Declined] 
		, [Quote#] 
		, [O].[WO#]
		, [Serial Number]
		, [Order Date]
		, [Prod Date]
		, [Delivery Date]
		, [Sales Person]	
		, [O].[Shipped Date]
		, [O].[PO Date]
		, [O].[Finish Date]
		, [O].[Available Date]
		, [O].[Date In Service]
		, [O].[Price]
		, [O].[US Sale]
		, ABS(DATEDIFF(DAY, [Order Date], [Date])) AS [DaysQuoteToOrder]
		, ABS(DATEDIFF(DAY, [Prod Date], [Shipped Date])) AS [DaysProduction]
		
		, (CASE WHEN [Quote#] IS NOT NULL THEN 1 ELSE 0 END) AS [QuotesFromDay]
		, (CASE WHEN [Date Declined] IS NULL AND [Decline/Rejected] = 4 AND [Order Date] IS NOT NULL THEN 1 ELSE 0 END) AS [OrdersFromDay]

		, ABS(DATEDIFF(DAY, @dateIn, [Date])) AS [DaysFromQuote]
		, FLOOR(ABS(DATEDIFF(DAY, @dateIn, [Date])) / @periodLen) AS [DFQByPeriod]
	FROM 
		[Calendar] AS [C]
	CROSS JOIN
		[Dealers] AS [D]
	LEFT JOIN (
		SELECT
			[Quote Date]
			, [DealerID]

			, [Decline/Rejected] 
			, [Date Declined] 
			, [O].[Quote#]
			, [O].[WO#]
			, [Serial Number]
			, [Order Date]
			, [Delivery Date]
			, [O].[Shipped Date]
			, [O].[PO Date]
			, [O].[Finish Date]
			, [O].[Available Date]
			, [O].[Date In Service]
			, [O].[Price]
			, [O].[US Sale]
			, (CASE WHEN [Prod Date 1] IS NOT NULL AND [Prod Date 2] IS NOT NULL THEN (CASE WHEN [Prod Date 1] <= [Prod Date 2] THEN [Prod Date 1] ELSE [Prod Date 2] END)
			 WHEN [Prod Date 1] IS NOT NULL THEN [Prod Date 1] ELSE [Prod Date 2] END) AS [Prod Date]
			, [S].[Sales Person]
		FROM 
			[Orders] AS [O]
		LEFT JOIN
			[dtProductionSchedule] AS [D]
		ON
			[O].[Quote#] = [D].[Quote#]
		LEFT JOIN	
			[Sales Staff] AS [S]
		ON
			[O].[Sale PersonID] = [S].[ID-SaleStaff]
		WHERE
			[Quote Date] IS NOT NULL
		GROUP BY
			[Quote Date]
			, [DealerID]

			, [Decline/Rejected] 
			, [Date Declined] 
			, [O].[Quote#] 
			, [O].[WO#]
			, [Serial Number]
			, [Order Date]
			, [Delivery Date]
			, [Prod Date 1]
			, [Prod Date 2] 
			, [S].[Sales Person]
			, [O].[Shipped Date]
			, [O].[PO Date]
			, [O].[Finish Date]
			, [O].[Available Date]
			, [O].[Date In Service]
			, [O].[Price]
			, [O].[US Sale]
	) AS [O]
	ON
		[C].[Date] = [O].[Quote Date]
		AND ([O].[DealerID] = [D].[ID])
	WHERE
		[Date] IS NOT NULL
		AND [D].[CURRENT DEALER] = 1
		AND [C].[Date] <= @dateIn
		AND [US Sale] IS NOT NULL
		--AND ((CASE WHEN [US Sale] IS NOT NULL THEN 1 ELSE 0 END) = 1)
) AS [Src]
WHERE
	(CASE WHEN @dealerID IS NULL THEN 1
		ELSE (CASE WHEN [ID] = @dealerID THEN 1 ELSE 0 END)
	END) = 1
GROUP BY
	[ID]
	, [DFQByPeriod]
	, [US Sale]
ORDER BY
	[ID]
	, [DFQByPeriod]
