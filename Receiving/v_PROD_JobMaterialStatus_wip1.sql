SELECT TOP 2000
	'Material Posted - A' AS [T],
	[JP].[SumQtyIssued],
	[WM].[UnitQtyReqd],
	[WM].[AllocCompleted],
	(CASE WHEN ISNULL([WM].[UnitQtyReqd], 0) > ISNULL([JP].[SumQtyIssued], 0) THEN 0 ELSE 1 END) AS [Check],
	[JP].[Job],
	[JP].[MStockCode],
	[JP].[LOperation],
	[WM].[OperationOffset],
	[JP].*,
	[WM].*
FROM
	[SysproCompanyA].[dbo].[WipJobAllMat] [WM]
LEFT JOIN (
	SELECT
		[JP].[Job],
		[JP].[MStockCode],
		[JP].[LOperation],
		[JP].[MWarehouse],
		[JP].[TrnType],
		SUM([JP].[MQtyIssued]) AS [SumQtyIssued]
	FROM 
		[SysproCompanyA].[dbo].[WipJobPost] [JP]
	WHERE
		([JP].[TrnType] <> 'L')
		AND (LEFT([JP].[Job], 5) = '10017')
	GROUP BY
		[JP].[Job],
		[JP].[MStockCode],
		[JP].[LOperation],
		[JP].[MWarehouse],
		[JP].[TrnType]
) AS [JP]
ON
	([WM].[Job] = [JP].[Job])
	AND ([WM].[StockCode] = [JP].[MStockCode])
	AND ([WM].[Warehouse] = [JP].[MWarehouse])
	AND ([WM].[QtyIssued] = [JP].[SumQtyIssued])
WHERE
	([JP].[TrnType] <> 'L')
	AND (
		/*(LEFT([JP].[Job], 5) = '10014')
		OR
		(LEFT([JP].[Job], 5) = '10015')
		OR (LEFT([JP].[Job], 5) = '10016')
		OR*/
		(LEFT([JP].[Job], 5) = '10017')
	)
ORDER BY
	[JP].[Job],
	[JP].[MStockCode],
	[WM].[OperationOffset]
;


SELECT
	[JP].[Job],
	[JP].[MStockCode],
	[JP].[LOperation],
	SUM([JP].[MQtyIssued]) AS [SumQtyIssued]
FROM 
	[SysproCompanyA].[dbo].[WipJobPost] [JP]
WHERE
	([JP].[TrnType] <> 'L')
	AND (LEFT([JP].[Job], 5) = '10017')
GROUP BY
	[JP].[Job],
	[JP].[MStockCode],
	[JP].[LOperation]
;

SELECT TOP 2000
	'Material Posted - A' AS [T],
	[JP].[MQtyIssued],
	[WM].[UnitQtyReqd],
	[WM].[AllocCompleted],
	(CASE WHEN ISNULL([WM].[UnitQtyReqd], 0) > ISNULL([JP].[MQtyIssued], 0) THEN 0 ELSE 1 END) AS [Check],
	[JP].[Job],
	[JP].[MStockCode],
	[JP].[LOperation],
	[WM].[OperationOffset],
	[JP].*,
	[WM].*
FROM
	[SysproCompanyA].[dbo].[WipJobAllMat] [WM]
LEFT JOIN
	[SysproCompanyA].[dbo].[WipJobPost] [JP]
ON
	([WM].[Job] = [JP].[Job])
	AND ([WM].[StockCode] = [JP].[MStockCode])
	AND ([WM].[Warehouse] = [JP].[MWarehouse])
	AND ([WM].[QtyIssued] = [JP].[MQtyIssued])
WHERE
	([JP].[TrnType] <> 'L')
	AND (
		/*(LEFT([JP].[Job], 5) = '10014')
		OR
		(LEFT([JP].[Job], 5) = '10015')
		OR (LEFT([JP].[Job], 5) = '10016')
		OR*/
		(LEFT([JP].[Job], 5) = '10017')
	)
ORDER BY
	[JP].[Job],
	[JP].[MStockCode],
	[WM].[OperationOffset]
;

SELECT
	[JP].[Job],
	[JP].[MStockCode],
	[JP].[LOperation]
FROM
	[SysproCompanyA].[dbo].[WipJobPost] [JP]
WHERE
	([JP].[TrnType] <> 'L')
	AND (ISNULL([JP].[MStockCode], '') <> '')
GROUP BY
	[JP].[Job],
	[JP].[MStockCode],
	[JP].[LOperation]
ORDER BY
	[JP].[Job],
	[JP].[LOperation],
	[JP].[MStockCode]
;

SELECT TOP 2000
	'Material Posted - A' AS [T],
	[JP].[MQtyIssued],
	[JP].[Job],
	[JP].[MStockCode],
	[WJ].[Operation],
	[JP].[LOperation],
	[WJP].[TrnDateTime],
	[JP].[TrnDate],
	[WJ].[EntryDate],
	[JP].*,
	[WJ].*
