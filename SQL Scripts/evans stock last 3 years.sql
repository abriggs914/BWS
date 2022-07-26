
USE SysproCompanyA
GO


--SELECT * FROM [InvMaster]


SELECT 
	* 
FROM (
	SELECT
		[StockCode],
		MAX([EntryDate]) AS [MaxEntryDate]
	FROM
		[InvMovements] 
	GROUP BY 
		[StockCode]
) AS [Src]
LEFT JOIN
	[InvMaster]
ON
	[Src].[StockCode] = [InvMaster].[StockCode]
WHERE
	[MaxEntryDate] BETWEEN DATEADD(YEAR, -3, GETDATE()) AND GETDATE()



SELECT 
	* 
FROM (
	SELECT
		[StockCode],
		MAX([EntryDate]) AS [MaxEntryDate]
	FROM
		[InvMovements] 
	GROUP BY 
		[StockCode]
) AS [Src]
LEFT JOIN
	[InvMaster]
ON
	[Src].[StockCode] = [InvMaster].[StockCode]
WHERE
	[MaxEntryDate] NOT BETWEEN DATEADD(YEAR, -3, GETDATE()) AND GETDATE()
--ORDER BY
--	(CASE WHEN  THEN ELSE END)
