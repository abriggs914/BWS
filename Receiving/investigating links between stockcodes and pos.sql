DECLARE @po AS NVARCHAR(MAX) = '149285';
DECLARE @sc AS NVARCHAR(MAX) = '2601010';
--SELECT * FROM [SysproCompanyA].[dbo].[PorControl] -- empty
--SELECT TOP 10000 * FROM [SysproCompanyA].[dbo].[GrnMaster] -- empty
--SELECT * FROM [SysproCompanyA].[dbo].[GrnMaster] WHERE [PurchaseOrder] LIKE '%' + @po + '%'
-- SELECT * FROM [SysproCompanyA].[dbo].[BpoMaster] WHERE [PurchaseOrder] LIKE '%' + @po + '%' -- empty
--SELECT * FROM [SysproCompanyA].[dbo].[BpoTransaction] WHERE [PurchaseOrder] LIKE '%' + @po + '%' -- empty
--SELECT * FROM [SysproCompanyA].[dbo].[GrnJournal] WHERE [PurchaseOrder] LIKE '%' + @po + '%' -- empty
--SELECT * FROM [SysproCompanyA].[dbo].[InvInspect] WHERE [PurchaseOrder] LIKE '%' + @po + '%' -- empty
SELECT * FROM [SysproCompanyA].[dbo].[PorMasterDetail] WHERE [PurchaseOrder] LIKE '%' + @po + '%' ORDER BY [MLastReceiptDat] DESC
SELECT * FROM [SysproCompanyA].[dbo].[MrpPoMasterDet] WHERE [PurchaseOrder] LIKE '%' + @po + '%'
SELECT * FROM [SysproCompanyA].[dbo].[PorHistReceipt] WHERE [PurchaseOrder] LIKE '%' + @po + '%'
SELECT * FROM [SysproCompanyA].[dbo].[GrnDetails] WHERE [PurchaseOrder] LIKE '%' + @po + '%'


SELECT * FROM [SysproCompanyA].[dbo].[WipJobPost] WHERE [MPurchaseOrder] LIKE '%' + @po + '%'

SELECT * FROM [SysproCompanyA].[dbo].[InvJournalDet] WHERE [PurchaseOrder] LIKE '%' + @po + '%'

---------------------------------------------------------------------------------------------


SELECT * FROM [SysproCompanyA].[dbo].[PorMasterDetail] WHERE [MStockCode] LIKE '%' + @sc + '%' ORDER BY [MLastReceiptDat] DESC


-- Outstanding POs for a specific StockCode
SELECT 
	'Outstanding POs for a specific StockCode' AS [T]
	,*
FROM 
	[SysproCompanyA].[dbo].[PorMasterDetail] 
WHERE 
	([MStockCode] LIKE '%' + @sc + '%')
	AND (ISNULL([MReceivedQty], 0) = 0) 
ORDER BY
	[MLatestDueDate]
;



SELECT * FROM [SysproCompanyA].[dbo].[MrpPoMasterDet] WHERE [MStockCode] LIKE '%' + @sc + '%'
--SELECT * FROM [SysproCompanyA].[dbo].[PorHistReceipt] WHERE [MStockCode] LIKE '%' + @sc + '%'
--SELECT * FROM [SysproCompanyA].[dbo].[GrnDetails] WHERE [MStockCode] LIKE '%' + @sc + '%'


SELECT * FROM [SysproCompanyA].[dbo].[WipJobPost] WHERE [MStockCode] LIKE '%' + @sc + '%'

--SELECT * FROM [SysproCompanyA].[dbo].[InvJournalDet] WHERE [MStockCode] LIKE '%' + @sc + '%'


--------------------------------------------------------------------

--SELECT [PurchaseOrder] FROM [SysproCompanyA].[dbo].[PorMasterDetail] GROUP BY [PurchaseOrder]



DECLARE @maxDays INT = 365;
-- Outstanding POs
SELECT 
	'Outstanding POs' AS [T]
	,[PurchaseOrder]
FROM 
	[SysproCompanyA].[dbo].[PorMasterDetail] 
WHERE 
	(ISNULL([MReceivedQty], 0) = 0) 
	AND (DATEDIFF(DAY, [MLatestDueDate], GETDATE()) <= @maxDays) 
GROUP BY 
	[PurchaseOrder]
;