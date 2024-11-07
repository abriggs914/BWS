USE [BWSdb]
GO


-- 2024-11-06 1546 - Avery Briggs - Initial.
-- 2024-11-06 1907 - Avery Briggs - Speed boost by moving some tables to single access at the end.
-- 2024-11-06 1937 - Avery Briggs - Stargate Version

CREATE VIEW [v_SAL_OrdersMarginV2]

AS

	SELECT
		[Step3].[Quote Date]
		,[Step3].[Delivery Date]
		,[Step3].[WO#]
		,[Step3].[SGQuote]
		,[Step3].[Model No]
		,[Step3].[Dealer]
		,[Step3].[US Sale]
		,[Step3].[OrderBasePrice]
		,[Step3].[Sales Order#]
		,[Step3].[SumOfValueIssued_MadeIn]
		,[Step3].[SumOfValueIssued_BoughtOut]
		,[Step3].[SumOfValueIssued_SubContract]
		,[Step3].[SumOfLabourAct]
		,[Step3].[SumOfLabourBud]
		,[Step3].[SumOfLabourOverUnder]
		,[Step3].[TotalCostSoFar]
		,[Step3].[SalePrice]
		,[Step3].[SalePriceCDN]
		,[Step3].[ProductID]
		,[Step3].[SalePriceCDN] - [Step3].[TotalCostSoFar] AS [MarginCDN$]
		--,(CASE WHEN [Step3].[TotalCostSoFar] = 0 THEN 0 ELSE [Step3].[SalePriceCDN] / [Step3].[TotalCostSoFar] END) AS [RatioSaleToCostCDN]
		--,(CASE WHEN [Step3].[TotalCostSoFar] = 0 THEN 0 ELSE (([Step3].[SalePriceCDN] / [Step3].[TotalCostSoFar]) - 1) END) AS [MarginCDN%]
		,([Step3].[SalePriceCDN] - [Step3].[TotalCostSoFar]) / (CASE WHEN [Step3].[SalePriceCDN] = 0 THEN 1 ELSE [Step3].[SalePriceCDN] END) AS [RatioSaleToCostCDN]
		,(([Step3].[SalePriceCDN] - [Step3].[TotalCostSoFar]) / (CASE WHEN [Step3].[SalePriceCDN] = 0 THEN 1 ELSE [Step3].[SalePriceCDN] END) - 1) AS [MarginCDN%]
		,[Step3].[D1]
		,[Step3].[D2]
		,[Step3].[D3]
		,[Step3].[D1CDN]
		,[Step3].[D2CDN]
		,[Step3].[D3CDN]
		,[Step3].[D1SubTtl]
		,[Step3].[D2SubTtl]
		,[Step3].[D3SubTtl]
		,[Step3].[D1SubTtlCDN]
		,[Step3].[D2SubTtlCDN]
		,[Step3].[D3SubTtlCDN]
		,[Step3].[Discount1]
		,[Step3].[Discount2]
		,[Step3].[Discount3]
		,[Step3].[Discount1_Type]
		,[Step3].[Discount2_Type]
		,[Step3].[Discount3_Type]
		,(CASE WHEN [WM].[ActCompleteDate] IS NULL THEN 0 ELSE 1 END) AS [Completed]
		,[WM].[ActCompleteDate]
		,[WM].[JobStartDate]
		,[P2].[Price] AS [ProductBasePrice]
		,[P2].[US Price] AS [ProductBasePriceUS]
	FROM (
		SELECT
			[Step2].[Quote Date]
			,[Step2].[Delivery Date]
			,[Step2].[WO#]
			,[Step2].[SGQuote]
			,[Step2].[Model No]
			,[Step2].[Dealer]
			,[Step2].[US Sale]
			,[Step2].[OrderBasePrice]
			,[Step2].[Sales Order#]
			,[Step2].[ProductID]
			,[Step2].[SumOfValueIssued_MadeIn]
			,[Step2].[SumOfValueIssued_BoughtOut]
			,[Step2].[SumOfValueIssued_SubContract]
			,[Step2].[SumOfLabourAct]
			,[Step2].[SumOfLabourBud]
			,[Step2].[SumOfLabourOverUnder]
			,[Step2].[TotalCostSoFar]
			,ISNULL([OP2].[NetCost], 0) AS [SalePrice]
			,ISNULL([OP2].[NetCostCDN], 0) AS [SalePriceCDN]
			,[OP2].[D1]
			,[OP2].[D2]
			,[OP2].[D3]
			,[OP2].[D1CDN]
			,[OP2].[D2CDN]
			,[OP2].[D3CDN]
			,[OP2].[D1SubTtl]
			,[OP2].[D2SubTtl]
			,[OP2].[D3SubTtl]
			,[OP2].[D1SubTtlCDN]
			,[OP2].[D2SubTtlCDN]
			,[OP2].[D3SubTtlCDN]
			,[OP2].[Discount1]
			,[OP2].[Discount2]
			,[OP2].[Discount3]
			,[OP2].[Discount1_Type]
			,[OP2].[Discount2_Type]
			,[OP2].[Discount3_Type]
		FROM (
			SELECT
				[Step1].[Quote Date]
				,[Step1].[Delivery Date]
				,[Step1].[WO#]
				,[Step1].[SGQuote]
				,[Step1].[Model No]
				,[Step1].[Dealer]
				,[Step1].[US Sale]
				,[Step1].[OrderBasePrice]
				,[Step1].[Sales Order#]
				,[Step1].[ProductID]
				,[Step1].[SumOfValueIssued_MadeIn]
				,[Step1].[SumOfValueIssued_BoughtOut]
				,[Step1].[SumOfValueIssued_SubContract]
				,[Step1].[SumOfLabourAct]
				,[Step1].[SumOfLabourBud]
				,[Step1].[SumOfLabourOverUnder]
				,[Step1].[SumOfValueIssued_MadeIn] + [Step1].[SumOfValueIssued_BoughtOut] + [Step1].[SumOfValueIssued_SubContract] + [Step1].[SumOfLabourAct] AS [TotalCostSoFar]
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
					,[WL].[Sales Order#]
					,[WL].[ProductID]
					,SUM(CASE WHEN [JP].[PartCategory] = 'M' THEN [JP].[ValueIssued] ELSE 0 END) AS [SumOfValueIssued_MadeIn]
					,SUM(CASE WHEN [JP].[PartCategory] = 'B' THEN [JP].[ValueIssued] ELSE 0 END) AS [SumOfValueIssued_BoughtOut]
					,SUM(CASE WHEN [JP].[PartCategory] = 'G' THEN [JP].[ValueIssued] ELSE 0 END) AS [SumOfValueIssued_SubContract]
					,ISNULL([Lab].[SumOfLabourAct], 0) AS [SumOfLabourAct]
					,ISNULL([Lab].[SumOfLabourBud], 0) AS [SumOfLabourBud]
					,ISNULL([Lab].[SumOfLabourBud], 0) - ISNULL([Lab].[SumOfLabourAct], 0) AS [SumOfLabourOverUnder]
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
						,[O2].[Sales Order#]
						,[O2].[ProductID]
					FROM
						[BWSdb].[dbo].[OrdersV2] [O2] WITH (NOLOCK)
					LEFT JOIN
						[BWSdb].[dbo].[DealersV2] [D2] WITH (NOLOCK)
					ON
						[O2].[DealerID] = [D2].[ID]
					GROUP BY
						CAST([O2].[WO#] AS NVARCHAR(MAX))
						,[O2].[Quote Date]
						,[O2].[Delivery Date]
						,[O2].[US Sale]
						,[O2].[SGQuote]
						,[O2].[Model No]
						,[D2].[COMPANY NAME]
						,[O2].[Price]
						,[O2].[Sales Order#]
						,[O2].[ProductID]
				) AS [WL]
				LEFT JOIN
					[SysproCompanyS].[dbo].[v_WorkOrderStatus] [JP] WITH (NOLOCK)
				ON
					[WL].[WO#] = [JP].[Job]
				LEFT JOIN (
					SELECT
						[Job]
						,ISNULL(SUM([ValueIssued]), 0) AS [SumOfLabourAct]
						,ISNULL(SUM([Lab].[UnitValueReqd]), 0) AS [SumOfLabourBud]
					FROM
						[SysproCompanyS].[dbo].[WipJobAllLab] [Lab] WITH (NOLOCK)
					GROUP BY
						[Job]
				) AS [Lab]
				ON
					[Lab].[Job] = [JP].[Job]
				GROUP BY
					[WL].[WO#]
					,[WL].[Quote Date]
					,[WL].[Delivery Date]
					,[WL].[US Sale]
					,[WL].[SGQuote]
					,[WL].[Model No]
					,[Wl].[Dealer]
					,[WL].[OrderPrice]
					,[WL].[ProductID]
					,[WL].[Sales Order#]
					,[Lab].[SumOfLabourAct]
					,[Lab].[SumOfLabourBud]
			) AS [Step1]
		) AS [Step2]
		INNER JOIN
			[BWSdb].[dbo].[v_SAL_OrdersPricingV2] [OP2] WITH (NOLOCK)
		ON
			([Step2].[SGQuote] = [OP2].[SGQuote])
			AND (CAST([Step2].[WO#] AS INT) = [OP2].[WO#])
	) AS [Step3]
	LEFT JOIN
		[SysproCompanyS].[dbo].[SorMaster] [SM] WITH (NOLOCK)
	ON
		CAST([Step3].[Sales Order#] AS NVARCHAR(MAX)) = [SM].[SalesOrder]
	LEFT JOIN
		[SysproCompanyS].[dbo].[WipMaster] [WM] WITH (NOLOCK)
	ON
		CAST([Step3].[WO#] AS NVARCHAR(MAX)) = [WM].[Job]
	LEFT JOIN
		[BWSdb].[dbo].[ProductsV2] [P2] WITH (NOLOCK)
	ON
		[Step3].[ProductID] = [P2].[IDTrailer]
	/*
	ORDER BY
		[Step3].[Quote#] DESC
	*/
	;