FROM
	[SysproCompanyA].[dbo].[WipJobPost] [JP]
INNER JOIN
	[SysproCompanyA].[dbo].[WipLabJnl] [WJ]
ON
	([JP].[Journal] = [WJ].[Journal])
	
	--AND ([JP].[MStockCode] = [WJ].[StockCode])
	--AND ([JP].[Job] = [WJ].[Job])
	--AND ([JP].[TrnDate] = [WJ].[EntryDate])
LEFT JOIN
	[SysproCompanyA].[dbo].[v_PROD_WipJobPostDateTime] [WJP]
ON
	([JP].[Job] = [WJP].[Job])
	AND ([JP].[Line] = [WJP].[Line])
	AND ([JP].[MStockCode] = [WJP].[MStockCode])
WHERE
	([JP].[TrnType] <> 'L')
	AND (
		/*(LEFT([JP].[Job], 5) = '10014')
		OR
		(LEFT([JP].[Job], 5) = '10015')
		OR (LEFT([JP].[Job], 5) = '10016')
		OR*/
		(LEFT([JP].[Job], 5) = '10017')
	)
ORDER BY
	[JP].[Job],
	[JP].[MStockCode],
	[WJ].[Operation]

SELECT TOP 2000
	'Material Posted - A' AS [T],
	[JP].[MQtyIssued],
	[JP].[Job],
	[JP].[MStockCode],
	[WJ].[Operation],
	--[JP].[LOperation],
	[JP].*,
	[WJ].*
FROM
	[SysproCompanyA].[dbo].[WipJobPost] [JP]
LEFT JOIN
	[SysproCompanyA].[dbo].[WipLabJnl] [WJ]
ON
	([JP].[Journal] = [WJ].[Journal])
	AND ([JP].[TrnDate] = [WJ].[EntryDate])
WHERE
	([JP].[TrnType] <> 'L')
	AND ((LEFT([JP].[Job], 5) = '10014')
	OR (LEFT([JP].[Job], 5) = '10015')
	OR (LEFT([JP].[Job], 5) = '10016')
	OR (LEFT([JP].[Job], 5) = '10017'))
ORDER BY
	[JP].[Job],
	[JP].[MStockCode],
	[WJ].[Operation]

SELECT TOP 200000
	'Material Posted - A' AS [T],
	[JP].[MQtyIssued],
	[JP].[Job],
	[JP].[MStockCode],
	[WJ].[Operation],
	[JP].[LOperation],
	[JP].*,
	[WJ].*
FROM
	[SysproCompanyA].[dbo].[WipJobPost] [JP]
INNER JOIN
	[SysproCompanyA].[dbo].[WipLabJnl] [WJ]
ON
	([JP].[Journal] = [WJ].[Journal])
	AND ([JP].[Job] = [WJ].[Job])
WHERE
	/*(LEFT([JP].[Job], 5) = '10014')
	AND 
	*/([JP].[TrnType] <> 'L')
;

SELECT TOP 20000
	'Material Posted - B' AS [T],
	[JP].[MQtyIssued],
	[JP].[Job],
	[JP].[MStockCode],
	[JP].[LOperation],
	[WJ].[Operation],
	[JP].*
FROM
	[SysproCompanyA].[dbo].[WipJobPost] [JP]
INNER JOIN
	[SysproCompanyA].[dbo].[WipLabJnl] [WJ]
ON
	([JP].[Journal] = [WJ].[Journal])
	AND ([JP].[Job] = [WJ].[Job])
WHERE
	(LEFT([JP].[Job], 5) = '10014')
	AND ([JP].[TrnType] <> 'L')
;

SELECT TOP 20000
	'Material Posted - C' AS [T],
	[JP].[MQtyIssued],
	[WJM].[UnitQtyReqd],
	[JP].[Job],
	[WJM].[Job],
	[JP].[MStockCode],
	[WJM].[StockCode],
	[WJ].[Operation],
	[JP].[LOperation],
	[WJM].[OperationOffset],
	[JP].*
FROM
	[SysproCompanyA].[dbo].[WipJobPost] [JP]
INNER JOIN
	[SysproCompanyA].[dbo].[WipLabJnl] [WJ]
ON
	([JP].[Journal] = [WJ].[Journal])
	AND ([JP].[Job] = [WJ].[Job])
INNER JOIN
	[SysproCompanyA].[dbo].[WipJobAllMat] [WJM]  
ON
	([JP].[Job] = [WJM].[Job])
	AND ([JP].[MStockCode] = [WJM].[StockCode])
	AND ([WJ].[Operation] = [WJM].[OperationOffset])
/*WHERE
	[JP].[LOperation] <> 0
WHERE
	(LEFT([JP].[Job], 5) = '10014')*/
ORDER BY
	[JP].[Job],
	[WJ].[Operation]
;