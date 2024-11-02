-- Whacky margins on WOs


DECLARE @t TABLE ([ID] INT IDENTITY(0, 1), [WO] INT);
INSERT INTO @t ([WO]) VALUES
(10015089),
(10015071),
(10015070),
(10015069)


SELECT
	*
FROM
	[BWSdb].[dbo].[v_SAL_OrdersPricing] [OP]
INNER JOIN
	@t [T]
ON
	[OP].[WO#] = [T].[WO]




SELECT
	[Step2].[Quote Date]
	,[Step2].[Delivery Date]
	,[Step2].[WO#]
	,[Step2].[Quote#]
	,[Step2].[Model No]
	,[Step2].[Dealer]
	,[Step2].[US Sale]
	,[Step2].[OrderBasePrice]
	,[Step2].[SumOfValueIssued_MadeIn]
	,[Step2].[SumOfValueIssued_BoughtOut]
	,[Step2].[SumOfValueIssued_SubContract]
	,[Step2].[SumOfLabourAct]
	,[Step2].[SumOfLabourBud]
	,[Step2].[SumOfLabourOverUnder]
	,[Step2].[SalePrice]
	,[Step2].[ExchangeRate]
	,[Step2].[Completed]
	,[Step2].[ActCompleteDate]
	,[Step2].[JobStartDate]
	,[Step2].[SalePriceCDN]
	,[Step2].[TotalCostSoFar]
	,[Step2].[SalePriceCDN] - [Step2].[TotalCostSoFar] AS [MarginCDN$]
	,(CASE WHEN [Step2].[TotalCostSoFar] = 0 THEN 0 ELSE [Step2].[SalePriceCDN] / [Step2].[TotalCostSoFar] END) AS [RatioSaleToCostCDN]
	,(CASE WHEN [Step2].[TotalCostSoFar] = 0 THEN 0 ELSE (([Step2].[SalePriceCDN] / [Step2].[TotalCostSoFar]) - 1) END) AS [MarginCDN%]
	,[OP].*
FROM (
	SELECT
		[Quote Date]
		,[Delivery Date]
		,[WO#]
		,[Quote#]
		,[Model No]
		,[Dealer]
		,[US Sale]
		,[OrderBasePrice]
		,[ProductBasePrice]
		,[ProductBasePriceUS]
		,[SumOfValueIssued_MadeIn]
		,[SumOfValueIssued_BoughtOut]
		,[SumOfValueIssued_SubContract]
		,[SumOfLabourAct]
		,[SumOfLabourBud]
		,[SumOfLabourOverUnder]
		,[SalePrice]
		,[ExchangeRate]
		,[Completed]
		,[ActCompleteDate]
		,[JobStartDate]
		,[SalePriceCDN]
		,[SumOfValueIssued_MadeIn] + [SumOfValueIssued_BoughtOut] + [SumOfValueIssued_SubContract] + [SumOfLabourAct] AS [TotalCostSoFar]
	FROM (
		SELECT
			[WL].[Quote Date]
			,[WL].[Delivery Date]
			,[WL].[WO#]
			,[WL].[Quote#]
			,[WL].[Model No]
			,[WL].[Dealer]
			,[WL].[US Sale]
			,[WL].[OrderPrice] AS [OrderBasePrice]
			,[WL].[ProductPrice] AS [ProductBasePrice]
			,[WL].[ProductPriceUS] AS [ProductBasePriceUS]
			,SUM(CASE WHEN [JP].[PartCategory] = 'M' THEN [JP].[ValueIssued] ELSE 0 END) AS [SumOfValueIssued_MadeIn]
			,SUM(CASE WHEN [JP].[PartCategory] = 'B' THEN [JP].[ValueIssued] ELSE 0 END) AS [SumOfValueIssued_BoughtOut]
			,SUM(CASE WHEN [JP].[PartCategory] = 'G' THEN [JP].[ValueIssued] ELSE 0 END) AS [SumOfValueIssued_SubContract]
			,ISNULL([Lab].[SumOfLabourAct], 0) AS [SumOfLabourAct]
			,ISNULL([Lab].[SumOfLabourBud], 0) AS [SumOfLabourBud]
			,ISNULL([Lab].[SumOfLabourBud], 0) - ISNULL([Lab].[SumOfLabourAct], 0) AS [SumOfLabourOverUnder]
			,ISNULL([OP].[NetCost], 0) AS [SalePrice]
			,[WL].[ExchangeRate]
			,[WL].[Completed]
			,[WL].[ActCompleteDate]
			,[WL].[JobStartDate]
			,ISNULL([OP].[NetCostCDN], 0) AS [SalePriceCDN]
		FROM (
			SELECT
				CAST([O].[WO#] AS NVARCHAR(MAX)) AS [WO#]
				,[O].[Quote Date]
				,[O].[Delivery Date]
				,[O].[US Sale]
				,[O].[Quote#]
				,[O].[Model No]
				,[D].[COMPANY NAME] AS [Dealer]
				,[O].[Price] AS [OrderPrice]
				,[P].[Price] AS [ProductPrice]
				,[P].[US Price] AS [ProductPriceUS]
				,[SM].[ExchangeRate]
				--,(CASE WHEN [CJ].[Job] IS NOT NULL THEN 1 ELSE 0 END) AS [Completed]
				,[WM].[JobStartDate]
				,[WM].[ActCompleteDate]
				,(CASE WHEN [WM].[ActCompleteDate] IS NULL THEN 0 ELSE 1 END) AS [Completed]
			FROM
				[BWSdb].[dbo].[Orders] [O] WITH (NOLOCK)
			INNER JOIN
				[BWSdb].[dbo].[Products] [P] WITH (NOLOCK)
			ON
				[O].[ProductID] = [P].[IDTrailer]
			LEFT JOIN
				[BWSdb].[dbo].[Dealers] [D] WITH (NOLOCK)
			ON
				[O].[DealerID] = [D].[ID]
			--LEFT JOIN
			--	[SysproCompanyS].[dbo].[v_CompletedJobInfo] [CJ] WITH (NOLOCK)
			--ON
			--	[O2].[Sales Order#] = CAST([CJ].[Sales Order#] AS INT)
			LEFT JOIN
				[SysproCompanyA].[dbo].[SorMaster] [SM] WITH (NOLOCK)
			ON
				CAST([O].[Sales Order#] AS NVARCHAR(MAX)) = [SM].[SalesOrder]
			LEFT JOIN
				[SysproCompanyA].[dbo].[WipMaster] [WM] WITH (NOLOCK)
			ON
				CAST([O].[WO#] AS NVARCHAR(MAX)) = [WM].[Job]
			--WHERE
			--	([P2].[Model No] = 'Frameless End Dump 2X')
			--	OR
			--	([P2].[Model No] = 'Frameless End Dump 3X')
			--	OR
			--	([O2].[WO#] = 10001577)
			GROUP BY
				CAST([O].[WO#] AS NVARCHAR(MAX))
				,[O].[Quote Date]
				,[O].[Delivery Date]
				,[O].[US Sale]
				,[O].[Quote#]
				,[O].[Model No]
				,[D].[COMPANY NAME]
				,[O].[Price]
				,[P].[Price]
				,[P].[US Price]
				,[SM].[ExchangeRate]
				,[WM].[ActCompleteDate]
				,[WM].[JobStartDate]
		) AS [WL]
		LEFT JOIN
			[SysproCompanyA].[dbo].[v_WorkOrderStatus] [JP] WITH (NOLOCK)
		ON
			[WL].[WO#] = [JP].[Job]
		LEFT JOIN (
			SELECT
				[Job]
				,ISNULL(SUM([ValueIssued]), 0) AS [SumOfLabourAct]
				,ISNULL(SUM([Lab].[UnitValueReqd]), 0) AS [SumOfLabourBud]
			FROM
				[SysproCompanyA].[dbo].[WipJobAllLab] [Lab] WITH (NOLOCK)
			GROUP BY
				[Job]
		) AS [Lab]
		ON
			[Lab].[Job] = [JP].[Job]
		LEFT JOIN
			[BWSdb].[dbo].[v_SAL_OrdersPricing] [OP] WITH (NOLOCK)
		ON
			[WL].[Quote#] = [OP].[Quote#]
		GROUP BY
			[WL].[WO#]
			,[WL].[Quote Date]
			,[WL].[Delivery Date]
			,[WL].[US Sale]
			,[WL].[Quote#]
			,[WL].[Model No]
			,[Wl].[Dealer]
			,[WL].[OrderPrice]
			,[WL].[ProductPrice]
			,[WL].[ProductPriceUS]
			,[WL].[ExchangeRate]
			,[WL].[Completed]
			,[WL].[ActCompleteDate]
			,[WL].[JobStartDate]
			,[Lab].[SumOfLabourAct]
			,[Lab].[SumOfLabourBud]
			,[OP].[NetCost]
			,[OP].[NetCostCDN]
	) AS [Step1]
) AS [Step2]
LEFT JOIN
	[BWSdb].[dbo].[v_SAL_OrdersPricing] [OP]
ON
	([Step2].[Quote#] = [OP].[Quote#])
	AND (CAST([Step2].[WO#] AS INT) = [OP].[WO#])
;