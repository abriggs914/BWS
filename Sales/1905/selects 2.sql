
USE SysproCompanyS
GO

SELECT
	[B].[SGQuote]
	, A.PurchaseOrder
	, B.[Purchase Order]
	, [PO Date]
	, [MLatestDueDate]
	, [MLastReceiptDat]
	, [MOrigDueDate]
	, [Quote Date]
	, [Order Date]
	, [Available Date]
	, [Delivery Date]
	, [Finish Date]
	, [Requested Delivery Date]
	, [Shipped Date]
	, [PDD]
	, [DateSecured]
	, [Date Declined]
	, *
FROM
	[PorMasterDetail] AS [A]
INNER JOIN
	[BWSdb].[dbo].[OrdersV2] AS [B]
ON
	REPLACE(LTRIM(REPLACE([A].[PurchaseOrder], '0', ' ')), ' ', '0') = [B].[Purchase Order] collate Latin1_General_BIN
WHERE
	LEFT(RIGHT(CAST([B].[PO Date] AS NVARCHAR(MAX)), 12), 2) <> '20'
ORDER BY
	[B].[SGQuote]
