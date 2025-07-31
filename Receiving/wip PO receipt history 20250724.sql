DECLARE @p NVARCHAR(15) = RIGHT('00000000000000' + '149218', 15)
SELECT
	[P].[PurchaseOrder],
	[MLastReceiptDat],
	[P].[MStockCode],
	[P].[MStockDes],
	[P].[MStockingUom],
	[P].[MOrderQty],
	[P].[MOrderUom],
	[P].[MReceivedQty],
	--MAX([MLastReceiptDat]) AS [MaxLastReceiptDate]
	(CASE WHEN ([P].[MOrderQty] - [P].[MReceivedQty]) <= 0 THEN 1 ELSE 0 END) AS [ReceivedTotally]
FROM
	[SysproCompanyA].[dbo].[PorMasterDetail] [P]
WHERE
	[P].[PurchaseOrder] = @p


DECLARE @poIsGood TABLE ([ID] INT IDENTITY(0, 1), [PO] NVARCHAR(255), [AllQtyMet] INT);
INSERT INTO @poIsGood ([PO], [AllQtyMet])
SELECT 
    [P].[PurchaseOrder],
    CASE 
        WHEN MIN(CASE WHEN [P].[MReceivedQty] < [P].[MOrderQty] THEN 0 ELSE 1 END) = 1 
        THEN 1
        ELSE 0
    END AS [AllQtyMet]
FROM [SysproCompanyA].[dbo].[PorMasterDetail] [P]
GROUP BY [P].[PurchaseOrder];


SELECT
	*
FROM
	[BWSdb].[dbo].[REC_POReceivedSubs] [S]
WHERE
	([S].[Active] = 1)

SELECT
	SUM([I].[LabourEstimate]),
	--PRODUCT([I].[LabourEstimate]),
	--EXP(SUM(LOG([I].[LabourEstimate]))) AS Product
	CONCAT([I].[Request]) AS [A]
FROM
	[BWSdb].[dbo].[IT Requests] [I]
GROUP BY
	[I].[RequestedBy]

SELECT
	[P].[PurchaseOrder],
	MAX([MLastReceiptDat]) AS [MaxLastReceiptDate],
	CASE 
		WHEN MIN(CASE WHEN [P].[MReceivedQty] < [P].[MOrderQty] THEN 0 ELSE 1 END) = 1 
		THEN 1
		ELSE 0
	END AS [AllQtyMet]
FROM
	[SysproCompanyA].[dbo].[PorMasterDetail] [P]
WHERE
	[PurchaseOrder] = '000000000147100'
GROUP BY
	[PurchaseOrder]

SELECT
	[P].[PurchaseOrder],
	[MLastReceiptDat],
	[MReceivedQty],
	[MOrderQty]
	/*,
	MAX([MLastReceiptDat]) AS [MaxLastReceiptDate],
	CASE 
		WHEN MIN(CASE WHEN [P].[MReceivedQty] < [P].[MOrderQty] THEN 0 ELSE 1 END) = 1 
		THEN 1
		ELSE 0
	END AS [AllQtyMet]*/
	,*
FROM
	[SysproCompanyA].[dbo].[PorMasterDetail] [P]
WHERE
	[PurchaseOrder] = '000000000149142'
SELECT
	*
FROM
	[SysproCompanyA].[dbo].[PorHistReceipt] [P]
WHERE
	[PurchaseOrder] = '000000000149475'
	

SELECT
	*
FROM
	[SysproCompanyA].[dbo].[PorHistReceipt] [P]
WHERE
	[PurchaseOrder] = '000000000149142'

SELECT
	--[PurchaseOrder],
	[JnlDate],
	COUNT([JnlDate])
FROM
	[SysproCompanyA].[dbo].[PorHistReceipt] [P]
WHERE
	[PurchaseOrder] = '000000000149142'
GROUP BY
	--[PurchaseOrder],
	[JnlDate]
HAVING
	COUNT([JnlDate]) > 1



SELECT
	[PurchaseOrder],
	[JnlDate]
FROM
	[SysproCompanyA].[dbo].[PorHistReceipt] [P]
WHERE
	[PurchaseOrder] = '000000000149206'
;

DECLARE @recPartData AS TABLE (
	[ID] INT IDENTITY(0, 1),
	[FirstDate] DATETIME, 
	[LastDate] DATETIME, 
	[PurchaseOrder] NVARCHAR(255),
	[JnlDate] DATETIME,
	[TotalPartsReceived] DECIMAL(18, 6)
)
SELECT
		MIN([JnlDate]) AS [FirstDate],
		MAX([JnlDate]) AS [LastDate],
		SUM([QtyReceived]) AS [TotalPartsReceived],
		[PurchaseOrder],
		[JnlDate]
	FROM
		[SysproCompanyA].[dbo].[PorHistReceipt] [P]
	WHERE
		[PurchaseOrder] = '000000000149206'
	GROUP BY
		[PurchaseOrder],
		[JnlDate]


SELECT
	MIN([FirstDate]) AS [LastDate],
	MAX([LastDate]) AS [LastDate],
	[PurchaseOrder],
	COUNT([JnlDate]) AS [TimesReceived],
	MIN([TotalPartsExpected]) AS [TotalPartsExpected],
	SUM([TotalPartsReceived]) AS [TotalPartsReceived]
FROM (
	SELECT
		MIN([JnlDate]) AS [FirstDate],
		MAX([JnlDate]) AS [LastDate],
		SUM([PM].[MOrderQty]) AS [TotalPartsExpected],
		SUM([QtyReceived]) AS [TotalPartsReceived],
		[P].[PurchaseOrder],
		[JnlDate]
	FROM
		[SysproCompanyA].[dbo].[PorHistReceipt] [P]
	LEFT JOIN
		[SysproCompanyA].[dbo].[PorMasterDetail] [PM]
	ON
		[P].[PurchaseOrder] = [PM].[PurchaseOrder]
	WHERE
		[P].[PurchaseOrder] = '000000000148915'
	GROUP BY
		[P].[PurchaseOrder],
		[JnlDate]
) AS [Src]
GROUP BY
	[PurchaseOrder],
	[TotalPartsReceived]
;


SELECT 
	[P].[PurchaseOrder],
	--[JnlDate],
	[PM].[MOrderQty]-- - [PM].[MReceivedQty]
	,[MOrderUom]
FROM
	[SysproCompanyA].[dbo].[PorHistReceipt] [P]
LEFT JOIN
	[SysproCompanyA].[dbo].[PorMasterDetail] [PM]
ON
	[P].[PurchaseOrder] = [PM].[PurchaseOrder]
WHERE
	([P].[PurchaseOrder] = '000000000148915')
	--AND ([MOrderQty] <> 0)
GROUP BY
	[P].[PurchaseOrder],
	--[JnlDate],
	[PM].[MOrderQty],
	[PM].[MReceivedQty],
	[PM].[MOrderUom]