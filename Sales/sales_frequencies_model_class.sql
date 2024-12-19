SELECT
	[ModelSrc].[C_M] AS [CompID]
	, [ModelSrc].[ProductID]
	, [ModelSrc].[Class]
	, [ModelSrc].[Model No]
	, ISNULL([OrderSrc].[NQuotes], 0) AS [NQuotes_Model]
	, ISNULL([OrderSrc].[NOrders], 0) AS [NOrders_Model]
	, ISNULL([ClassSrc].[NQuotes], 0) AS [NQuotes_Class]
	, ISNULL([ClassSrc].[NOrders], 0) AS [NOrders_Class]
	, ISNULL([CompSrc].[NQuotes], 0) AS [NQuotes_Company]
	, ISNULL([CompSrc].[NOrders], 0) AS [NOrders_Company]
	, [OrderSrc].[FirstQuote] AS [FirstQuote_Model]
	, [OrderSrc].[LastQuote] AS [LastQuote_Model]
	, [ClassSrc].[FirstQuote] AS [FirstQuote_Class]
	, [ClassSrc].[LastQuote] AS [LastQuote_Class]
	, [CompSrc].[FirstQuote] AS [FirstQuote_Company]
	, [CompSrc].[LastQuote] AS [LastQuote_Company]
	, ISNULL([OrderSrc].[NOrders], 0) / CAST((CASE WHEN ISNULL([OrderSrc].[NQuotes], 0) = 0 THEN 1 ELSE [OrderSrc].[NQuotes] END) AS DECIMAL(18, 8)) AS [CaptureRate_Model]
	, ISNULL([ClassSrc].[NOrders], 0) / CAST((CASE WHEN ISNULL([ClassSrc].[NQuotes], 0) = 0 THEN 1 ELSE [ClassSrc].[NQuotes] END) AS DECIMAL(18, 8)) AS [CaptureRate_Class]
	, ISNULL([CompSrc].[NOrders], 0) / CAST((CASE WHEN ISNULL([CompSrc].[NQuotes], 0) = 0 THEN 1 ELSE [CompSrc].[NQuotes] END) AS DECIMAL(18, 8)) AS [CaptureRate_Company]
	, [OrderSrc].[FirstDateQuote] AS [FirstDateQuote_Model]
	, [OrderSrc].[LastDateQuote] AS [LastDateQuote_Model]
	, [ClassSrc].[FirstDateQuote] AS [FirstDateQuote_Class]
	, [ClassSrc].[LastDateQuote] AS [LastDateQuote_Class]
	, [CompSrc].[FirstDateQuote] AS [FirstDateQuote_Company]
	, [CompSrc].[LastDateQuote] AS [LastDateQuote_Company]
