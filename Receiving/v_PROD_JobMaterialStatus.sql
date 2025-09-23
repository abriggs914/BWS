
-- 2025-09-23 14:23 - Avery Briggs
-- Master view to show all issued and un-issued parts.

CREATE VIEW [dbo].[v_PROD_JobMaterialStatus]
AS
	SELECT
		[WM].[Job],
		[WM].[Warehouse],
		[WM].[OperationOffset] AS [Operation],
		[WM].[StockCode],
		[WM].[StockDescription],
		[JP].[SumQtyIssued],
		[WM].[UnitQtyReqd],
		[WM].[AllocCompleted],
		(CASE 
			WHEN [WM].[AllocCompleted] = 'Y' THEN 1
			WHEN ISNULL([WM].[UnitQtyReqd],0) <= ISNULL([JP].[SumQtyIssued],0) THEN 1
			ELSE 0
		END) AS [IsSatisfied],
		(CASE 
			WHEN ISNULL([WM].[UnitQtyReqd],0) > ISNULL([JP].[SumQtyIssued],0) THEN 1 ELSE 0
		END) AS [StillMissing],
		[JP].[FirstTransaction],
		[JP].[LastTransaction]
	FROM 
		[SysproCompanyA].[dbo].[WipJobAllMat] [WM]
	LEFT JOIN (
		SELECT
			[JP].[Job],
			[JP].[MStockCode],
			[JP].[MWarehouse],
			SUM(ISNULL([JP].[MQtyIssued],0)) AS [SumQtyIssued],
			MIN([WJP].[TrnDateTime]) AS [FirstTransaction],
			MAX([WJP].[TrnDateTime]) AS [LastTransaction]
		FROM 
			[SysproCompanyA].[dbo].[WipJobPost] [JP]
		INNER JOIN 
			[SysproCompanyA].[dbo].[v_PROD_WipJobPostDateTime] [WJP]
		ON 
			([JP].[Job] = [WJP].[Job])
			AND ([JP].[MStockCode] = [WJP].[MStockCode])
			AND ([JP].[Line] = [WJP].[Line])
		WHERE
			[JP].[TrnType] <> 'L'
		GROUP BY
			[JP].[Job],
			[JP].[MStockCode],
			[JP].[MWarehouse]
	) [JP]
	ON
		([WM].[Job] = [JP].[Job])
		AND ([WM].[StockCode] = [JP].[MStockCode])
		AND ([WM].[Warehouse] = [JP].[MWarehouse])
	WHERE
		(ISNUMERIC(LEFT([WM].[Job],1)) = 1)
		AND ([WM].[Warehouse] <> '**')
;