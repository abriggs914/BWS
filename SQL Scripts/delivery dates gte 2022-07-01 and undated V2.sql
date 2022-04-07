USE BWSdb
GO

SELECT
	'BWS' AS [Company]
	,[Orders].[Quote#]
	,[Quote Date]
	,[Order Date]
	,isnull(cast([Orders].[WO#] AS NVARCHAR(MAX)), '') AS [WO#]
	,isnull(cast([Sales Order#] AS NVARCHAR(MAX)), '') AS [Sales Order#]
	,isnull(cast([Model No] AS NVARCHAR(MAX)), '') AS [Model No]
	,isnull(cast([Width] AS NVARCHAR(MAX)), '') AS [Width]
	,isnull(cast([Spread] AS NVARCHAR(MAX)), '') AS [Spread]
	,isnull(cast([Dealers].[COMPANY NAME] AS NVARCHAR(MAX)), '') AS [Dealer]
	,isnull(cast(CAST([Price] AS MONEY) AS NVARCHAR(MAX)), '') AS [Price]
	,isnull(cast([Prom Drawing] AS NVARCHAR(MAX)), '') AS [Prom Drawing]
	,[Date Declined]
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
	,isnull(cast([Orders].[Slot#] AS NVARCHAR(MAX)), '') AS [Slot#]
	,isnull(cast([PriceSecured] AS NVARCHAR(MAX)), '') AS [PriceSecured]
	,[DateSecured]
	,isnull(cast([SecuredBy] AS NVARCHAR(MAX)), '') AS [SecuredBy]
	,[Prod Date 1] AS [Prod Date 1]
	,[Prod Date 2] AS [Prod Date 2]
FROM
	[Orders] WITH (NOLOCK)
LEFT JOIN
	[Dealers] WITH (NOLOCK)
ON
	[Orders].[DealerID] = [Dealers].[ID]
LEFT JOIN
	[dtProductionSchedule]
ON
	[Orders].[WO#] = [dtProductionSchedule].[WO#]
WHERE
	[Order Date] IS NOT NULL
	AND ([Delivery Date] IS NULL OR [Delivery Date] >= '2022-07-01')
	AND [Date Declined] IS NULL
	AND [Shipped Date] IS NULL
	AND ([Prod Date 1] IS NULL
	OR [Prod Date 2] IS NULL)
ORDER BY
	[Delivery Date]
	,[Quote Date]




--SELECT * 
--FROM
--	[Orders] WITH (NOLOCK)
--LEFT JOIN
--	[Dealers] WITH (NOLOCK)
--ON
--	[Orders].[DealerID] = [Dealers].[ID]
--LEFT JOIN
--	[dtProductionSchedule]
--ON
--	[Orders].[Quote#] = [dtProductionSchedule].[Quote#]
--WHERE
--	([Prod Date 1] IS NULL
--	OR [Prod Date 2] IS NULL)
--	AND [Delivery Date] >= '2022-07-01'