
SELECT
	[Por].[PurchaseOrder] AS [PO]
	, [Por].[MStockCode] AS [PN]
	, 'B' AS [COMP]
FROM
    [SysproCompanyA].[dbo].[PorMasterDetail] [Por]
INNER JOIN (
SELECT '000000000030146' AS [PONum] UNION SELECT '000000000031050'
) AS [SrcA]
ON
	[Por].[PurchaseOrder] = [SrcA].[PONum]

UNION

SELECT
	[Por].[PurchaseOrder] AS [PO]
	, [Por].[MStockCode] AS [PN]
	, 'S' AS [COMP]
FROM
    [SysproCompanyS].[dbo].[PorMasterDetail] [Por]
INNER JOIN (
SELECT '000000000000030' AS [PONum] UNION SELECT '000000000000046'
) AS [SrcA]
ON
	[Por].[PurchaseOrder] = [SrcA].[PONum]