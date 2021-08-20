
USE SysproCompanyA
GO

DECLARE @SD AS DATETIME;
DECLARE @ED AS DATETIME;
SET @SD = '2020-07-16';
SET @ED = '2021-08-20';
SELECT 
	[MStockCode],
	[Job],
	*
FROM
	[SorDetail]
INNER JOIN
	[SorMaster]
ON 
	[SorMaster].[SalesOrder] = [SorDetail].[SalesOrder]
WHERE
	[ReqShipDate] BETWEEN @SD AND @ED
	AND [MStockCode] LIKE 'SP%'
ORDER BY
	[SorDetail].[MStockCode]
;

SELECT 
	[MStockCode],
	[Job],
	*
FROM
	[SorDetail]
INNER JOIN
	[SorMaster]
ON 
	[SorMaster].[SalesOrder] = [SorDetail].[SalesOrder]
WHERE
	[OrderDate] BETWEEN @SD AND @ED
	AND [MStockCode] LIKE 'SP%'
ORDER BY
	[OrderDate] DESC
;


SELECT 
	[MStockCode],
	[WipMaster].[Job]
FROM
	[SorDetail]
INNER JOIN
	[SorMaster]
ON 
	[SorMaster].[SalesOrder] = [SorDetail].[SalesOrder]
INNER JOIN
	[WipMaster]
ON
	[WipMaster].[SalesOrder] = [SorDetail].[SalesOrder]
WHERE
	[OrderDate] BETWEEN @SD AND @ED
	AND [MStockCode] LIKE 'SP%'
ORDER BY
	[OrderDate] DESC
;







/*
INNER JOIN
	[WipJobAllMat]
ON
	[WipJobAllMat].[StockCode] = [MStockCode]
INNER JOIN
	[WipJobAllLab]
ON
	[WipJobAllLab].[Job] = [WipJobAllMat].[Job] AND [Operation] = [OperationOffset]
WHERE
	[PlannedStartDate] BETWEEN @SD AND @ED AND [StockCode] LIKE 'SP%'*/