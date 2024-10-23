
-- 2024-10-22 2142 Avery Briggs
-- Gather WOs for 'Frameless End Dump 2X' and 'Frameless End Dump 3X' models in Stargte sales system.
-- Report margin data, as the WO final costing report does not exist yet for Stargate.


SELECT
	[Quote Date]
	,[Delivery Date]
	,[WO#]
	,[SGQuote]
	,[Model No]
	,[Dealer]
	,[US Sale]
	,[OrderBasePrice]
	,[ProductBasePrice]
	,[SumOfValueIssued_MadeIn]
	,[SumOfValueIssued_BoughtOut]
	,[SumOfValueIssued_SubContract]
	,[SumOfLabourAct]
	,[SumOfLabourBud]
	,[SumOfLabourOverUnder]
	,[SalePrice]
	,[TotalCostSoFar]
	,[SalePrice] - [TotalCostSoFar] AS [Margin$]
	,(CASE WHEN [TotalCostSoFar] = 0 THEN 0 ELSE [SalePrice] / [TotalCostSoFar] END) AS [RatioSaleToCost]
	,(CASE WHEN [TotalCostSoFar] = 0 THEN 0 ELSE (([SalePrice] / [TotalCostSoFar]) - 1) * 100 END) AS [Margin%]
FROM (
	SELECT
		[Quote Date]
		,[Delivery Date]
		,[WO#]
		,[SGQuote]
		,[Model No]
		,[Dealer]
		,[US Sale]
		,[OrderBasePrice]
		,[ProductBasePrice]
		,[SumOfValueIssued_MadeIn]
		,[SumOfValueIssued_BoughtOut]
		,[SumOfValueIssued_SubContract]
		,[SumOfLabourAct]
		,[SumOfLabourBud]
		,[SumOfLabourOverUnder]
		,[SalePrice]
		,[SumOfValueIssued_MadeIn] + [SumOfValueIssued_BoughtOut] + [SumOfValueIssued_SubContract] + [SumOfLabourAct] AS [TotalCostSoFar]
	FROM (
		SELECT
			[WL].[Quote Date]
			,[WL].[Delivery Date]
			,[WL].[WO#]
			,[WL].[SGQuote]
			,[WL].[Model No]
			,[WL].[Dealer]
			,[WL].[US Sale]
			,[WL].[OrderPrice] AS [OrderBasePrice]
			,[WL].[ProductPrice] AS [ProductBasePrice]
			--,[JP].[PartCategory]
			,SUM(CASE WHEN [JP].[PartCategory] = 'M' THEN [JP].[ValueIssued] ELSE 0 END) AS [SumOfValueIssued_MadeIn]
			,SUM(CASE WHEN [JP].[PartCategory] = 'B' THEN [JP].[ValueIssued] ELSE 0 END) AS [SumOfValueIssued_BoughtOut]
			,SUM(CASE WHEN [JP].[PartCategory] = 'G' THEN [JP].[ValueIssued] ELSE 0 END) AS [SumOfValueIssued_SubContract]
			,ISNULL([Lab].[SumOfLabourAct], 0) AS [SumOfLabourAct]
			,ISNULL([Lab].[SumOfLabourBud], 0) AS [SumOfLabourBud]
			,ISNULL([Lab].[SumOfLabourBud], 0) - ISNULL([Lab].[SumOfLabourAct], 0) AS [SumOfLabourOverUnder]
			--,SUM([Lab].[ValueIssued]) AS [SumOfValueIssued_Labour]
			,ISNULL([OP2].[NetCost], 0) AS [SalePrice]
		FROM (
			SELECT
				CAST([O2].[WO#] AS NVARCHAR(MAX)) AS [WO#]
				,[O2].[Quote Date]
				,[O2].[Delivery Date]
				,[O2].[US Sale]
				,[O2].[SGQuote]
				,[O2].[Model No]
				,[D2].[COMPANY NAME] AS [Dealer]
				,[O2].[Price] AS [OrderPrice]
				,[P2].[Price] AS [ProductPrice]
			FROM
				[BWSdb].[dbo].[OrdersV2] [O2]
			INNER JOIN
				[BWSdb].[dbo].[ProductsV2] [P2]
			ON
				[O2].[ProductID] = [P2].[IDTrailer]
				--[O2].[Model No] = [P2].[Model No]
			LEFT JOIN
				[BWSdb].[dbo].[DealersV2] [D2]
			ON
				[O2].[DealerID] = [D2].[ID]
			WHERE
				--([P2].[CompanyID] = 1)
				--AND 
				--(
					([P2].[Model No] = 'Frameless End Dump 2X')
					OR
					([P2].[Model No] = 'Frameless End Dump 3X')
					OR
					([O2].[WO#] = 10001577)
				--)
				--AND 
				--([P2].[Class] = 'End Dumps')
				--AND 
				--([O2].[WO#] IS NOT NULL)
			GROUP BY
				CAST([O2].[WO#] AS NVARCHAR(MAX))
				,[O2].[Quote Date]
				,[O2].[Delivery Date]
				,[O2].[US Sale]
				,[O2].[SGQuote]
				,[O2].[Model No]
				,[D2].[COMPANY NAME]
				,[O2].[Price]
				,[P2].[Price]
		) AS [WL]
		LEFT JOIN
			[SysproCompanyS].[dbo].[v_WorkOrderStatus] [JP]
		ON
			[WL].[WO#] = [JP].[Job]
		LEFT JOIN (
			SELECT
				[Job]
				,ISNULL(SUM([ValueIssued]), 0) AS [SumOfLabourAct]
				,ISNULL(SUM([Lab].[UnitValueReqd]), 0) AS [SumOfLabourBud]
			FROM
				[SysproCompanyS].[dbo].[WipJobAllLab] [Lab]
			GROUP BY
				[Job]
		) AS [Lab]
		ON
			[Lab].[Job] = [JP].[Job]
		LEFT JOIN
			[BWSdb].[dbo].[v_SAL_OrdersPricingV2] [OP2]
		ON
			[WL].[SGQuote] = [OP2].[SGQuote]
		/*
			AND ([Lab].[Operation] = [JP].[OperationOffset])
		LEFT JOIN
			[SysproCompanyS].[dbo].[BomMachine] [BM]
		ON
			[Lab].[IMachine] = [BM].[Machine]
		*/
		GROUP BY
			[WL].[WO#]
			,[WL].[Quote Date]
			,[WL].[Delivery Date]
			,[WL].[US Sale]
			,[WL].[SGQuote]
			,[WL].[Model No]
			,[Wl].[Dealer]
			,[WL].[OrderPrice]
			,[WL].[ProductPrice]
			--,[Jp].[PartCategory]
			,[Lab].[SumOfLabourAct]
			,[Lab].[SumOfLabourBud]
			,[OP2].[NetCost]
	) AS [Step1]
) AS [Step2]
ORDER BY
	[WO#]
	--,[Jp].[PartCategory]
;