USE [BWSdb]
GO

/****** Object:  View [dbo].[v_SFC_OrdersDataOptions]    Script Date: 2023-11-29 2:42:23 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





--DECLARE @d1 AS DATETIME;
--SELECT @d1 = '2023-11-30 23:59:59';

ALTER VIEW [dbo].[v_SFC_OrdersDataOptions] AS

		--SELECT
	--	*
	--FROM (
		SELECT
			0 AS [CompanyID]
			,'Order Options' AS [OriginTable]
			,[O].[Quote Date] AS [DateQuote]
			,(CASE WHEN [O].[Quote Date] IS NULL THEN NULL ELSE
				DATEDIFF(YEAR, [O].[Quote Date], GETDATE()) / 365.0
			END) AS [DateGroup]
			,CAST([O].[Quote#] AS NVARCHAR(MAX)) AS [Quote]
			,[O].[WO#] AS [WO]
			,[O].[Model No] AS [ModelNo]
			,[O].[Sale PersonID] AS [SalesPersonID]
			,[S].[Sales Person] AS [SalesPerson]
			,[DealerID]
			,[D].[COMPANY NAME] AS [COMPANYNAME]
			,[R].[SalesOrder]
			,[R].[MStockCode]
			,[O].[Price] AS [OrderPrice]
			,[R].[MPrice] AS [PurchaseOrderPrice]
			,[P].[Price] AS [ProductsPrice]
			,[O].[US Sale] AS [USSale]
			,[Date Declined] AS [DateDeclined]
			,[Decline/Rejected] AS [Declined_Rejected]

			,[O].[Delivery Date] AS [OrderDeliveryDate]
			,[O].[Date In Service] AS [OrderDateInService]
			,[O].[Date Registered] AS [OrderDateRegistered]
			,[O].[Finish Date] AS [OrderFinishDate]
			,[T].[Sections] AS [OptionSections]
			,[T].[SortSe] AS [OptionSortSe]
			,[T].[Start Date] AS [OptionStartDate]
			,[T].[End Date] AS [OptionEndDate]
			,[T].[Option No] AS [OptionNo]
			,[T].[Price] AS [OptionPrice]
			,[T].[Cost] AS [OptionCost]
			,[T].[Draw/Part#] AS [OptionDrawPartNum]
			,[T].[Description] AS [OptionDescription]
			,[T].[Weight] AS [OptionWeight]

			,[P].[IDTrailer] AS [ProductID]
			,[T].[ID] AS [OptionID]
			,[O].[Order Date] AS [QuoteOrderDate]
		FROM
			[Orders] AS [O] WITH (NOLOCK)
		LEFT JOIN
			[SysproCompanyA].[dbo].[SorDetail] AS [R] WITH (NOLOCK)
		ON
			[O].[Sales Order#]= [R].[SalesOrder] COLLATE DATABASE_DEFAULT
		LEFT JOIN
			[Products] AS [P] WITH (NOLOCK)
		ON
			[O].[Model No] = [P].[Model No]
		LEFT JOIN
			[Dealers] AS [D] WITH (NOLOCK)
		ON
			[O].[DealerID] = [D].[ID]
		LEFT JOIN
			[Sales Staff] AS [S] WITH (NOLOCK)
		ON
			[O].[Sale PersonID] = [S].[ID-SaleStaff]
		LEFT JOIN
			[Order Options] AS [T] WITH (NOLOCK)
		ON
			[O].[Quote#] = [T].[Quote#]

	UNION ALL
		
		SELECT
			0 AS [CompanyID]
			,'Custom Work' AS [OriginTable]
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
			,[N].[Section] AS [NPOSections]
			,[N].[SortSe] AS [NPOSortSe]
			,NULL AS [NPOStartDate]
			,NULL AS [NPOEndDate]
			,NULL AS [NPOID]
			,[N].[Price] AS [NPOPrice]
			,[N].[Cost] AS [NPOCost]
			,[N].[Draw/Part#] AS [NPODrawPartNum]
			,[N].[Description] AS [NPODescription]
			,[N].[Weight] AS [NPOWeight]

			,[P].[IDTrailer] AS [ProductID]
			,[N].[ID] AS [OptionID]
			,[O].[Order Date] AS [QuoteOrderDate]
		FROM
			[Orders] AS [O] WITH (NOLOCK)
		LEFT JOIN
			[SysproCompanyA].[dbo].[SorDetail] AS [R] WITH (NOLOCK)
		ON
			[O].[Sales Order#]= [R].[SalesOrder] COLLATE DATABASE_DEFAULT
		LEFT JOIN
			[Products] AS [P] WITH (NOLOCK)
		ON
			[O].[Model No] = [P].[Model No]
		LEFT JOIN
			[Dealers] AS [D] WITH (NOLOCK)
		ON
			[O].[DealerID] = [D].[ID]
		LEFT JOIN
			[Sales Staff] AS [S] WITH (NOLOCK)
		ON
			[O].[Sale PersonID] = [S].[ID-SaleStaff]
		LEFT JOIN
			[Custom Work] AS [N] WITH (NOLOCK)
		ON
			[O].[Quote#] = [N].[Quote#]

	-- STARGATE

	UNION ALL

		SELECT
			1 AS [CompanyID]
			,'Order OptionsV2' AS [OriginTable]
			,[O2].[Quote Date] AS [DateQuote]
			,(CASE WHEN [O2].[Quote Date] IS NULL THEN NULL ELSE
				DATEDIFF(YEAR, [O2].[Quote Date], GETDATE()) / 365.0
			END) AS [DateGroup]
			,[O2].[SGQuote] AS [Quote]
			,[O2].[WO#] AS [WO]
			,[O2].[Model No] AS [ModelNo]
			,[O2].[Sale PersonID] AS [SalesPersonID]
			,[S].[Sales Person] AS [SalesPerson]
			,[DealerID]
			,[D2].[COMPANY NAME] AS [COMPANYNAME]
			,[R].[SalesOrder]
			,[R].[MStockCode]
			,[O2].[Price] AS [OrderPrice]
			,[R].[MPrice] AS [PurchaseOrderPrice]
			,[P2].[Price] AS [ProductsPrice]
			,[O2].[US Sale] AS [USSale]
			,[Date Declined] AS [DateDeclined]
			,[Decline/Rejected] AS [Declined_Rejected]

			,[O2].[Delivery Date] AS [OrderDeliveryDate]
			,[O2].[Date In Service] AS [OrderDateInService]
			,[O2].[Date Registered] AS [OrderDateRegistered]
			,[O2].[Finish Date] AS [OrderFinishDate]
			,[T2].[Sections] AS [OptionSections]
			,[T2].[SortSe] AS [OptionSortSe]
			,[T2].[Start Date] AS [OptionStartDate]
			,[T2].[End Date] AS [OptionEndDate]
			,[T2].[Option No] AS [OptionNo]
			,[T2].[Price] AS [OptionPrice]
			,[T2].[Cost] AS [OptionCost]
			,[T2].[Draw/Part#] AS [OptionDrawPartNum]
			,[T2].[Description] AS [OptionDescription]
			,[T2].[Weight] AS [OptionWeight]

			,[P2].[IDTrailer] AS [ProductID]
			,[T2].[ID] AS [OptionID]
			,[O2].[Order Date] AS [QuoteOrderDate]
		FROM
			[OrdersV2] AS [O2] WITH (NOLOCK)
		LEFT JOIN
			[SysproCompanyS].[dbo].[SorDetail] AS [R] WITH (NOLOCK)
		ON
			[O2].[Sales Order#]= [R].[SalesOrder] COLLATE DATABASE_DEFAULT
		LEFT JOIN
			[ProductsV2] AS [P2] WITH (NOLOCK)
		ON
			[O2].[Model No] = [P2].[Model No]
		LEFT JOIN
			[DealersV2] AS [D2] WITH (NOLOCK)
		ON
			[O2].[DealerID] = [D2].[ID]
		LEFT JOIN
			[Sales Staff] AS [S] WITH (NOLOCK)
		ON
			[O2].[Sale PersonID] = [S].[ID-SaleStaff]
		LEFT JOIN
			[Order OptionsV2] AS [T2] WITH (NOLOCK)
		ON
			[O2].[SGQuote] = [T2].[SGQuote]

	UNION ALL
		
		SELECT
			1 AS [CompanyID]
			,'Custom WorkV2' AS [OriginTable]
			,[O2].[Quote Date]
			,(CASE WHEN [O2].[Quote Date] IS NULL THEN NULL ELSE
				DATEDIFF(YEAR, [O2].[Quote Date], GETDATE()) / 365.0
			END) AS [DateGroup]
			,[O2].[SGQuote] AS [Quote]
			,[O2].[WO#] AS [WONum]
			,[O2].[Model No]
			,[O2].[Sale PersonID]
			,[S].[Sales Person]
			,[DealerID]
			,[D2].[COMPANY NAME]
			,[R2].[SalesOrder]
			,[R2].[MStockCode]
			,[O2].[Price] AS [OrderPrice]
			,[R2].[MPrice] AS [PurchaseOrderPrice]
			,[P2].[Price] AS [ProductsPrice]
			,[O2].[US Sale]
			,[Date Declined]
			,[Decline/Rejected]

			,[O2].[Delivery Date] AS [OrderDeliveryDate]
			,[O2].[Date In Service] AS [OrderDateInService]
			,[O2].[Date Registered] AS [OrderDateRegistered]
			,[O2].[Finish Date] AS [OrderFinishDate]
			,[N2].[Section] AS [NPOSections]
			,[N2].[SortSe] AS [NPOSortSe]
			,NULL AS [NPOStartDate]
			,NULL AS [NPOEndDate]
			,NULL AS [NPOID]
			,[N2].[Price] AS [NPOPrice]
			,[N2].[Cost] AS [NPOCost]
			,[N2].[Draw/Part#] AS [NPODrawPartNum]
			,[N2].[Description] AS [NPODescription]
			,[N2].[Weight] AS [NPOWeight]

			,[P2].[IDTrailer] AS [ProductID]
			,[N2].[ID] AS [OptionID]
			,[O2].[Order Date] AS [QuoteOrderDate]
		FROM
			[OrdersV2] AS [O2] WITH (NOLOCK)
		LEFT JOIN
			[SysproCompanyS].[dbo].[SorDetail] AS [R2] WITH (NOLOCK)
		ON
			[O2].[Sales Order#]= [R2].[SalesOrder] COLLATE DATABASE_DEFAULT
		LEFT JOIN
			[ProductsV2] AS [P2] WITH (NOLOCK)
		ON
			[O2].[Model No] = [P2].[Model No]
		LEFT JOIN
			[Dealers] AS [D2] WITH (NOLOCK)
		ON
			[O2].[DealerID] = [D2].[ID]
		LEFT JOIN
			[Sales Staff] AS [S] WITH (NOLOCK)
		ON
			[O2].[Sale PersonID] = [S].[ID-SaleStaff]
		LEFT JOIN
			[Custom WorkV2] AS [N2] WITH (NOLOCK)
		ON
			[O2].[SGQuote] = [N2].[SGQuote]







































	--UNION

	--	SELECT
	--		1
	--		,[O].[Quote Date]
	--		,(CASE WHEN [O].[Quote Date] IS NULL THEN NULL ELSE
	--			DATEDIFF(YEAR, [O].[Quote Date], GETDATE()) / 365.0
	--		END) AS [DateGroup]
	--		,[O].[SGQuote]
	--		,[O].[WO#] AS [WONum]
	--		,[O].[Model No]
	--		,[O].[Sale PersonID]
	--		,[S].[Sales Person]
	--		,[DealerID]
	--		,[D].[COMPANY NAME]
	--		,[R].[SalesOrder]
	--		,[R].[MStockCode]
	--		,[O].[Price] AS [OrderPrice]
	--		,[R].[MPrice] AS [PurchaseOrderPrice]
	--		,[P].[Price] AS [ProductsPrice]
	--		,[O].[US Sale]
	--		,[Date Declined]
	--		,[Decline/Rejected]

	--		,[O].[Delivery Date] AS [OrderDeliveryDate]
	--		,[O].[Date In Service] AS [OrderDateInService]
	--		,[O].[Date Registered] AS [OrderDateRegistered]
	--		,[O].[Finish Date] AS [OrderFinishDate]
	--		,[T].[Sections] AS [OptionSections]
	--		,[T].[SortSe] AS [OptionSortSe]
	--		,[T].[Start Date] AS [OptionStartDate]
	--		,[T].[End Date] AS [OptionEndDate]
	--		,[T].[Option No]
	--		,[T].[Price] AS [OptionPrice]
	--		,[T].[Cost] AS [OptionCost]
	--		,[T].[Draw/Part#] AS [OptionDrawPartNum]
	--		,[T].[Description] AS [OptionDescription]
	--		,[T].[Weight] AS [OptionWeight]
			
	--		,[N].[Section] AS [NPOSections]
	--		,[N].[SortSe] AS [NPOSortSe]
	--		,[N].[ID] AS [NPOID]
	--		,[N].[Price] AS [NPOPrice]
	--		,[N].[Cost] AS [NPOCost]
	--		,[N].[Draw/Part#] AS [NPODrawPartNum]
	--		,[N].[Description] AS [NPODescription]
	--		,[N].[Weight] AS [NPOWeight]


	--		,[P].[IDTrailer] AS [ProductID]
	--		,[T].[ID]
	--		,[O].[Order Date] AS [QuoteOrderDate]

	--		--,[O].[WO#]
	--		--,[O].[Model No]
	--		--,[O].[Sale PersonID]
	--		--,[S].[Sales Person]
	--		--,[DealerID]
	--		--,[D].[COMPANY NAME]
	--		--,[R].[SalesOrder]
	--		--,[R].[MStockCode]
	--		--,[O].[Price]
	--		--,[R].[MPrice]
	--		--,[P].[Price]
	--		--,[O].[US Sale]
	--		--,[Date Declined]
	--		--,[Decline/Rejected]
	--		--,[P].[IDTrailer] AS [ProductID]
	--		--,[T].[ID] AS [OptionID]
	--		--,[N].[ID] AS [OptionID]
	--	FROM
	--		[OrdersV2] AS [O]
	--	LEFT JOIN
	--		[SysproCompanyS].[dbo].[SorDetail] AS [R]
	--	ON
	--		[O].[Sales Order#] = [R].[SalesOrder] COLLATE DATABASE_DEFAULT
	--	LEFT JOIN
	--		[ProductsV2] AS [P]
	--	ON
	--		[O].[Model No] = [P].[Model No]
	--	LEFT JOIN
	--		[DealersV2] AS [D]
	--	ON
	--		[O].[DealerID] = [D].[ID]
	--	LEFT JOIN
	--		[Sales Staff] AS [S]
	--	ON
	--		[O].[Sale PersonID] = [S].[ID-SaleStaff]
	--	LEFT JOIN
	--		[Order OptionsV2] AS [T]
	--	ON
	--		[O].[SGQuote] = [T].[SGQuote]
	--	LEFT JOIN
	--		[Custom WorkV2] AS [N]
	--	ON
	--		[O].[SGQuote] = [N].[SGQuote]
	----) AS [Src]
	----ORDER BY
	----	[Quote Date]
	----;
GO


