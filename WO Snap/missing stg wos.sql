USE BWSdb
GO

DECLARE @wo1 NVARCHAR(MAX) = '10001496';
DECLARE @wo2 NVARCHAR(MAX) = '10001497';

SELECT
	*
FROM
	[Orders]
WHERE
	[WO#] IN (@wo1, @wo2)
SELECT
	*
FROM
	[OrdersV2]
WHERE
	[WO#] IN (@wo1, @wo2)
	
SELECT * FROM [SysproCompanyS].[dbo].[WipMaster] WHERE [Job] IN (@wo1, @wo2)
SELECT * FROM [SysproCompanyS].[dbo].[WipJobAllLab] WHERE [Job] IN (@wo1, @wo2)
SELECT * FROM [SysproCompanyS].[dbo].[WipJobAllMat] WHERE [Job] IN (@wo1, @wo2)

--------
SELECT [Job]
FROM [SysproCompanyS].[dbo].[WipJobAllLab] AS WipJobAllLab_STG
WHERE ([Job] IS NOT NULL) AND ([Job] <> '')
GROUP BY [Job]
ORDER BY [Job];
--------

SELECT [Job]
FROM [SysproCompanyS].[dbo].[WipJobAllLab] AS WipJobAllLab_STG
WHERE ([Job] IS NOT NULL) AND ([Job] <> '') AND ([Job] IN (@wo1, @wo2))
GROUP BY [Job]
ORDER BY [Job];

SELECT [Job]
FROM [SysproCompanyS].[dbo].[WipJobAllLab] AS WipJobAllLab_STG
WHERE [Job] IN (@wo1, @wo2)
GROUP BY [Job]
ORDER BY [Job];

SELECT [Job]
FROM [SysproCompanyS].[dbo].[WipJobAllMat] AS WipJobAllMat_STG
WHERE [Job] IN (@wo1, @wo2)
GROUP BY [Job]
ORDER BY [Job];

SELECT 
	[Job]
FROM
	[SysproCompanyS].[dbo].[WipJobAllLab] AS WipJobAllMat_STG
WHERE
	ISNULL([Job], '') <> ''
GROUP BY
	[Job]
UNION
	SELECT
		[WO#]
	FROM
		[OrdersV2]
	LEFT JOIN
		[SysproCompanyS].[dbo].[WipJobAllLab]
	ON
		[WipJobAllLab].[Job] = CAST([OrdersV2].[WO#] AS NVARCHAR(MAX))
	WHERE
		[WipJobAllLab].[Job] IS NULL
		AND [WO#] IS NOT NULL
ORDER BY
	[Job];









	-------------------
	SELECT 
	[Job]
FROM
[WipJobAllMat_STG]
WHERE
	IIF(ISNULL([Job]), "", [Job]) <> ""
GROUP BY
	[Job]
UNION
	SELECT
		[WO#]
	FROM
		[OrdersV2]
	LEFT JOIN
[WipJobAllLab]
	ON
		[WipJobAllLab].[Job] = [OrdersV2].[WO#]
	WHERE
		[WipJobAllLab].[Job] IS NULL
		AND [WO#] IS NOT NULL
ORDER BY
	[Job];