USE [SysproCompanyA]
GO

-- SALES TAKES QUOTE -- AND ORDER
--Sarah Create a WO using Quote Data from BWSdb



-- WO#
-- Parts

-- BWSdb [Orders]
-- 





SELECT TOP 10 * FROM [WipMaster] [WM] ORDER BY [WM].[JobTenderDate] DESC
SELECT TOP 10 * FROM [WipMaster] [WM] WHERE ISNULL([MasterJob], '') <> '' ORDER BY [WM].[JobTenderDate] DESC
-- [SysproCompanyA].[dbo].[WhmPickDetail]


-- List of all jobs not cancelled
SELECT
	*
FROM
	[SysproCompanyA].[dbo].[WipMaster] [WM] 
INNER JOIN
	[BWSdb].[dbo].[Orders] [O] 
ON
	[WM].[Job] = CAST([O].[WO#] AS NVARCHAR(MAX))
WHERE
	([O].[Date Declined] IS NULL)
	AND ([WM].[JobClassification] = 'TRA')
ORDER BY 
	[WM].[JobTenderDate] DESC
;

-- List of all jobs not cancelled
SELECT TOP 100
	[WM].[Job]
FROM
	[SysproCompanyA].[dbo].[WipMaster] [WM] 
INNER JOIN
	[BWSdb].[dbo].[Orders] [O] 
ON
	[WM].[Job] = CAST([O].[WO#] AS NVARCHAR(MAX))
WHERE
	([O].[Date Declined] IS NULL)
	AND ([WM].[JobClassification] = 'TRA')
ORDER BY 
	[WM].[JobTenderDate] DESC
;


-- List of all jobs and 1st layer of parts
SELECT
	[WM].[Job]
	,[WM].[StockCode]
	,[JM].[StockCode] AS [SubStockCode_0]
FROM
	[SysproCompanyA].[dbo].[WipMaster] [WM] 
INNER JOIN
	[BWSdb].[dbo].[Orders] [O] 
ON
	[WM].[Job] = CAST([O].[WO#] AS NVARCHAR(MAX))
INNER JOIN
	[SysproCompanyA].[dbo].[WipJobAllMat] [JM] 
ON
	[WM].[Job] = [JM].[Job]
INNER JOIN (
	SELECT --TOP 10000
		[WM].[Job]
	FROM
		[SysproCompanyA].[dbo].[WipMaster] [WM] 
	INNER JOIN
		[BWSdb].[dbo].[Orders] [O] 
	ON
		[WM].[Job] = CAST([O].[WO#] AS NVARCHAR(MAX))
	WHERE
		[O].[Date Declined] IS NULL
		--AND ([WM].[JobClassification] = 'TRA')
	/*ORDER BY 
		[WM].[JobTenderDate] DESC*/
) AS [Src]
ON
	[WM].[Job] = [Src].[Job]
WHERE
	([O].[Date Declined] IS NULL)
	AND ([WM].[JobClassification] = 'TRA')
ORDER BY 
	[WM].[JobTenderDate] DESC
;


