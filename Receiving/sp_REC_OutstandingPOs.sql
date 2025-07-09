
USE BWSdb
GO

--2025-07-08 20:13 - abriggs - list of outstanding POs that are less than 1 year old

ALTER PROCEDURE [sp_REC_OutstandingPOs]
	@maxDays INT = 365
AS BEGIN
	-- Outstanding POs
	SELECT 
		CAST([PurchaseOrder] AS INT) AS [PurchaseOrder]
	FROM 
		[SysproCompanyA].[dbo].[PorMasterDetail] 
	WHERE 
		(ISNULL([MReceivedQty], 0) = 0) 
		AND (DATEDIFF(DAY, [MLatestDueDate], GETDATE()) <= @maxDays) 
	GROUP BY 
		[PurchaseOrder]
	;
END