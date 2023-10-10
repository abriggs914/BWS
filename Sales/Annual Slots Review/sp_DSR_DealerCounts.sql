USE BWSdb
GO

-- 2023-10-06 1334


ALTER PROCEDURE [sp_DSR_DealerCounts]
--DECLARE,
	@dateIn DATETIME=NULL,
	@dealerID INT=NULL,
	@mode NVARCHAR(MAX)=-1
AS BEGIN

	DECLARE
		@dateMonth AS INTEGER
		, @dateYear AS INTEGER
		, @periodLen AS DECIMAL(18, 8)
	;

	-- mode
	-- 0 - annual
	-- 1 - quarterly
	-- 2 - monthly
	-- 3 - weekly

	-- Negative mode queries each dealer
	-- Positive mode queries each day and each quote. If more than one quote for this day, then multiple records for that day

	SELECT
		@dateIn = ISNULL(@dateIn, GETDATE())
		, @dateMonth = MONTH(@dateIn)
		, @dateYear = YEAR(@dateIn)
		, @periodLen = (
			CASE ABS(@mode)
				WHEN 2 THEN 365/4
				WHEN 3 THEN 365/12
				WHEN 4 THEN 365/52
				ELSE 365
			END)
	;

	IF @mode < 0 BEGIN

		--  By Dealer
	
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
				, CAST([O].[Price] AS DECIMAL(18, 8)) AS [Price]
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
					, CAST([O].[Price] AS DECIMAL(18, 8)) AS [Price]
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
					, CAST([O].[Price] AS DECIMAL(18, 8))
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

	END
	ELSE BEGIN

		-- By Date and Quote

		SELECT
			*
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
					, CAST([O].[Price] AS DECIMAL(18, 8)) AS [Price]
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
					, CAST([O].[Price] AS DECIMAL(18, 8))
					, [O].[US Sale]
			) AS [O]
			ON
				[C].[Date] = [O].[Quote Date]
				AND ([O].[DealerID] = [D].[ID])
			WHERE
				[Date] IS NOT NULL
				AND [D].[CURRENT DEALER] = 1
				AND [C].[Date] <= @dateIn
		) AS [Src]
		WHERE
			(CASE WHEN @dealerID IS NULL THEN 1
				ELSE (CASE WHEN [ID] = @dealerID THEN 1 ELSE 0 END)
			END) = 1
		ORDER BY
			[Date]
			, [ID]
	END

END