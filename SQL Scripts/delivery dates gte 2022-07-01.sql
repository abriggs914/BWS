USE BWSdb
GO

-- All units for both BWS and Stargate with delivery date >= 2022-07-01

SELECT
	'BWS' AS [Company]
	,isnull(cast([Quote#] AS NVARCHAR(MAX)), '') AS [Quote#]
	,[Quote Date]
	,[Order Date]
	,isnull(cast([WO#] AS NVARCHAR(MAX)), '') AS [WO#]
	,isnull(cast([Sales Order#] AS NVARCHAR(MAX)), '') AS [Sales Order#]
	,isnull(cast([Model No] AS NVARCHAR(MAX)), '') AS [Model No]
	,isnull(cast([Width] AS NVARCHAR(MAX)), '') AS [Width]
	,isnull(cast([Spread] AS NVARCHAR(MAX)), '') AS [Spread]
	,isnull(cast([Dealers].[COMPANY NAME] AS NVARCHAR(MAX)), '') AS [Dealer]
	,isnull(cast(CAST([Price] AS MONEY) AS NVARCHAR(MAX)), '') AS [Price]
	,isnull(cast([Prom Drawing] AS NVARCHAR(MAX)), '') AS [Prom Drawing]
	,isnull(cast([Date Declined] AS NVARCHAR(MAX)), '') AS [Date Declined]
	,isnull(cast([Serial Number] AS NVARCHAR(MAX)), '') AS [Serial Number]
	,[Available Date]
	,[Delivery Date]
	,[Requested Delivery Date]
	,[Finish Date]
	,isnull(cast([Purchase Order] AS NVARCHAR(MAX)), '') AS [Purchase Order]
	,[PO Date]
	,isnull(cast([Volume Discount] AS NVARCHAR(MAX)), '') AS [Volume Discount]
	,isnull(cast([Program Discount] AS NVARCHAR(MAX)), '') AS [Program Discount]
	,isnull(cast([Discount1_Name] AS NVARCHAR(MAX)), '') AS [Discount1_Name]
	,isnull(cast([Discount1_Type] AS NVARCHAR(MAX)), '') AS [Discount1_Type]
	,isnull(cast([Discount1] AS NVARCHAR(MAX)), '') AS [Discount1]
	,isnull(cast([Discount2_Name] AS NVARCHAR(MAX)), '') AS [Discount2_Name]
	,isnull(cast([Discount2_Type] AS NVARCHAR(MAX)), '') AS [Discount2_Type]
	,isnull(cast([Discount2] AS NVARCHAR(MAX)), '') AS [Discount2]
	,isnull(cast([Discount3_Name] AS NVARCHAR(MAX)), '') AS [Discount3_Name]
	,isnull(cast([Discount3_Type] AS NVARCHAR(MAX)), '') AS [Discount3_Type]
	,isnull(cast([Discount3] AS NVARCHAR(MAX)), '') AS [Discount3]
	,[Est Pro Date]
	,isnull(cast([Notes] AS NVARCHAR(MAX)), '') AS [Notes]
	,isnull(cast((CASE WHEN [US Sale] = 1 THEN 'Y' ELSE 'N' END) AS NVARCHAR(MAX)), '') AS [US Sale]
	,[Shipped Date]
	,isnull(cast([FE Rate] AS NVARCHAR(MAX)), '') AS [FE Rate]
	,[PDD]
	,[Date Registered]
	,[Date In Service]
	,[Invoice Date]
	,[Date Requested]
	,isnull(cast([Slot#] AS NVARCHAR(MAX)), '') AS [Slot#]
	,isnull(cast([PriceSecured] AS NVARCHAR(MAX)), '') AS [PriceSecured]
	,[DateSecured]
	,isnull(cast([SecuredBy] AS NVARCHAR(MAX)), '') AS [SecuredBy]
FROM
	[Orders] WITH (NOLOCK)
LEFT JOIN
	[Dealers] WITH (NOLOCK)
ON
	[Orders].[DealerID] = [Dealers].[ID]
WHERE
	[Delivery Date] >= '2022-07-01'
ORDER BY
	[Delivery Date]

--UNION ALL

SELECT
	'STG' AS [Company]
	,[SGQuote]
	,[Quote Date]
	,[Order Date]
	,isnull(cast([WO#] AS NVARCHAR(MAX)), '') AS [WO#]
	,isnull(cast([Sales Order#] AS NVARCHAR(MAX)), '') AS [Sales Order#]
	,isnull(cast([Model No] AS NVARCHAR(MAX)), '') AS [Model No]
	,isnull(cast([Width] AS NVARCHAR(MAX)), '') AS [Width]
	,isnull(cast([Spread] AS NVARCHAR(MAX)), '') AS [Spread]
	,isnull(cast([DealersV2].[COMPANY NAME] AS NVARCHAR(MAX)), '') AS [Dealer]
	,isnull(cast(CAST([Price] AS MONEY) AS NVARCHAR(MAX)), '') AS [Price]
	,isnull(cast([Prom Drawing] AS NVARCHAR(MAX)), '') AS [Prom Drawing]
	,isnull(cast([Date Declined] AS NVARCHAR(MAX)), '') AS [Date Declined]
	,isnull(cast([Serial Number] AS NVARCHAR(MAX)), '') AS [Serial Number]
	,[Available Date]
	,[Delivery Date]
	,[Requested Delivery Date]
	,[Finish Date]
	,isnull(cast([Purchase Order] AS NVARCHAR(MAX)), '') AS [Purchase Order]
	,[PO Date]
	,isnull(cast([Volume Discount] AS NVARCHAR(MAX)), '') AS [Volume Discount]
	,isnull(cast([Program Discount] AS NVARCHAR(MAX)), '') AS [Program Discount]
	,isnull(cast([Discount1_Name] AS NVARCHAR(MAX)), '') AS [Discount1_Name]
	,isnull(cast([Discount1_Type] AS NVARCHAR(MAX)), '') AS [Discount1_Type]
	,isnull(cast([Discount1] AS NVARCHAR(MAX)), '') AS [Discount1]
	,isnull(cast([Discount2_Name] AS NVARCHAR(MAX)), '') AS [Discount2_Name]
	,isnull(cast([Discount2_Type] AS NVARCHAR(MAX)), '') AS [Discount2_Type]
	,isnull(cast([Discount2] AS NVARCHAR(MAX)), '') AS [Discount2]
	,isnull(cast([Discount3_Name] AS NVARCHAR(MAX)), '') AS [Discount3_Name]
	,isnull(cast([Discount3_Type] AS NVARCHAR(MAX)), '') AS [Discount3_Type]
	,isnull(cast([Discount3] AS NVARCHAR(MAX)), '') AS [Discount3]
	,[Est Pro Date]
	,isnull(cast([Notes] AS NVARCHAR(MAX)), '') AS [Notes]
	,isnull(cast((CASE WHEN [US Sale] = 1 THEN 'Y' ELSE 'N' END) AS NVARCHAR(MAX)), '') AS [US Sale]
	,[Shipped Date]
	,isnull(cast([FE Rate] AS NVARCHAR(MAX)), '') AS [FE Rate]
	,[PDD]
	,[Date Registered]
	,[Date In Service]
	,[Invoice Date]
	,[Date Requested]
	,isnull(cast([Slot#] AS NVARCHAR(MAX)), '') AS [Slot#]
	,isnull(cast([PriceSecured] AS NVARCHAR(MAX)), '') AS [PriceSecured]
	,[DateSecured]
	,isnull(cast([SecuredBy] AS NVARCHAR(MAX)), '') AS [SecuredBy]
FROM
	[OrdersV2] WITH (NOLOCK)
LEFT JOIN
	[DealersV2] WITH (NOLOCK)
ON
	[OrdersV2].[DealerID] = [DealersV2].[ID]
WHERE
	[Delivery Date] >= '2022-07-01'
ORDER BY
	[Delivery Date]