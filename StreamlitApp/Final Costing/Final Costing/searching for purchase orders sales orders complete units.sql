			SELECT
				CAST([O2].[WO#] AS NVARCHAR(MAX)) AS [WO#]
				--,[SM].[]
				,[O2].[Quote Date]
				,[O2].[Delivery Date]
				,[O2].[US Sale]
				,[O2].[SGQuote]
				,[O2].[Model No]
				,[D2].[COMPANY NAME] AS [Dealer]
				,[O2].[Price] AS [OrderPrice]
				,[P2].[Price] AS [ProductPrice]
				,[P2].[US Price] AS [ProductPriceUS]
				,[SM].[ExchangeRate]
				--,[SM].[FixExchangeRate]
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
			LEFT JOIN
				[SysproCompanyS].[dbo].[SorMaster] [SM]
			ON
				[O2].[Sales Order#] = CAST([SM].[SalesOrder] AS INT)
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
				,[P2].[US Price]
				
				
SELECT
	[Purchase Order]
FROM
	[BWSdb].[dbo].[OrdersV2] [O2]
GROUP BY
	[Purchase Order]
;
SELECT
	[PurchaseOrder]
FROM
	[SysproCompanyS].[dbo].[PorMasterDetail] [PM]
GROUP BY
	[PurchaseOrder]
;

SELECT
	*
FROM
	[BWSdb].[dbo].[OrdersV2] [O2]
INNER JOIN
	[SysproCompanyS].[dbo].[PorMasterDetail] [PM]
ON
	[O2].[Purchase Order] COLLATE DATABASE_DEFAULT = [PM].[PurchaseOrder] COLLATE DATABASE_DEFAULT


SELECT
	*
FROM
	[BWSdb].[dbo].[OrdersV2] [O2]
INNER JOIN
	[SysproCompanyS].[dbo].[PorMasterDetail] [PM]
ON
	[O2].[Purchase Order] COLLATE DATABASE_DEFAULT = [PM].[PurchaseOrder] COLLATE DATABASE_DEFAULT



SELECT
	[SalesOrder]
	,[Job]
	,[ExchangeRate]
	,[FixExchangeRate]
	,[US Sale]
	,*
FROM
	[BWSdb].[dbo].[OrdersV2] [O2]
INNER JOIN
	[SysproCompanyS].[dbo].[SorMaster] [SM]
ON
	[O2].[Sales Order#] = CAST([SM].[SalesOrder] AS INT)
WHERE
	(ISNULL([SalesOrder], '') <> '')
	AND (ISNULL([WO#], -1) <> -1)
ORDER BY
	[Quote Date] DESC



---------------------------------------
/*
						SELECT
							[SGQuote]
							,[WO#]
							,[BasePrice]
							,[SumOfOptionPrice]
							,[SumOfNPOPrice]
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
							,(CASE WHEN [Discount3_Type] = 'Fixed' THEN [Discount3] ELSE (CASE WHEN [Discount3_Type] = 'Percent' THEN [Total] * [Discount3] * -1 ELSE 0 END) END) AS [D3]
						FROM (
						*/
							SELECT
								[O2].[SGQuote]
								,[O2].[WO#]
								,[O2].[Price] AS [BasePrice]
								,SUM([OO2].[Price]) AS [SumOfOptionPrice]
								,SUM([CW2].[Price]) AS [SumOfNPOPrice]
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
							FROM
								[BWSdb].[dbo].[OrdersV2] [O2]
							INNER JOIN
								[BWSdb].[dbo].[ProductsV2] [P2]
							ON
								[O2].[ProductID] = [P2].[IDTrailer]
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


SELECT
	*
FROM
	[BWSdb].[dbo].[OrdersV2] [O2]
INNER JOIN
	[SysproCompanyS].[dbo].[SorMaster] [SM]
ON
	[O2].[Sales Order#] = CAST([SM].[SalesOrder] AS INT)
WHERE
	[O2].[SGQuote] = 'SG101730'