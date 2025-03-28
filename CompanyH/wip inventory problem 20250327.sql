SELECT
	*
FROM
	[SysproCompanyA].[dbo].[v_INVC_TopLevelJobParts] [JP0]
WHERE
	[JP0].[Job] = '10017231'

SELECT
	*
FROM (
	SELECT
		[JP0].*,
		[JP1].[Job] AS [SubJob_1],
		[JP1].[StockCode] AS [SubStockCode_1]
	FROM
		[SysproCompanyA].[dbo].[v_INVC_TopLevelJobParts] [JP0]
	INNER JOIN
		[SysproCompanyA].[dbo].[WipMaster] [WM]
	ON
		[JP0].[SubStockCode_0] = [WM].[StockCode]
	INNER JOIN
		[SysproCompanyA].[dbo].[WipJobAllMat] [JP1]
	ON
		[JP1].[Job] = [WM].[Job]
	WHERE
		[JP0].[Job] = '10017231'
) AS [Src]
/*
INNER JOIN
	[SysproCompanyA].[dbo].[WipMaster] [WM]
ON
	[Src].[SubStockCode_1] = [WM].[StockCode]
INNER JOIN
	[SysproCompanyA].[dbo].[WipJobAllMat] [JP1]
ON
	[JP1].[Job] = [WM].[Job]
*/
/*WHERE
	[JP0].[Job] = '10017231'