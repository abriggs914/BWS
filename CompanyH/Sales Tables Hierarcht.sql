SELECT
	CAST([O].[Quote#] AS NVARCHAR(MAX)) AS [Q],
	[O].[Quote Date],
	[O].[Order Date],
	[O].[Model No],
	[O].[Price],
	[O].[Decline/Rejected],
	[S].[Sales Person],
	[D].[COMPANY NAME],
	[B].[Branch],
	[P].[Sales Person]
FROM
	[BWSdb].[dbo].[Orders] [O]
LEFT JOIN
	[BWSdb].[dbo].[Sales Staff] [S]
ON
	[O].[Sale PersonID] = [S].[ID-SaleStaff]
LEFT JOIN
	[BWSdb].[dbo].[Dealers] [D]
ON
	[O].[DealerID] = [D].[ID]
LEFT JOIN
	[BWSdb].[dbo].[Dealers_SalesPersonBranch] [B]
ON
	[O].[DealerBranchID] = [B].[Dealers_SPBID]
LEFT JOIN
	[BWSdb].[dbo].[Dealers_SalesPeople] [P]
ON
	[O].[DealerSalesPersonID] = [P].[Dealers_SPID]
WHERE
	[Order Date] > '2025-01-11'

UNION ALL

SELECT
	CAST([O].[SGQuote] AS NVARCHAR(MAX)) AS [Q],
	[O].[Quote Date],
	[O].[Order Date],
	[O].[Model No],
	[O].[Price],
	[O].[Decline/Rejected],
	[S].[Sales Person],
	[D].[COMPANY NAME],
	[B].[Branch],
	[P].[Sales Person]
FROM
	[BWSdb].[dbo].[OrdersV2] [O]
LEFT JOIN
	[BWSdb].[dbo].[Sales Staff] [S]
ON
	[O].[Sale PersonID] = [S].[ID-SaleStaff]
LEFT JOIN
	[BWSdb].[dbo].[DealersV2] [D]
ON
	[O].[DealerID] = [D].[ID]
LEFT JOIN
	[BWSdb].[dbo].[DealersV2_SalesPersonBranch] [B]
ON
	[O].[DealerBranchID] = [B].[DealersV2_SPBID]
LEFT JOIN
	[BWSdb].[dbo].[DealersV2_SalesPeople] [P]
ON
	[O].[DealerSalesPersonID] = [P].[DealersV2_SPID]
WHERE
	[Order Date] > '2025-01-11'

SELECT
	CAST([O].[Quote#] AS NVARCHAR(MAX)) AS [Q],
	[O].[Quote Date],
	[O].[Order Date],
	[O].[Model No],
	[O].[Price],
	[O].[Decline/Rejected],
	[S].[Sales Person],
	[D].[COMPANY NAME],
	[B].[Branch],
	[P].[Sales Person]
FROM
	[BWSdb].[dbo].[Orders] [O]
LEFT JOIN
	[BWSdb].[dbo].[Sales Staff] [S]
ON
	[O].[Sale PersonID] = [S].[ID-SaleStaff]
LEFT JOIN
	[BWSdb].[dbo].[Dealers] [D]
ON
	[O].[DealerID] = [D].[ID]
LEFT JOIN
	[BWSdb].[dbo].[Dealers_SalesPersonBranch] [B]
ON
	[O].[DealerBranchID] = [B].[Dealers_SPBID]
LEFT JOIN
	[BWSdb].[dbo].[Dealers_SalesPeople] [P]
ON
	[O].[DealerSalesPersonID] = [P].[Dealers_SPID]
WHERE
	[Quote Date] > '2025-01-11'

UNION ALL

SELECT
	CAST([O].[SGQuote] AS NVARCHAR(MAX)) AS [Q],
	[O].[Quote Date],
	[O].[Order Date],
	[O].[Model No],
	[O].[Price],
	[O].[Decline/Rejected],
	[S].[Sales Person],
	[D].[COMPANY NAME],
	[B].[Branch],
	[P].[Sales Person]
FROM
	[BWSdb].[dbo].[OrdersV2] [O]
LEFT JOIN
	[BWSdb].[dbo].[Sales Staff] [S]
ON
	[O].[Sale PersonID] = [S].[ID-SaleStaff]
LEFT JOIN
	[BWSdb].[dbo].[DealersV2] [D]
ON
	[O].[DealerID] = [D].[ID]
LEFT JOIN
	[BWSdb].[dbo].[DealersV2_SalesPersonBranch] [B]
ON
	[O].[DealerBranchID] = [B].[DealersV2_SPBID]
LEFT JOIN
	[BWSdb].[dbo].[DealersV2_SalesPeople] [P]
ON
	[O].[DealerSalesPersonID] = [P].[DealersV2_SPID]
WHERE
	[Quote Date] > '2025-01-11'

/*
SELECT
	*
FROM
	[BWSdb].[dbo].[Sales Staff]
*/