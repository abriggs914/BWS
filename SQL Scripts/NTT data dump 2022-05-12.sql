--USE SysproCompanyA
USE BWSdb
GO

--SELECT * FROM [Sale Stats]
--SELECT * FROM [Sales Rpt]
--SELECT * FROM [Sales Staff]
--SELECT * FROM [Sales Summary]


USE SysproCompanyA
GO

SELECT TOP 500 * FROM [GenTransaction] -- ORDER BY [JnlDate] DESC
SELECT * FROM [ArTrnDetail]
SELECT 
	* 
FROM	
	[BWSdb].[dbo].[Customers] 
WHERE
	([Customer] LIKE 'NE'
	OR [Customer] LIKE 'valley'
	OR [Customer] LIKE 'VALLEY EQUIPMENT')




SELECT 
	* 
FROM	
	[BWSdb].[dbo].[Customers]
WHERE
	[Customer] IS NOT NULL
ORDER BY
	(CASE WHEN ([Customer] LIKE 'NE'
	OR [Customer] LIKE 'valley'
	OR [Customer] LIKE 'VALLEY EQUIPMENT') THEN 0 ELSE 1 END),
	[Customer]


SELECT * FROM [ArCustomer]
ORDER BY
	(CASE WHEN ([Name] LIKE 'NE'
	OR [Name] LIKE 'valley'
	OR [Name] LIKE 'VALLEY EQUIPMENT LTD.'
	OR [Name] LIKE 'NORTHEAST TRUCK & TRAILER'
	OR [Name] LIKE 'NORTHEAST TRUCK & TRAILER SALE'
	OR [Name] LIKE 'VALLEY EQUIPMENT') THEN 0 ELSE 1 END),
	[Name]


SELECT 
	YEAR([InvoiceDate]) AS [Year]
	, DATENAME(MONTH, [InvoiceDate]) AS [Month]
	, [Name] AS [Customer]
	, [ArTrnDetail].[StockCode]
	, [InvMaster].[Description]
	, SUM([QtyInvoiced]) AS [QtyInvoiced]
	, SUM([ArTrnDetail].[Mass]) AS [Mass]
	, SUM([ArTrnDetail].[Volume]) AS [Volume]
	, SUM([NetSalesValue]) AS [NetSalesValue]
	, SUM([TaxValue]) AS [TaxValue]
	, SUM([CostValue]) AS [CostValue]
FROM
	[ArTrnDetail]
INNER JOIN
	[ArCustomer]
ON	
	[ArTrnDetail].[Customer] = [ArCustomer].[Customer]
INNER JOIN
	[InvMaster]
ON
	[ArTrnDetail].[StockCode] = [InvMaster].[StockCode]
WHERE
	([Name] LIKE 'NE'
	OR [Name] LIKE 'valley'
	OR [Name] LIKE 'VALLEY EQUIPMENT LTD.'
	OR [Name] LIKE 'NORTHEAST TRUCK & TRAILER'
	OR [Name] LIKE 'NORTHEAST TRUCK & TRAILER SALE'
	OR [Name] LIKE 'VALLEY EQUIPMENT')
GROUP BY
	YEAR([InvoiceDate])
	, DATENAME(MONTH, [InvoiceDate])
	, MONTH([InvoiceDate])
	, [Name]
	, [ArTrnDetail].[StockCode]
	, [InvMaster].[Description]
ORDER BY
	YEAR([InvoiceDate]),
	MONTH([InvoiceDate])