FROM (
	SELECT
		[P].[IDTrailer] AS [ProductID]
		, [P].[Class]
		, [P].[Model No]
		, 0 AS [C_M]
	FROM
		[BWSdb].[dbo].[Products] [P]
	WHERE
		([P].[Proposed] = 0)
		AND ([P].[Non-Current] = 0)
		AND ([P].[CompanyID] = 0)
	UNION ALL
	SELECT
		[P2].[IDTrailer] AS [ProductID]
		, [P2].[Class]
		, [P2].[Model No]
		, 1 AS [C_M]
	FROM
		[BWSdb].[dbo].[ProductsV2] [P2]
	WHERE
		([P2].[Proposed] = 0)
		AND ([P2].[Non-Current] = 0)
		AND ([P2].[CompanyID] = 1)
) AS [ModelSrc]
LEFT JOIN (
	SELECT
		0 AS [C_O]
		, [O].[ProductID]
		, [O].[Model No]
		, COUNT(*) AS [NQuotes]
		, SUM((CASE WHEN [O].[Decline/Rejected] = 4 THEN 1 ELSE 0 END)) AS [NOrders]
		, MIN([O].[Quote#]) AS [FirstQuote]
		, MAX([O].[Quote#]) AS [LastQuote]
		, MIN([O].[Quote Date]) AS [FirstDateQuote]
		, MAX([O].[Quote Date]) AS [LastDateQuote]
	FROM
		[BWSdb].[dbo].[Orders] [O]
	GROUP BY
		[O].[ProductID]
		, [O].[Model No]
	UNION ALL
	SELECT
		1 AS [C_O]
		, [O2].[ProductID]
		, [O2].[Model No]
		, COUNT(*) AS [NQuotes]
		, SUM((CASE WHEN [O2].[Decline/Rejected] = 4 THEN 1 ELSE 0 END)) AS [NOrders]
		, MIN(CAST(RIGHT([O2].[SGQuote], 6) AS INT)) AS [FirstQuote]
		, MAX(CAST(RIGHT([O2].[SGQuote], 6) AS INT)) AS [LastQuote]
		, MIN([O2].[Quote Date]) AS [FirstDateQuote]
		, MAX([O2].[Quote Date]) AS [LastDateQuote]
	FROM
		[BWSdb].[dbo].[OrdersV2] [O2]
	GROUP BY
		[O2].[ProductID]
		, [O2].[Model No]
) AS [OrderSrc]
ON
	([ModelSrc].[ProductID] = [OrderSrc].[ProductID])
	AND ([ModelSrc].[C_M] = [OrderSrc].[C_O])
LEFT JOIN (
	SELECT
		[ModelSrc].[C_M] AS [CompID]
		, [ModelSrc].[Class]
		, ISNULL(SUM([OrderSrc].[NQuotes]), 0) AS [NQuotes]
		, ISNULL(SUM([OrderSrc].[NOrders]), 0) AS [NOrders]
		, MIN([OrderSrc].[FirstQuote]) AS [FirstQuote]
		, MAX([OrderSrc].[LastQuote]) AS [LastQuote]
		, MIN([OrderSrc].[FirstDateQuote]) AS [FirstDateQuote]
		, MAX([OrderSrc].[LastDateQuote]) AS [LastDateQuote]
	FROM (
		SELECT
			[P].[IDTrailer] AS [ProductID]
			, [P].[Class]
			, [P].[Model No]
			, 0 AS [C_M]
		FROM
			[BWSdb].[dbo].[Products] [P]
		WHERE
			([P].[Proposed] = 0)
			AND ([P].[Non-Current] = 0)
			AND ([P].[CompanyID] = 0)
		UNION ALL
		SELECT
			[P2].[IDTrailer] AS [ProductID]
			, [P2].[Class]
			, [P2].[Model No]
			, 1 AS [C_M]
		FROM
			[BWSdb].[dbo].[ProductsV2] [P2]
		WHERE
			([P2].[Proposed] = 0)
			AND ([P2].[Non-Current] = 0)
			AND ([P2].[CompanyID] = 1)
	) AS [ModelSrc]
	LEFT JOIN (
		SELECT
			0 AS [C_O]
			, [O].[ProductID]
			, [O].[Model No]
			, COUNT(*) AS [NQuotes]
			, SUM((CASE WHEN [O].[Decline/Rejected] = 4 THEN 1 ELSE 0 END)) AS [NOrders]
			, MIN([O].[Quote#]) AS [FirstQuote]
			, MAX([O].[Quote#]) AS [LastQuote]
			, MIN([O].[Quote Date]) AS [FirstDateQuote]
			, MAX([O].[Quote Date]) AS [LastDateQuote]
		FROM
			[BWSdb].[dbo].[Orders] [O]
		GROUP BY
			[O].[ProductID]
			, [O].[Model No]
		UNION ALL
		SELECT
			1 AS [C_O]
			, [O2].[ProductID]
			, [O2].[Model No]
			, COUNT(*) AS [NQuotes]
			, SUM((CASE WHEN [O2].[Decline/Rejected] = 4 THEN 1 ELSE 0 END)) AS [NOrders]
			, MIN(CAST(RIGHT([O2].[SGQuote], 6) AS INT)) AS [FirstQuote]
			, MAX(CAST(RIGHT([O2].[SGQuote], 6) AS INT)) AS [LastQuote]
			, MIN([O2].[Quote Date]) AS [FirstDateQuote]
			, MAX([O2].[Quote Date]) AS [LastDateQuote]
		FROM
			[BWSdb].[dbo].[OrdersV2] [O2]
		GROUP BY
			[O2].[ProductID]
			, [O2].[Model No]
	) AS [OrderSrc]
	ON
		([ModelSrc].[ProductID] = [OrderSrc].[ProductID])
		AND ([ModelSrc].[C_M] = [OrderSrc].[C_O])
	GROUP BY
		[ModelSrc].[C_M]
		,[ModelSrc].[Class]
) AS [ClassSrc]
ON
	[ModelSrc].[Class] = [ClassSrc].[Class]
LEFT JOIN (
	SELECT
		0 AS [C_C]
		, COUNT(*) AS [NQuotes]
		, SUM((CASE WHEN [O].[Decline/Rejected] = 4 THEN 1 ELSE 0 END)) AS [NOrders]
		, MIN([O].[Quote#]) AS [FirstQuote]
		, MAX([O].[Quote#]) AS [LastQuote]
		, MIN([O].[Quote Date]) AS [FirstDateQuote]
		, MAX([O].[Quote Date]) AS [LastDateQuote]
	FROM
		[BWSdb].[dbo].[Orders] [O]
	UNION ALL
	SELECT
		1 AS [C_C]
		, COUNT(*) AS [NQuotes]
		, SUM((CASE WHEN [O2].[Decline/Rejected] = 4 THEN 1 ELSE 0 END)) AS [NOrders]
		, MIN(CAST(RIGHT([O2].[SGQuote], 6) AS INT)) AS [FirstQuote]
		, MAX(CAST(RIGHT([O2].[SGQuote], 6) AS INT)) AS [LastQuote]
		, MIN([O2].[Quote Date]) AS [FirstDateQuote]
		, MAX([O2].[Quote Date]) AS [LastDateQuote]
	FROM
		[BWSdb].[dbo].[OrdersV2] [O2]
) AS [CompSrc]
ON
	[ModelSrc].[C_M] = [CompSrc].[C_C]
ORDER BY
	[ModelSrc].[Model No]