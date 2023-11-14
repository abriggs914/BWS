USE BWSdb
GO

--DECLARE @d1 AS DATETIME;
--SELECT @d1 = '2023-11-30 23:59:59';

ALTER VIEW [v_SFC_OrdersData] AS

	--SELECT
	--	*
	--FROM (
		SELECT
			0 AS [CompanyID]
			,[Quote Date]
			,(CASE WHEN [Quote Date] IS NULL THEN NULL ELSE
				DATEDIFF(YEAR, [Quote Date], GETDATE()) / 365.0
			END) AS [DateGroup]
			,CAST([Quote#] AS NVARCHAR(MAX)) AS [Quote]
			,[O].[Model No]
			,[O].[Sale PersonID]
			,[S].[Sales Person]
			,[DealerID]
			,[D].[COMPANY NAME]
			,[R].[SalesOrder]
			,[R].[MStockCode]
			,[O].[Price] AS [OrderPrice]
			,[R].[MPrice] AS [PurchaseOrderPrice]
			,[P].[Price] AS [ProductsPrice]
			,[Date Declined]
			,[Decline/Rejected]
			,[P].[IDTrailer] AS [ProductID]
		FROM
			[Orders] AS [O]
		LEFT JOIN
			[SysproCompanyA].[dbo].[SorDetail] AS [R]
		ON
			[O].[Sales Order#]= [R].[SalesOrder] COLLATE DATABASE_DEFAULT
		LEFT JOIN
			[Products] AS [P]
		ON
			[O].[Model No] = [P].[Model No]
		LEFT JOIN
			[Dealers] AS [D]
		ON
			[O].[DealerID] = [D].[ID]
		LEFT JOIN
			[Sales Staff] AS [S]
		ON
			[O].[Sale PersonID] = [S].[ID-SaleStaff]

		UNION

		SELECT
			1
			,[Quote Date]
			,(CASE WHEN [Quote Date] IS NULL THEN NULL ELSE
				DATEDIFF(YEAR, [Quote Date], GETDATE()) / 365.0
			END) AS [DateGroup]
			,[SGQuote]
			,[O].[Model No]
			,[O].[Sale PersonID]
			,[S].[Sales Person]
			,[DealerID]
			,[D].[COMPANY NAME]
			,[R].[SalesOrder]
			,[R].[MStockCode]
			,[O].[Price]
			,[R].[MPrice]
			,[P].[Price]
			,[Date Declined]
			,[Decline/Rejected]
			,[P].[IDTrailer] AS [ProductID]
		FROM
			[OrdersV2] AS [O]
		LEFT JOIN
			[SysproCompanyS].[dbo].[SorDetail] AS [R]
		ON
			[O].[Sales Order#] = [R].[SalesOrder] COLLATE DATABASE_DEFAULT
		LEFT JOIN
			[ProductsV2] AS [P]
		ON
			[O].[Model No] = [P].[Model No]
		LEFT JOIN
			[DealersV2] AS [D]
		ON
			[O].[DealerID] = [D].[ID]
		LEFT JOIN
			[Sales Staff] AS [S]
		ON
			[O].[Sale PersonID] = [S].[ID-SaleStaff]
	--) AS [Src]
	--ORDER BY
	--	[Quote Date]
	--;
GO