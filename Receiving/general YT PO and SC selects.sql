SELECT
	[Active], [WO], [StockCode], [QtyMissing], [Notes]

FROM
	[BWSdb].[dbo].[PROD_YellowTags]
;
SELECT
	*
FROM
	[BWSdb].[dbo].[hist_PROD_YellowTags]
;
SELECT
	*
FROM
	[BWSdb].[dbo].[PROD_YellowTags]
;
SELECT
	*
FROM
	[BWSdb].[dbo].[WSOM_MeetingNotes]
;
SELECT
	*
FROM
	[BWSdb].[dbo].[WSOM_Meetings]
;

SELECT
	*
FROM
	[BWSdb].[dbo].[ITR Customers]
;
SELECT
	*
FROM
	[BWSdb].[dbo].[ITR Pushes]
;

SELECT
	*
FROM
	[BWSdb].[dbo].[WSOM_Meetings]
;

SELECT
	*
FROM
	[BWSdb].[dbo].[WSOM_MeetingNotes]
;

SELECT
	[O].[WO#],
	[O].[WO Review Date],
	[O].[WO RevieweD]
FROM
	[BWSdb].[dbo].[Orders] [O]
WHERE
	[O].[WO#] IS NOT NULL
;

SELECT
	*
FROM
	[BWSdb].[dbo].[IT Requests]
;

SELECT TOP 1000
	[AS].[SupplierChName],
	[AS].[SupplierName],
	[AS].[SupShortName]
FROM
	[SysproCompanyA].[dbo].[ApSupplier] [AS]
;

SELECT
	[YT].[StockCode],
	[YT].[WO],
	COUNT(*) AS [Total],
	MIN([ID]) AS [FirstID],
	MAX([ID]) AS [LastID]
FROM
	[BWSdb].[dbo].[PROD_YellowTags] [YT]
WHERE
	[YT].[Active] = 1
GROUP BY
	[YT].[StockCode],
	[YT].[WO]
HAVING COUNT(*) > 1

;
/*
BEGIN TRAN;

	UPDATE
		[BWSdb].[dbo].[PROD_YellowTags]
	SET
		[Active] = 0
	WHERE
		[ID] IN (
			54, 55, 63, 217
		)

ROLLBACK;
COMMIT;
*/

SELECT
	*
FROM
	[BWSdb].[dbo].[ITR Customers]
WHERE
	[CustomerID] IN (
		4, 9, 13, 19
	)
	
SELECT
	[C].[Date],
	[O].[Quote#],
	[O].[Model No],
	[O].[Quote Date],
	[O].[Order Date],
	ISNULL([P].[Prod Date], [P].[Prod Date2]) AS [ProdDate],
	ISNULL(DATEDIFF(DAY, [O].[Quote Date], [O].[Order Date]), 0) AS [DaysBtwnQuoteOrder],
	ISNULL(DATEDIFF(DAY, [O].[Quote Date], ISNULL([P].[Prod Date], [P].[Prod Date2])), 0) AS [DaysBtwnQuoteProd],
	ISNULL(DATEDIFF(DAY, [O].[Order Date], ISNULL([P].[Prod Date], [P].[Prod Date2])), 0) AS [DaysBtwnOrderProd]
FROM
	[BWSdb].[dbo].[Calendar] [C]
LEFT JOIN
	[BWSdb].[dbo].[Orders] [O]
ON
	[C].[Date] = [O].[Quote Date]
LEFT JOIN
	[BWSdb].[dbo].[Production] [P]
ON
	[O].[WO#] = [P].[WO#]
WHERE
	[C].[Date] BETWEEN (SELECT MIN([Quote Date]) FROM [BWSdb].[dbo].[Orders]) AND (SELECT MAX([Quote Date]) FROM [BWSdb].[dbo].[Orders])
	--[O].[Decline/Rejected] = 4
ORDER BY
	[C].[Date]
;

SELECT
	*
FROM
	[BWSdb].[dbo].[Orders] [O]
WHERE
	([O].[Order Date] = '2025-09-15')
	OR ([O].[WO#] = 10017229)