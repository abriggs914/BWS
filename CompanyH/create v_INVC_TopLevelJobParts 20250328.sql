
USE [SysproCompanyA]
GO
;

-- 2025-03-21 1630 - Avery Briggs, James Crawford
-- A collection of Top level WO#s and the First layer of StockCodes for Parts and Sub-Jobs.

--CREATE VIEW [dbo].[v_INVC_TopLevelJobParts] AS

	SELECT
		[JP0].*,
		[JP1].[Job] AS [SubJob_1],
		[JP1].[StockCode] AS [SubStockCode_1],
		[IM].[PartCategory]
	FROM
		[SysproCompanyA].[dbo].[v_INVC_TopLevelJobParts] [JP0]
	LEFT JOIN
		[SysproCompanyA].[dbo].[WipMaster] [WM]
	ON
		[JP0].[SubStockCode_0] = [WM].[StockCode]
		--AND ([JP0].[PartCategory] = 'M')
	LEFT JOIN
		[SysproCompanyA].[dbo].[WipJobAllMat] [JP1]
	ON
		[JP1].[Job] = [WM].[Job]
	INNER JOIN
		[SysproCompanyA].[dbo].[InvMaster] [IM]
	ON
		[JP1].[StockCode] = [IM].[StockCode]
		--AND ([IM].[PartCategory] = 'M')
	/*INNER JOIN
		[SysproCompanyA].[dbo].[InvMaster] [IM]
	ON
		[JP1].[StockCode] = [IM].[StockCode]*/
WHERE
	[JP0].[Job] = '10017231'
;
