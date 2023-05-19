USE SysproCompanyS
GO


SELECT
	*
	, REPLACE(LTRIM(REPLACE([A].[PurchaseOrder], '0', ' ')), ' ', '0')
FROM
	[PorMasterDetail] AS [A]
;
	


SELECT
	A.PurchaseOrder
	, B.[Purchase Order]
	, *
FROM
	[PorMasterDetail] AS [A]
INNER JOIN
	[BWSdb].[dbo].[OrdersV2] AS [B]
ON
	REPLACE(LTRIM(REPLACE([A].[PurchaseOrder], '0', ' ')), ' ', '0') = [B].[Purchase Order] collate Latin1_General_BIN
WHERE
	LEFT(RIGHT(CAST([B].[PO Date] AS NVARCHAR(MAX)), 12), 2) <> '20'
;
