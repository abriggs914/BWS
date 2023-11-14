USE [BWSdb]
GO

/****** Object:  View [dbo].[v_SFC_OrdersData]    Script Date: 2023-11-07 1:58:04 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


--DECLARE @d1 AS DATETIME;
--SELECT @d1 = '2023-11-30 23:59:59';

ALTER VIEW [dbo].[v_SFC_OrdersData] AS

	--SELECT
	--	*
	--FROM (
		SELECT
			0 AS [CompanyID]
			,[O].[Quote Date]
			,(CASE WHEN [O].[Quote Date] IS NULL THEN NULL ELSE
				DATEDIFF(YEAR, [O].[Quote Date], GETDATE()) / 365.0
			END) AS [DateGroup]
			,CAST([O].[Quote#] AS NVARCHAR(MAX)) AS [Quote]
			,[O].[WO#] AS [WONum]
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
			,[O].[US Sale]
			,[Date Declined]
			,[Decline/Rejected]

			,[O].[Delivery Date] AS [OrderDeliveryDate]
			,[O].[Date In Service] AS [OrderDateInService]
			,[O].[Date Registered] AS [OrderDateRegistered]
			,[O].[Finish Date] AS [OrderFinishDate]

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
			,[O].[Quote Date]
			,(CASE WHEN [O].[Quote Date] IS NULL THEN NULL ELSE
				DATEDIFF(YEAR, [O].[Quote Date], GETDATE()) / 365.0
			END) AS [DateGroup]
			,[O].[SGQuote]
			,[O].[WO#] AS [WONum]
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
			,[O].[US Sale]
			,[Date Declined]
			,[Decline/Rejected]

			,[O].[Delivery Date] AS [OrderDeliveryDate]
			,[O].[Date In Service] AS [OrderDateInService]
			,[O].[Date Registered] AS [OrderDateRegistered]
			,[O].[Finish Date] AS [OrderFinishDate]

			,[P].[IDTrailer] AS [ProductID]

			--,[O].[WO#]
			--,[O].[Model No]
			--,[O].[Sale PersonID]
			--,[S].[Sales Person]
			--,[DealerID]
			--,[D].[COMPANY NAME]
			--,[R].[SalesOrder]
			--,[R].[MStockCode]
			--,[O].[Price]
			--,[R].[MPrice]
			--,[P].[Price]
			--,[O].[US Sale]
			--,[Date Declined]
			--,[Decline/Rejected]
			--,[P].[IDTrailer] AS [ProductID]
			--,[T].[ID] AS [OptionID]
			--,[N].[ID] AS [OptionID]
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


