USE BWSdb
GO

SELECT
	[O].[SalesStaff_SalesPerson]
	,[O].[Orders_ProductID]
	,[O].[Products_ModelNo]
	,COUNT(*) AS [NumQuotes]
	--,SUM([O].[Products_Price]) AS [SumOfProductPrice]
	,SUM([O].[Orders_Price]) AS [SumOfOrdersPrice]
FROM
	[v_SFC_BWSUnionSTGOrders] AS [O]
WHERE
	[O].[SalesStaff_SalesPerson] IS NOT NULL
	AND [O].[Orders_ProductID] IS NOT NULL
	AND [O].[SalesStaff_Active] = 1
	--AND
GROUP BY
	[O].[SalesStaff_SalesPerson]
	,[O].[Orders_ProductID]
	,[O].[Products_ModelNo]
ORDER BY
	[O].[SalesStaff_SalesPerson]


--SELECT * FROM [Sales Staff]

EXEC
	[sp_SFC_IndividualSalesData]
	@salesPersonID = 0,
	@allCompanies = 1