USE SysproCompanyA
GO

/*
SELECT
	*
FROM
	[WipMaster]
ORDER BY
	[TimeStamp] DESC
;
*/

SELECT * FROM [SorDetail]
SELECT * FROM [SorMaster]


DECLARE @SD AS DATETIME;
DECLARE @ED AS DATETIME;
SET @SD = '2000-08-12';
SET @ED = '2021-08-19';
SELECT 
	[MStockCode],
	*
FROM
	[SorDetail]
INNER JOIN
	[SorMaster]
ON 
	[SorMaster].[SalesOrder] = [SorDetail].[SalesOrder]
INNER JOIN
	[WipJobAllMat]
ON
	[WipJobAllMat].[StockCode] = [MStockCode]
INNER JOIN
	[WipJobAllLab]
ON
	[WipJobAllLab].[Job] = [WipJobAllMat].[Job] AND [Operation] = [OperationOffset]
WHERE
	[PlannedStartDate] BETWEEN @SD AND @ED AND [StockCode] LIKE 'SP%'
/*
WHERE
	[PlannedStartDate] BETWEEN @SD AND @ED
	*/

SELECT	
	[StockCode],
	*
FROM
	[WipJobAllLab]
INNER JOIN
	[WipJobAllMat]
ON
	[WipJobAllLab].[Job] = [WipJobAllMat].[Job] AND [Operation] = [OperationOffset]
WHERE
	[PlannedStartDate] BETWEEN @SD AND @ED AND [StockCode] LIKE 'SP%'
;

/*
SELECT
	*
FROM
	[WipJobAllMat]
ORDER BY
	[TimeStamp] DESC
WHERE*/

USE SysproCompanyS
GO

/*
SELECT
	*
FROM
	[WipMaster]
ORDER BY
	[TimeStamp] DESC
;
*/


DECLARE @SD AS DATETIME;
DECLARE @ED AS DATETIME;
SET @SD = '2000-08-12';
SET @ED = '2021-08-19';

SELECT
	@SD AS [SD],
	@ED AS [ED]
;
SELECT	
	@SD AS [SD],
	@ED AS [ED],
	[PlannedStartDate],
	[StockCode],
	[WipJobAllLab].[Job]
FROM
	[WipJobAllLab]
INNER JOIN
	[WipJobAllMat]
ON
	[WipJobAllLab].[Job] = [WipJobAllMat].[Job] AND [Operation] = [OperationOffset]
WHERE
	[PlannedStartDate] BETWEEN @SD AND @ED AND [StockCode] LIKE 'SP%'
;

/*
SELECT
	*
FROM
	[WipJobAllMat]
ORDER BY
	[TimeStamp] DESC
WHERE*/