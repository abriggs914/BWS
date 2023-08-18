USE SysproCompanyA
GO

DECLARE @sc AS NVARCHAR(MAX);
DECLARE @j AS NVARCHAR(MAX);
SELECT @sc = '40944446';
SELECT @j = '10016583';


SELECT
	'InvWarehouse' AS [T],
	*
FROM
	[InvWarehouse]
WHERE
	[StockCode] = @sc
;

SELECT
	'WipMaster' AS [T],
	*
FROM
	[WipMaster]
WHERE
	[StockCode] = @sc
;

SELECT
	'WipJobAllMat_A' AS [T],
	*
FROM
	[WipJobAllMat]
WHERE
	[StockCode] = @sc
	AND [Job] = @j
;

SELECT
	'WipJobAllMat_B' AS [T],
	*
FROM
	[WipJobAllMat]
WHERE
	[StockCode] = @sc
ORDER BY
	[Job]
;

SELECT
	'WipJobAllMat_C' AS [T],
	*
FROM
	[WipJobAllMat]
WHERE
	[StockCode] = @sc
	AND [Job] = '00023336'
ORDER BY
	[Job]
;

SELECT
	'WipJobAllMat_D' AS [T],
	*
FROM
	[WipJobAllMat]
WHERE
	[Job] = '00023336'
;




SELECT
	'WipJobAllMat_E' AS [T],
	*
FROM
	[WipJobAllMat] AS [Mat]
LEFT JOIN
	[WipMaster] AS [Wip]
ON
	[Mat].[Job] = [Wip].[Job]
WHERE
	[Mat].[StockCode] = @sc
ORDER BY
	[Mat].[Job]
;


SELECT
	'WipJobAllMLab' AS [T],
	*
FROM
	[WipJobAllLab]
WHERE
	[Job] = @j
;

SELECT
	'Orders' AS [T],
	*
FROM
	[BWSdb].[dbo].[Orders]
WHERE
	[ProductID] IS NULL
ORDER BY
	[Quote Date]
;