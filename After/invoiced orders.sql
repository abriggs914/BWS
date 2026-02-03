USE BWSdb
GO

SELECT
	*
FROM
	[SysproCompanyA].[dbo].[CusSorMaster+] [CS] WITH (NOLOCK)

SELECT
	[Quote#],
	[O].[Sales Order#],
	[CS].[InvoiceNumber],
	[CS].[SalesOrder],
	[SM].[SalesOrder],
	[SM].[EntInvoiceDate] AS [InvoiceDate1],
	[SMR].[EntInvoiceDate] AS [InvoiceDate2],
	[SMR].[ExchangeRate]
FROM
	[BWSdb].[dbo].[Orders] [O] WITH (NOLOCK)
INNER JOIN
	[SysproCompanyA].[dbo].[CusSorMaster+] [CS] WITH (NOLOCK)
ON
	RIGHT('000000000000000' + CAST([O].[Sales Order#] AS NVARCHAR(255)), 15) = [CS].[SalesOrder]
INNER JOIN
	[SysproCompanyA].[dbo].[SorMaster] AS [SM] WITH (NOLOCK)
ON
	[CS].[SalesOrder] = [SM].[SalesOrder]
LEFT OUTER JOIN
	[SysproCompanyA].[dbo].[SorMasterRep] AS [SMR] WITH (NOLOCK) 
ON 
	[CS].[SalesOrder] = [SMR].[SalesOrder]


SELECT
	[Quote#],
	[Invoice #],
	*
	--[St]
FROM
	[BWSdb].[dbo].[Fin Sales - Performance]

;

SELECT
	[ByQuote].[Date],
	[NumQuotes],
	[NumOrders]
FROM (
	SELECT
		[Calendar].[Date]
		, CASE WHEN [Orders].[Quote Date] IS NULL THEN 0 ELSE COUNT(*) END AS [NumQuotes]
	FROM
		[Calendar]
	LEFT JOIN
		[Orders]
	ON
		[Calendar].[Date] = CAST(
			CAST(YEAR([Quote Date]) AS NVARCHAR(4))
			+ '-' + RIGHT('00' + CAST(MONTH([Quote Date]) AS NVARCHAR(2)), 2)
			+ '-' + RIGHT('00' + CAST(DAY([Quote Date]) AS NVARCHAR(2)), 2)
		AS DATETIME)
	WHERE
		[Calendar].[Date] BETWEEN DATEADD(YEAR, -10, GETDATE()) AND DATEADD(YEAR, 10, GETDATE())
	GROUP BY
		[Calendar].[Date]
		, [Orders].[Quote Date]
		, YEAR([Quote Date])
		, MONTH([Quote Date])
		, DAY([Quote Date])
) AS [ByQuote]
INNER JOIN (
	SELECT
		[Calendar].[Date]
		, CASE WHEN [Orders].[Order Date] IS NULL THEN 0 ELSE COUNT(*) END AS [NumOrders]
	FROM
		[Calendar]
	LEFT JOIN
		[Orders]
	ON
		[Calendar].[Date] = CAST(
			CAST(YEAR([Order Date]) AS NVARCHAR(4))
			+ '-' + RIGHT('00' + CAST(MONTH([Order Date]) AS NVARCHAR(2)), 2)
			+ '-' + RIGHT('00' + CAST(DAY([Order Date]) AS NVARCHAR(2)), 2)
		AS DATETIME)
	WHERE
		[Calendar].[Date] BETWEEN DATEADD(YEAR, -10, GETDATE()) AND DATEADD(YEAR, 10, GETDATE())
	GROUP BY
		[Calendar].[Date]
		, [Orders].[Order Date]
		, YEAR([Order Date])
		, MONTH([Order Date])
		, DAY([Order Date])
) AS [ByOrder]
ON
	[ByQuote].[Date] = [ByOrder].[Date]
ORDER BY
	[ByQuote].[Date]
;