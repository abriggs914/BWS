
DECLARE @wo NVARCHAR(MAX) = '10017082';
SELECT * FROM [BWSdb].[dbo].[Orders] WHERE CAST([WO#] AS NVARCHAR(MAX)) = @wo;
SELECT * FROM [BWSdb].[dbo].[Orders] WHERE [WO#] = @wo;
SELECT
	[M].*
	/*
	'Parts Left' AS [T]
	,[P].[TrnDate]
	,[M].[OperationOffset]
	,[P].[LOperation]
	,[M].[StockCode]
	,[P].[MStockCode]
	,[P].*
	,[M].*
	--,[J].*
	*/
FROM
	[SysproCompanyA].[dbo].[WipJobAllMat] [M]
WHERE
	[M].[Job] = @wo
	
SELECT * FROM [SysproCompanyA].[dbo].[WipJobPost] WHERE [Job] = @wo
SELECT * FROM [SysproCompanyA].[dbo].[WipJobAllLab] WHERE [Job] = @wo
SELECT * FROM [SysproCompanyA].[dbo].[WipJobAllMat] WHERE [Job] = @wo
SELECT
	*
FROM [SysproCompanyA].[dbo].[WipJobAllMat] [M] WHERE [Job] = @wo

----------------------------------------------------------------------

SELECT
	[P].[LWorkCentre]
	,[P].[LWorkCentreDesc]
	,[P].[LOperation]
	--,*
FROM
	[SysproCompanyA].[dbo].[WipJobPost] [P]
WHERE
	ISNULL([P].[LWorkCentre], '') <> ''
	AND ISNULL([P].[LWorkCentreDesc], '') <> ''
	AND ISNULL([P].[LOperation], -1) <> -1
	AND LEFT(ISNULL([P].[Job], ''), 1) = '1'
	AND (YEAR([P].[TrnDate]) >= (YEAR(GETDATE()) - 1))
GROUP BY
	[P].[LWorkCentre]
	,[P].[LWorkCentreDesc]
	,[P].[LOperation]
ORDER BY
	[P].[LOperation]
	,[P].[LWorkCentreDesc]

--------------------------------------------------------------------------

SELECT
	[L].[WorkCentre]
	,[L].[WorkCentreDesc]
	,[L].[Operation]
	--,*
FROM
	[SysproCompanyA].[dbo].[WipJobAllLab] [L]
WHERE
	ISNULL([L].[WorkCentre], '') <> ''
	AND ISNULL([L].[WorkCentreDesc], '') <> ''
	AND ISNULL([L].[Operation], -1) <> -1
	AND LEFT(ISNULL([L].[Job], ''), 1) = '1'
	AND (YEAR([L].[ActualFinishDate]) >= (YEAR(GETDATE()) - 1))
GROUP BY
	[L].[WorkCentre]
	,[L].[WorkCentreDesc]
	,[L].[Operation]
ORDER BY
	[L].[Operation]
	,[L].[WorkCentreDesc]

--------------------------------------------------------------------------

SELECT
	[M].[WorkCentre]
	,[M].[]
	,[M].[OperationOffset]
	--,*
FROM
	[SysproCompanyA].[dbo].[WipJobAllMat] [M]
WHERE
	ISNULL([M].[WorkCentre], '') <> ''
	AND ISNULL([M].[WorkCentreDesc], '') <> ''
	AND ISNULL([M].[OperationOffset], -1) <> -1
	AND LEFT(ISNULL([M].[Job], ''), 1) = '1'
	AND (YEAR([M].[ActualFinishDate]) >= (YEAR(GETDATE()) - 1))
GROUP BY
	[M].[WorkCentre]
	,[M].[WorkCentreDesc]
	,[M].[OperationOffset]
ORDER BY
	[M].[OperationOffset]
	,[M].[WorkCentreDesc]


SELECT
	*
FROM
	[BWSdb].[dbo].[]