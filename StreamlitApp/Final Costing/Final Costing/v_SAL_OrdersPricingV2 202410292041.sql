USE [BWSdb]
GO

/****** Object:  View [dbo].[v_SAL_OrdersPricing]    Script Date: 2024-10-29 5:16:30 PM ******/

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





-- 2024-10-22 2100 - Avery Briggs - View of all Stargate WOs with the steps for quote cost calculations broken down. [NetCost] will be the total on the quote. Works for both US and CDN sales.
-- 2024-10-23 1329 - Avery Briggs - Added considerations for US pricing to be converted to CDN
-- 2024-10-24 1208 - Avery Briggs - Copied all functionality from [BWSdb].[dbo].[v_SAL_OrdersPricingV2] to this new view.
-- 2024-10-25 1822 - Avery Briggs - Modified discount applications to ensure that the exchange rate is applied to fixed discounts
-- 2024-10-29 1731 - Avery Briggs - Added consideration for [Volume Discount] in [D2] and [Program Discount] in [D3]


ALTER VIEW [dbo].[v_SAL_OrdersPricingV2]
AS


SELECT
	[SGQuote]
	,[WO#]
	,[US Sale]
	,[ExchangeRate]
	,[BasePrice]
	,[SumOfOptionPrice]
	,[SumOfNPOPrice]
	,[SumOfNPOPriceUS]
	,[Discount1]
	,[Discount1_Name]
	,[Discount1_Type]
	,[Discount2]
	,[Discount2_Name]
	,[Discount2_Type]
	,[Discount3]
	,[Discount3_Name]
	,[Discount3_Type]
	,[Volume Discount]
	,[Program Discount]
	,[GrossPrice]
	,[GrossPriceCDN]
	,[D1]
	,[D1CDN]
	,[D1SubTtl]
	,[D1SubTtlCDN]
	,[D2]
	,[D2CDN]
	,[D2SubTtl]
	,[D2SubTtlCDN]
	,[D3]
	,[D3CDN]
	,[D2SubTtl] + [D3] AS [D3SubTtl]
	,[D2SubTtlCDN] + [D3CDN] AS [D3SubTtlCDN]
	,[D2SubTtl] + [D3] AS [NetCost]
	,[D2SubTtlCDN] + [D3CDN] AS [NetCostCDN]
FROM (
	SELECT
		[SGQuote]
		,[WO#]
		,[US Sale]
		,[ExchangeRate]
		,[BasePrice]
		,[SumOfOptionPrice]
		,[SumOfNPOPrice]
		,[SumOfNPOPriceUS]
		,[Discount1]
		,[Discount1_Name]
		,[Discount1_Type]
		,[Discount2]
		,[Discount2_Name]
		,[Discount2_Type]
		,[Discount3]
		,[Discount3_Name]
		,[Discount3_Type]
		,[Volume Discount]
		,[Program Discount]
		,[GrossPrice]
		,[GrossPriceCDN]
		,[D1]
		,[D1CDN]
		,[D1SubTtl]
		,[D1SubTtlCDN]
		,[D2]
		,[D2CDN]
		,[D2SubTtl]
		,[D2SubTtlCDN]
		,(CASE 
			WHEN [Discount3] <> 0 THEN (
				CASE 
					WHEN [Discount3_Type] = 'Fixed' THEN
						[Discount3] 
					ELSE (
						CASE
							WHEN [Discount3_Type] = 'Percent' THEN
								[D2SubTtl] * [Discount3] * -1 
							ELSE 
								0 
						END
					)
				END
			) 
		ELSE (-1 * [D2SubTtl] * [Program Discount]) END) AS [D3]
		,(CASE 
			WHEN [Discount3] <> 0 THEN (
				CASE 
					WHEN [Discount3_Type] = 'Fixed' THEN
						[ExchangeRate] * [Discount3] 
					ELSE (
						CASE
							WHEN [Discount3_Type] = 'Percent' THEN
								[D2SubTtlCDN] * [Discount3] * -1 
							ELSE 
								0 
						END
					)
				END
			) 
		ELSE 
			(-1 * [D2SubTtlCDN] * [Program Discount])
		END) AS [D3CDN]
		--,(CASE WHEN [Discount3_Type] = 'Fixed' THEN [Discount3] ELSE (CASE WHEN [Discount3_Type] = 'Percent' THEN [D2SubTtl] * [Discount3] * -1 ELSE 0 END) END) AS [D3]
		--,(CASE WHEN [Discount3_Type] = 'Fixed' THEN [ExchangeRate] * [Discount3] ELSE (CASE WHEN [Discount3_Type] = 'Percent' THEN [D2SubTtlCDN] * [Discount3] * -1 ELSE 0 END) END) AS [D3CDN]
	FROM (
		SELECT
			[SGQuote]
			,[WO#]
			,[US Sale]
			,[ExchangeRate]
			,[BasePrice]
			,[SumOfOptionPrice]
			,[SumOfNPOPrice]
			,[SumOfNPOPriceUS]
			,[Discount1]
			,[Discount1_Name]
			,[Discount1_Type]
			,[Discount2]
			,[Discount2_Name]
			,[Discount2_Type]
			,[Discount3]
			,[Discount3_Name]
			,[Discount3_Type]
			,[Volume Discount]
			,[Program Discount]
			,[GrossPrice]
			,[GrossPriceCDN]
			,[D1]
			,[D1CDN]
			,[D1SubTtl]
			,[D1SubTtlCDN]
			,[D2]
			,[D2CDN]
			,[D1SubTtl] + [D2] AS [D2SubTtl]
			,[D1SubTtlCDN] + [D2CDN] AS [D2SubTtlCDN]
		FROM (
			SELECT
				[SGQuote]
				,[WO#]
				,[US Sale]
				,[ExchangeRate]
				,[BasePrice]
				,[SumOfOptionPrice]
				,[SumOfNPOPrice]
				,[SumOfNPOPriceUS]
				,[Discount1]
				,[Discount1_Name]
				,[Discount1_Type]
				,[Discount2]
				,[Discount2_Name]
				,[Discount2_Type]
				,[Discount3]
				,[Discount3_Name]
				,[Discount3_Type]
				,[Volume Discount]
				,[Program Discount]
				,[GrossPrice]
				,[GrossPriceCDN]
				,[D1]
				,[D1CDN]
				,[D1SubTtl]
				,[D1SubTtlCDN]
				,(CASE 
					WHEN [Discount2] <> 0 THEN (
						CASE 
							WHEN [Discount2_Type] = 'Fixed' THEN
								[Discount2] 
							ELSE (
								CASE
									WHEN [Discount2_Type] = 'Percent' THEN
										[D1SubTtl] * [Discount2] * -1 
									ELSE 
										0 
								END
							)
						END
					) 
				ELSE (-1 * [D1SubTtl] * [Volume Discount]) END) AS [D2]
				,(CASE 
					WHEN [Discount2] <> 0 THEN (
						CASE 
							WHEN [Discount2_Type] = 'Fixed' THEN
								[ExchangeRate] * [Discount2] 
							ELSE (
								CASE
									WHEN [Discount2_Type] = 'Percent' THEN
										[D1SubTtlCDN] * [Discount2] * -1 
									ELSE 
										0 
								END
							)
						END
					) 
				ELSE 
					(-1 * [D1SubTtlCDN] * [Volume Discount])
				END) AS [D2CDN]
				--,(1 - [Volume Discount]) * (CASE WHEN [Discount2_Type] = 'Fixed' THEN [ExchangeRate] * [Discount2] ELSE (CASE WHEN [Discount2_Type] = 'Percent' THEN [D1SubTtlCDN] * [Discount2] * -1 ELSE 0 END) END) AS [D2CDN]
				--,(CASE WHEN [Volume Discoun] = 'Fixed' THEN [Discount2] ELSE (CASE WHEN [Discount2_Type] = 'Percent' THEN [D1SubTtl] * [Discount2] * -1 ELSE 0 END) END) AS [D2]
				--,(CASE WHEN [Discount2_Type] = 'Fixed' THEN [ExchangeRate] * [Discount2] ELSE (CASE WHEN [Discount2_Type] = 'Percent' THEN [D1SubTtlCDN] * [Discount2] * -1 ELSE 0 END) END) AS [D2CDN]
			FROM (
				SELECT
					[SGQuote]
					,[WO#]
					,[US Sale]
					,[ExchangeRate]
					,[BasePrice]
					,[SumOfOptionPrice]
					,[SumOfNPOPrice]
					,[SumOfNPOPriceUS]
					,[Discount1]
					,[Discount1_Name]
					,[Discount1_Type]
					,[Discount2]
					,[Discount2_Name]
					,[Discount2_Type]
					,[Discount3]
					,[Discount3_Name]
					,[Discount3_Type]
					,[Volume Discount]
					,[Program Discount]
					,[GrossPrice]
					,[GrossPriceCDN]
					,[D1]
					,[D1CDN]
					,[GrossPrice] + [D1] AS [D1SubTtl]
					,[GrossPriceCDN] + [D1CDN] AS [D1SubTtlCDN]
				FROM (
					SELECT
						[SGQuote]
						,[WO#]
						,[US Sale]
						,[ExchangeRate]
						,[BasePrice]
						,[SumOfOptionPrice]
						,[SumOfNPOPrice]
						,[SumOfNPOPriceUS]
						,[Discount1]
						,[Discount1_Name]
						,[Discount1_Type]
						,[Discount2]
						,[Discount2_Name]
						,[Discount2_Type]
						,[Discount3]
						,[Discount3_Name]
						,[Discount3_Type]
						,[Volume Discount]
						,[Program Discount]
						,[GrossPrice]
						,[GrossPriceCDN]
						,(CASE WHEN [Discount1_Type] = 'Fixed' THEN [Discount1] ELSE (CASE WHEN [Discount1_Type] = 'Percent' THEN [GrossPrice] * [Discount1] * -1 ELSE 0 END) END) AS [D1]
						,(CASE WHEN [Discount1_Type] = 'Fixed' THEN [ExchangeRate] * [Discount1] ELSE (CASE WHEN [Discount1_Type] = 'Percent' THEN [GrossPriceCDN] * [Discount1] * -1 ELSE 0 END) END) AS [D1CDN]
					FROM (
						SELECT
							[O2].[SGQuote]
							,[O2].[WO#]
							,[O2].[US Sale]
							,[SM].[ExchangeRate]
							,[O2].[Price] AS [BasePrice]
							,SUM([OO2].[Price]) AS [SumOfOptionPrice]
							,SUM([CW2].[Price]) AS [SumOfNPOPrice]
							,SUM([CW2].[US Price]) AS [SumOfNPOPriceUS]
							,ISNULL([O2].[Discount1], 0) AS [Discount1]
							,[O2].[Discount1_Name]
							,[O2].[Discount1_Type]
							,ISNULL([O2].[Discount2], 0) AS [Discount2]
							,[O2].[Discount2_Name]
							,[O2].[Discount2_Type]
							,ISNULL([O2].[Discount3], 0) AS [Discount3]
							,[O2].[Discount3_Name]
							,[O2].[Discount3_Type]
							,ISNULL([O2].[Volume Discount], 0) AS [Volume Discount]
							,ISNULL([O2].[Program Discount], 0) AS [Program Discount]
							,[O2].[Price] + [OO2].[Price] + (CASE WHEN [O2].[US Sale] = 1 THEN [CW2].[US Price] ELSE [CW2].[Price] END) AS [GrossPrice]
							,[SM].[ExchangeRate] * ([O2].[Price] + [OO2].[Price] + (CASE WHEN [O2].[US Sale] = 1 THEN [CW2].[US Price] ELSE [CW2].[Price] END)) AS [GrossPriceCDN]
						FROM
							[BWSdb].[dbo].[OrdersV2] [O2]
						/*INNER JOIN
							[BWSdb].[dbo].[Products] [P]
						ON
							[O2].[ProductID] = [P].[IDTrailer]*/
						INNER JOIN
							[SysproCompanyA].[dbo].[SorMaster] [SM]
						ON
							[O2].[Sales Order#] = [SM].[SalesOrder]
						INNER JOIN (
							SELECT
								[Order OptionsV2].[SGQuote]
								,[Order OptionsV2].[WO#]
								,SUM([Order OptionsV2].[Qty] * [Order OptionsV2].[Price]) AS [Price]
							FROM
								[BWSdb].[dbo].[Order OptionsV2]
							GROUP BY
								[Order OptionsV2].[SGQuote]
								,[Order OptionsV2].[WO#]
						) AS [OO2]
						ON
							[O2].[SGQuote] = [OO2].[SGQuote]
						INNER JOIN(
							SELECT
								[Custom WorkV2].[SGQuote]
								,[Custom WorkV2].[WO#]
								,SUM(CASE WHEN [OrdersV2].[US Sale] = 1 THEN 0 ELSE [Custom WorkV2].[Price] END) AS [Price]
								,SUM(CASE WHEN [OrdersV2].[US Sale] = 1 THEN [Custom WorkV2].[US Price] ELSE 0 END) AS [US Price]
							FROM
								[BWSdb].[dbo].[Custom WorkV2]
							INNER JOIN
								[BWSdb].[dbo].[OrdersV2]
							ON
								[Custom WorkV2].[SGQuote] = [OrdersV2].[SGQuote]
							GROUP BY
								[Custom WorkV2].[SGQuote]
								,[Custom WorkV2].[WO#]
						) AS [CW2]
						ON
							[O2].[SGQuote] = [CW2].[SGQuote]
						GROUP BY
							[O2].[SGQuote]
							,[O2].[WO#]
							,[O2].[US Sale]
							,[O2].[Price]
							,[O2].[US Sale]
							,[OO2].[Price]
							,[CW2].[Price]
							,[CW2].[US Price]
							,[O2].[Discount1]
							,[O2].[Discount1_Name]
							,[O2].[Discount1_Type]
							,[O2].[Discount2]
							,[O2].[Discount2_Name]
							,[O2].[Discount2_Type]
							,[O2].[Discount3]
							,[O2].[Discount3_Name]
							,[O2].[Discount3_Type]
							,[O2].[Volume Discount]
							,[O2].[Program Discount]
							,[SM].[ExchangeRate]
					) AS [BaseOptNPO]
				) AS [Step1]
			) AS [Step2]
		) AS [Step3]
	) AS [Step4]
) AS [Step5]
/*
WHERE
	[SGQuote] = 20974
*/
/*
SELECT
	[SGQuote]
	,[WO#]
	,[US Sale]
	,[ExchangeRate]
	,[BasePrice]
	,[SumOfOptionPrice]
	,[SumOfNPOPrice]
	,[SumOfNPOPriceUS]
	,[Discount1]
	,[Discount1_Name]
	,[Discount1_Type]
	,[Discount2]
	,[Discount2_Name]
	,[Discount2_Type]
	,[Discount3]
	,[Discount3_Name]
	,[Discount3_Type]
	,[Volume Discount]
	,[Program Discount]
	,[Total]
	,[TotalCDN]
	,[D3]
	,[VolDis]
	,[VolDisCDN]
	,[D3SubTtl]
	,[D3SubTtlCDN]
	,[SubTtl]
	,[SubTtlCDN]
	,[ProDis]
	,[ProDisCDN]
	,[PDSubTtl]
	,[PDSubTtlCDN]
	,[D1]
	,[D1CDN]
	,[PDSubTtl] + [D1] AS [NetCost]
	,[PDSubTtlCDN] + [D1CDN] AS [NetCostCDN]
FROM (
	SELECT
		[SGQuote]
		,[WO#]
		,[US Sale]
		,[ExchangeRate]
		,[BasePrice]
		,[SumOfOptionPrice]
		,[SumOfNPOPrice]
		,[SumOfNPOPriceUS]
		,[Discount1]
		,[Discount1_Name]
		,[Discount1_Type]
		,[Discount2]
		,[Discount2_Name]
		,[Discount2_Type]
		,[Discount3]
		,[Discount3_Name]
		,[Discount3_Type]
		,[Volume Discount]
		,[Program Discount]
		,[Total]
		,[TotalCDN]
		,[D3]
		,[VolDis]
		,[VolDisCDN]
		,[D3SubTtl]
		,[D3SubTtlCDN]
		,[SubTtl]
		,[SubTtlCDN]
		,[ProDis]
		,[ProDisCDN]
		,[PDSubTtl]
		,[PDSubTtlCDN]
		,(CASE WHEN [Discount1_Type] = 'Fixed' THEN [Discount1] ELSE (CASE WHEN [Discount1_Type] = 'Percent' THEN ([SubTtl] + [ProDis]) * ([Discount1] * -1) ELSE 0 END) END) AS [D1]
		,(CASE WHEN [Discount1_Type] = 'Fixed' THEN [Discount1] ELSE (CASE WHEN [Discount1_Type] = 'Percent' THEN ([SubTtlCDN] + [ProDisCDN]) * ([Discount1] * -1) ELSE 0 END) END) AS [D1CDN]
	FROM (
		SELECT
			[SGQuote]
			,[WO#]
			,[US Sale]
			,[ExchangeRate]
			,[BasePrice]
			,[SumOfOptionPrice]
			,[SumOfNPOPrice]
			,[SumOfNPOPriceUS]
			,[Discount1]
			,[Discount1_Name]
			,[Discount1_Type]
			,[Discount2]
			,[Discount2_Name]
			,[Discount2_Type]
			,[Discount3]
			,[Discount3_Name]
			,[Discount3_Type]
			,[Volume Discount]
			,[Program Discount]
			,[Total]
			,[TotalCDN]
			,[D3]
			,[VolDis]
			,[VolDisCDN]
			,[D3SubTtl]
			,[D3SubTtlCDN]
			,[SubTtl]
			,[SubTtlCDN]
			,[ProDis]
			,[ProDisCDN]
			,[SubTtl] + [ProDis] AS [PDSubTtl]
			,[SubTtlCDN] + [ProDisCDN] AS [PDSubTtlCDN]
		FROM (
			SELECT
				[SGQuote]
				,[WO#]
				,[US Sale]
				,[ExchangeRate]
				,[BasePrice]
				,[SumOfOptionPrice]
				,[SumOfNPOPrice]
				,[SumOfNPOPriceUS]
				,[Discount1]
				,[Discount1_Name]
				,[Discount1_Type]
				,[Discount2]
				,[Discount2_Name]
				,[Discount2_Type]
				,[Discount3]
				,[Discount3_Name]
				,[Discount3_Type]
				,[Volume Discount]
				,[Program Discount]
				,[Total]
				,[TotalCDN]
				,[D3]
				,[VolDis]
				,[VolDisCDN]
				,[D3SubTtl]
				,[D3SubTtlCDN]
				,[SubTtl]
				,[SubTtlCDN]
				,[SubTtl] * ([Program Discount] * -1) AS [ProDis]
				,[SubTtlCDN] * ([Program Discount] * -1) AS [ProDisCDN]
			FROM (
				SELECT
					[SGQuote]
					,[WO#]
					,[US Sale]
					,[ExchangeRate]
					,[BasePrice]
					,[SumOfOptionPrice]
					,[SumOfNPOPrice]
					,[SumOfNPOPriceUS]
					,[Discount1]
					,[Discount1_Name]
					,[Discount1_Type]
					,[Discount2]
					,[Discount2_Name]
					,[Discount2_Type]
					,[Discount3]
					,[Discount3_Name]
					,[Discount3_Type]
					,[Volume Discount]
					,[Program Discount]
					,[Total]
					,[TotalCDN]
					,[D3]
					,[VolDis]
					,[VolDisCDN]
					,[D3SubTtl]
					,[D3SubTtlCDN]
					,[D3SubTtl] + [VolDis] AS [SubTtl]
					,[D3SubTtlCDN] + [VolDisCDN] AS [SubTtlCDN]
				FROM (
					SELECT
						[SGQuote]
						,[WO#]
						,[US Sale]
						,[ExchangeRate]
						,[BasePrice]
						,[SumOfOptionPrice]
						,[SumOfNPOPrice]
						,[SumOfNPOPriceUS]
						,[Discount1]
						,[Discount1_Name]
						,[Discount1_Type]
						,[Discount2]
						,[Discount2_Name]
						,[Discount2_Type]
						,[Discount3]
						,[Discount3_Name]
						,[Discount3_Type]
						,[Volume Discount]
						,[Program Discount]
						,[Total]
						,[TotalCDN]
						,[D3]
						,(CASE WHEN [D3] IS NULL THEN [Total] ELSE [Total] + [D3] END) * ([Volume Discount] * -1) AS [VolDis]
						,[Total] + [D3] AS [D3SubTtl]
						,(CASE WHEN [D3] IS NULL THEN [TotalCDN] ELSE [TotalCDN] + [D3] END) * ([Volume Discount] * -1) AS [VolDisCDN]
						,[TotalCDN] + ([D3] * [ExchangeRate]) AS [D3SubTtlCDN]
					FROM (
						SELECT
							[SGQuote]
							,[WO#]
							,[US Sale]
							,[ExchangeRate]
							,[BasePrice]
							,[SumOfOptionPrice]
							,[SumOfNPOPrice]
							,[SumOfNPOPriceUS]
							,[Discount1]
							,[Discount1_Name]
							,[Discount1_Type]
							,[Discount2]
							,[Discount2_Name]
							,[Discount2_Type]
							,[Discount3]
							,[Discount3_Name]
							,[Discount3_Type]
							,[Volume Discount]
							,[Program Discount]
							,[Total]
							,[TotalCDN]
							,(CASE WHEN [Discount3_Type] = 'Fixed' THEN [Discount3] ELSE (CASE WHEN [Discount3_Type] = 'Percent' THEN [Total] * [Discount3] * -1 ELSE 0 END) END) AS [D3]
						FROM (
							SELECT
								[O2].[SGQuote]
								,[O2].[WO#]
								,[O2].[US Sale]
								,[SM].[ExchangeRate]
								,[O2].[Price] AS [BasePrice]
								,SUM([OO2].[Price]) AS [SumOfOptionPrice]
								,SUM([CW2].[Price]) AS [SumOfNPOPrice]
								,SUM([CW2].[US Price]) AS [SumOfNPOPriceUS]
								,ISNULL([O2].[Discount1], 0) AS [Discount1]
								,[O2].[Discount1_Name]
								,[O2].[Discount1_Type]
								,ISNULL([O2].[Discount2], 0) AS [Discount2]
								,[O2].[Discount2_Name]
								,[O2].[Discount2_Type]
								,ISNULL([O2].[Discount3], 0) AS [Discount3]
								,[O2].[Discount3_Name]
								,[O2].[Discount3_Type]
								,ISNULL([O2].[Volume Discount], 0) AS [Volume Discount]
								,ISNULL([O2].[Program Discount], 0) AS [Program Discount]
								,[O2].[Price] + [OO2].[Price] + (CASE WHEN [O2].[US Sale] = 1 THEN [CW2].[US Price] ELSE [CW2].[Price] END) AS [Total]
								,[SM].[ExchangeRate] * ([O2].[Price] + [OO2].[Price] + (CASE WHEN [O2].[US Sale] = 1 THEN [CW2].[US Price] ELSE [CW2].[Price] END)) AS [TotalCDN]
							FROM
								[BWSdb].[dbo].[OrdersV2] [O2]
							INNER JOIN
								[BWSdb].[dbo].[Products] [P]
							ON
								[O2].[ProductID] = [P].[IDTrailer]
							INNER JOIN
								[SysproCompanyA].[dbo].[SorMaster] [SM]
							ON
								[O2].[Sales Order#] = [SM].[SalesOrder]
							INNER JOIN (
								SELECT
									[Order OptionsV2].[SGQuote]
									,[Order OptionsV2].[WO#]
									,SUM([Order OptionsV2].[Qty] * [Order OptionsV2].[Price]) AS [Price]
								FROM
									[BWSdb].[dbo].[Order OptionsV2]
								GROUP BY
									[Order OptionsV2].[SGQuote]
									,[Order OptionsV2].[WO#]
							) AS [OO2]
							ON
								[O2].[SGQuote] = [OO2].[SGQuote]
							INNER JOIN(
								SELECT
									[Custom WorkV2].[SGQuote]
									,[Custom WorkV2].[WO#]
									,SUM(CASE WHEN [OrdersV2].[US Sale] = 1 THEN 0 ELSE [Custom WorkV2].[Price] END) AS [Price]
									,SUM(CASE WHEN [OrdersV2].[US Sale] = 1 THEN [Custom WorkV2].[US Price] ELSE 0 END) AS [US Price]
								FROM
									[BWSdb].[dbo].[Custom WorkV2]
								INNER JOIN
									[BWSdb].[dbo].[OrdersV2]
								ON
									[Custom WorkV2].[SGQuote] = [OrdersV2].[SGQuote]
								GROUP BY
									[Custom WorkV2].[SGQuote]
									,[Custom WorkV2].[WO#]
							) AS [CW2]
							ON
								[O2].[SGQuote] = [CW2].[SGQuote]
							GROUP BY
								[O2].[SGQuote]
								,[O2].[WO#]
								,[O2].[US Sale]
								,[O2].[Price]
								,[O2].[US Sale]
								,[OO2].[Price]
								,[CW2].[Price]
								,[CW2].[US Price]
								,[O2].[Discount1]
								,[O2].[Discount1_Name]
								,[O2].[Discount1_Type]
								,[O2].[Discount2]
								,[O2].[Discount2_Name]
								,[O2].[Discount2_Type]
								,[O2].[Discount3]
								,[O2].[Discount3_Name]
								,[O2].[Discount3_Type]
								,[O2].[Volume Discount]
								,[O2].[Program Discount]
								,[SM].[ExchangeRate]
						) AS [BaseOptNPO]
					) AS [Step1]
				) AS [Step2]
			) AS [Step3]
		) AS [Step4]
	) AS [Step5]
) AS [Step6]
WHERE
	([WO#] IN (
		10013852
		--,10015640
	))
;

SELECT
	*
FROM
	[BWSdb].[dbo].[OrdersV2]
WHERE
	[SGQuote] = 23526

SELECT
	*
FROM
	[SysproCompanyA].[dbo].[SorMaster] [SM]
INNER JOIN
	[BWSdb].[dbo].[OrdersV2] [O2]
ON
	[O2].[Sales Order#] = [SM].[SalesOrder]
WHERE
	[SGQuote] = 23526
	
SELECT
	*
FROM
	[BWSdb].[dbo].[Order OptionsV2]
WHERE
	[SGQuote] = 23526

SELECT
	*
FROM
	[BWSdb].[dbo].[Custom WorkV2]
WHERE
	[SGQuote] = 23526

SELECT
	SUM([Qty]*[Price]) AS [SumPrice_OO]
FROM
	[BWSdb].[dbo].[Order OptionsV2]
WHERE
	[SGQuote] = 23526

SELECT
	SUM([Price]) AS [SumPrice_CW]
FROM
	[BWSdb].[dbo].[Custom WorkV2]
WHERE
	[SGQuote] = 23526

SELECT
	SUM([US Price]) AS [SumPriceUS_CW]
FROM
	[BWSdb].[dbo].[Custom WorkV2]
WHERE
	[SGQuote] = 23526
*/

GO


