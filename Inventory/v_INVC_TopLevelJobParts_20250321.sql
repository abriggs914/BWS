
USE [SysproCompanyA]
GO
;

-- 2025-03-21 1630 - Avery Briggs, James Crawford
-- A collection of Top level WO#s and the First layer of StockCodes for Parts and Sub-Jobs.

--ALTER VIEW [dbo].[v_INVC_TopLevelJobParts] AS
SELECT
	[WM].[Job]
	,ISNULL([P].[Prod Date], [P].[Prod Date2]) AS [ProdDate]
	,ISNULL([P].[Date Completed], [WM].[ActCompleteDate]) AS [ActEstCompleteDate]
	,[WM].[StockCode]
	,[JM].[StockCode] AS [SubStockCode_0]
	,[IM].[PartCategory]
FROM
	[SysproCompanyA].[dbo].[WipMaster] [WM] 
INNER JOIN
	[BWSdb].[dbo].[Orders] [O] 
ON
	[WM].[Job] = CAST([O].[WO#] AS NVARCHAR(MAX))
INNER JOIN
	[BWSdb].[dbo].[Production] [P] 
ON
	[O].[Quote#] = [P].[Quote#]
INNER JOIN
	[SysproCompanyA].[dbo].[WipJobAllMat] [JM] 
ON
	[WM].[Job] = [JM].[Job]
INNER JOIN (
	SELECT
		[WM].[Job]
	FROM
		[SysproCompanyA].[dbo].[WipMaster] [WM] 
	INNER JOIN
		[BWSdb].[dbo].[Orders] [O] 
	ON
		[WM].[Job] = CAST([O].[WO#] AS NVARCHAR(MAX))
	WHERE
		[O].[Date Declined] IS NULL
) AS [Src]
ON
	[WM].[Job] = [Src].[Job]
LEFT JOIN
	[SysproCompanyA].[dbo].[InvMaster] [IM] 
ON
	[WM].[StockCode] = [IM].[StockCode]
WHERE
	([O].[Date Declined] IS NULL)
;
