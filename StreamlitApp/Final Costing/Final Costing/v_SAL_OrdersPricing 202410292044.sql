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


ALTER VIEW [dbo].[v_SAL_OrdersPricing]
AS


SELECT
	[Quote#]
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
		[Quote#]
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
			[Quote#]
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
				[Quote#]
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
					[Quote#]
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
						[Quote#]
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
							[O].[Quote#]
							,[O].[WO#]
							,[O].[US Sale]
							,[SM].[ExchangeRate]
							,[O].[Price] AS [BasePrice]
							,SUM([OO].[Price]) AS [SumOfOptionPrice]
							,SUM([CW].[Price]) AS [SumOfNPOPrice]
							,SUM([CW].[US Price]) AS [SumOfNPOPriceUS]
							,ISNULL([O].[Discount1], 0) AS [Discount1]
							,[O].[Discount1_Name]
							,[O].[Discount1_Type]
							,ISNULL([O].[Discount2], 0) AS [Discount2]
							,[O].[Discount2_Name]
							,[O].[Discount2_Type]
							,ISNULL([O].[Discount3], 0) AS [Discount3]
							,[O].[Discount3_Name]
							,[O].[Discount3_Type]
							,ISNULL([O].[Volume Discount], 0) AS [Volume Discount]
							,ISNULL([O].[Program Discount], 0) AS [Program Discount]
							,[O].[Price] + [OO].[Price] + (CASE WHEN [O].[US Sale] = 1 THEN [CW].[US Price] ELSE [CW].[Price] END) AS [GrossPrice]
							,[SM].[ExchangeRate] * ([O].[Price] + [OO].[Price] + (CASE WHEN [O].[US Sale] = 1 THEN [CW].[US Price] ELSE [CW].[Price] END)) AS [GrossPriceCDN]
						FROM
							[BWSdb].[dbo].[Orders] [O]
						/*INNER JOIN
							[BWSdb].[dbo].[Products] [P]
						ON
							[O].[ProductID] = [P].[IDTrailer]*/
						INNER JOIN
							[SysproCompanyA].[dbo].[SorMaster] [SM]
						ON
							[O].[Sales Order#] = [SM].[SalesOrder]
						INNER JOIN (
							SELECT
								[Order Options].[Quote#]
								,[Order Options].[WO#]
								,SUM([Order Options].[Qty] * [Order Options].[Price]) AS [Price]
							FROM
								[BWSdb].[dbo].[Order Options]
							GROUP BY
								[Order Options].[Quote#]
								,[Order Options].[WO#]
						) AS [OO]
						ON
							[O].[Quote#] = [OO].[Quote#]
						INNER JOIN(
							SELECT
								[Custom Work].[Quote#]
								,[Custom Work].[WO#]
								,SUM(CASE WHEN [Orders].[US Sale] = 1 THEN 0 ELSE [Custom Work].[Price] END) AS [Price]
								,SUM(CASE WHEN [Orders].[US Sale] = 1 THEN [Custom Work].[US Price] ELSE 0 END) AS [US Price]
							FROM
								[BWSdb].[dbo].[Custom Work]
							INNER JOIN
								[BWSdb].[dbo].[Orders]
							ON
								[Custom Work].[Quote#] = [Orders].[Quote#]
							GROUP BY
								[Custom Work].[Quote#]
								,[Custom Work].[WO#]
						) AS [CW]
						ON
							[O].[Quote#] = [CW].[Quote#]
						GROUP BY
							[O].[Quote#]
							,[O].[WO#]
							,[O].[US Sale]
							,[O].[Price]
							,[O].[US Sale]
							,[OO].[Price]
							,[CW].[Price]
							,[CW].[US Price]
							,[O].[Discount1]
							,[O].[Discount1_Name]
							,[O].[Discount1_Type]
							,[O].[Discount2]
							,[O].[Discount2_Name]
							,[O].[Discount2_Type]
							,[O].[Discount3]
							,[O].[Discount3_Name]
							,[O].[Discount3_Type]
							,[O].[Volume Discount]
							,[O].[Program Discount]
							,[SM].[ExchangeRate]
					) AS [BaseOptNPO]
				) AS [Step1]
			) AS [Step2]
		) AS [Step3]
	) AS [Step4]
) AS [Step5]
/*
WHERE
	[Quote#] = 20974
*/
/*
SELECT
	[Quote#]
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
		[Quote#]
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
			[Quote#]
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
				[Quote#]
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
					[Quote#]
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
						[Quote#]
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
							[Quote#]
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
								[O].[Quote#]
								,[O].[WO#]
								,[O].[US Sale]
								,[SM].[ExchangeRate]
								,[O].[Price] AS [BasePrice]
								,SUM([OO].[Price]) AS [SumOfOptionPrice]
								,SUM([CW].[Price]) AS [SumOfNPOPrice]
								,SUM([CW].[US Price]) AS [SumOfNPOPriceUS]
								,ISNULL([O].[Discount1], 0) AS [Discount1]
								,[O].[Discount1_Name]
								,[O].[Discount1_Type]
								,ISNULL([O].[Discount2], 0) AS [Discount2]
								,[O].[Discount2_Name]
								,[O].[Discount2_Type]
								,ISNULL([O].[Discount3], 0) AS [Discount3]
								,[O].[Discount3_Name]
								,[O].[Discount3_Type]
								,ISNULL([O].[Volume Discount], 0) AS [Volume Discount]
								,ISNULL([O].[Program Discount], 0) AS [Program Discount]
								,[O].[Price] + [OO].[Price] + (CASE WHEN [O].[US Sale] = 1 THEN [CW].[US Price] ELSE [CW].[Price] END) AS [Total]
								,[SM].[ExchangeRate] * ([O].[Price] + [OO].[Price] + (CASE WHEN [O].[US Sale] = 1 THEN [CW].[US Price] ELSE [CW].[Price] END)) AS [TotalCDN]
							FROM
								[BWSdb].[dbo].[Orders] [O]
							INNER JOIN
								[BWSdb].[dbo].[Products] [P]
							ON
								[O].[ProductID] = [P].[IDTrailer]
							INNER JOIN
								[SysproCompanyA].[dbo].[SorMaster] [SM]
							ON
								[O].[Sales Order#] = [SM].[SalesOrder]
							INNER JOIN (
								SELECT
									[Order Options].[Quote#]
									,[Order Options].[WO#]
									,SUM([Order Options].[Qty] * [Order Options].[Price]) AS [Price]
								FROM
									[BWSdb].[dbo].[Order Options]
								GROUP BY
									[Order Options].[Quote#]
									,[Order Options].[WO#]
							) AS [OO]
							ON
								[O].[Quote#] = [OO].[Quote#]
							INNER JOIN(
								SELECT
									[Custom Work].[Quote#]
									,[Custom Work].[WO#]
									,SUM(CASE WHEN [Orders].[US Sale] = 1 THEN 0 ELSE [Custom Work].[Price] END) AS [Price]
									,SUM(CASE WHEN [Orders].[US Sale] = 1 THEN [Custom Work].[US Price] ELSE 0 END) AS [US Price]
								FROM
									[BWSdb].[dbo].[Custom Work]
								INNER JOIN
									[BWSdb].[dbo].[Orders]
								ON
									[Custom Work].[Quote#] = [Orders].[Quote#]
								GROUP BY
									[Custom Work].[Quote#]
									,[Custom Work].[WO#]
							) AS [CW]
							ON
								[O].[Quote#] = [CW].[Quote#]
							GROUP BY
								[O].[Quote#]
								,[O].[WO#]
								,[O].[US Sale]
								,[O].[Price]
								,[O].[US Sale]
								,[OO].[Price]
								,[CW].[Price]
								,[CW].[US Price]
								,[O].[Discount1]
								,[O].[Discount1_Name]
								,[O].[Discount1_Type]
								,[O].[Discount2]
								,[O].[Discount2_Name]
								,[O].[Discount2_Type]
								,[O].[Discount3]
								,[O].[Discount3_Name]
								,[O].[Discount3_Type]
								,[O].[Volume Discount]
								,[O].[Program Discount]
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
	[BWSdb].[dbo].[Orders]
WHERE
	[Quote#] = 23526

SELECT
	*
FROM
	[SysproCompanyA].[dbo].[SorMaster] [SM]
INNER JOIN
	[BWSdb].[dbo].[Orders] [O]
ON
	[O].[Sales Order#] = [SM].[SalesOrder]
WHERE
	[Quote#] = 23526
	
SELECT
	*
FROM
	[BWSdb].[dbo].[Order Options]
WHERE
	[Quote#] = 23526

SELECT
	*
FROM
	[BWSdb].[dbo].[Custom Work]
WHERE
	[Quote#] = 23526

SELECT
	SUM([Qty]*[Price]) AS [SumPrice_OO]
FROM
	[BWSdb].[dbo].[Order Options]
WHERE
	[Quote#] = 23526

SELECT
	SUM([Price]) AS [SumPrice_CW]
FROM
	[BWSdb].[dbo].[Custom Work]
WHERE
	[Quote#] = 23526

SELECT
	SUM([US Price]) AS [SumPriceUS_CW]
FROM
	[BWSdb].[dbo].[Custom Work]
WHERE
	[Quote#] = 23526
*/

GO


