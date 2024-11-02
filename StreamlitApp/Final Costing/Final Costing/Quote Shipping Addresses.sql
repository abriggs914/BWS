SELECT
	[Quote#]
	,[WO#]
	,[Model No]
	,[Customer]
	,[Dealer]
	,ISNULL([CustAddress], [DealerAddress]) AS [ShippedAddress]
	,ISNULL([CustCity], [DealerCity]) AS [ShippedCity]
	,ISNULL([CustProvince], [DealerProvince]) AS [ShippedProvince]
	,ISNULL([CustPostal], [DealerPostal]) AS [ShippedPostal]
FROM (
	SELECT
		[O].[Quote#]
		,[O].[WO#]
		,[O].[Model No]
		,[C].[Customer]
		,[C].[Address] AS [CustAddress]
		,[C].[City] AS [CustCity]
		,[C].[Province/State] AS [CustProvince]
		,[C].[Postal Code/ZIP] AS [CustPostal]
		,[D].[COMPANY NAME] AS [Dealer]
		,[D].[Address] AS [DealerAddress]
		,[D].[City] AS [DealerCity]
		,[D].[PROVINCE] AS [DealerProvince]
		,[D].[POSTAL CODE] AS [DealerPostal]
	FROM
		[BWSdb].[dbo].[Orders] [O]
	LEFT JOIN
		[BWSdb].[dbo].[Dealers] [D]
	ON
		[O].[DealerID] = [D].[ID]
	LEFT JOIN
		[BWSdb].[dbo].[Dealers_SalesPeople] [DS]
	ON
		([O].[DealerBranchID] = [DS].[BranchID])
		AND ([O].[DealerSalesPersonID] = [DS].[Dealers_SPID])
		AND ([O].[DealerID] = [DS].[DealerID])
	LEFT JOIN
		[BWSdb].[dbo].[Dealers_SalesPersonBranch] [DSB]
	ON
		([DS].[BranchID] = [DSB].[Dealers_SPBID])
	LEFT JOIN
		[BWSdb].[dbo].[Customers] [C]
	ON
		[O].[WO#] = [C].[WO#]
	WHERE
		([O].[Decline/Rejected] = 4)
		AND ([O].[WO#] IS NOT NULL)
) AS [Src]
ORDER BY
	[WO#] DESC


/*
SELECT
	*
FROM
	[BWSdb].[dbo].[Customers] [C]
*/