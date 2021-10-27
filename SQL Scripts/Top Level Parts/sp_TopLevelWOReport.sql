USE SysproCompanyA
GO

ALTER PROCEDURE [dbo].[sp_TopLevelWOReport]
--DECLARE
	@WO VARCHAR(8), @INCOMPLETEONLY BIT
--SET @WO = '10014747';
--SET @INCOMPLETEONLY = 0;
AS
BEGIN

DECLARE @T TABLE ([ph] INT, [WipMaster.JobStartDate] DATETIME, [WipMaster.Job] NVARCHAR(100), [WipMaster.StockCode] NVARCHAR(MAX), [WipMaster.StockDescription] NVARCHAR(MAX), [QtyOnHand] INT, [QtyIssued] INT, [QtyRequired] INT, [HrsIssued] FLOAT, [Complete] VARCHAR(1))

INSERT INTO @T
EXEC [dbo].[sp_TopLevelWOSubsReport] @WO=@WO, @INCOMPLETEONLY=@INCOMPLETEONLY


SELECT * FROM @T
UNION ALL
SELECT 
	(CASE WHEN [QtyOnHand] = 0 THEN 0 ELSE 1 END) AS [ph],
	[MLatestDueDate] AS [WipMaster.JobStartDate],
	'PO#' + [PurchaseOrder] AS [WipMaster.Job],
	[MStockCode] AS [WipMaster.StockCode],
	[A].[StockDescription] AS [WipMaster.StockDescription],
	[QtyOnHand],
	[QtyIssued],
	[UnitQtyReqd] AS [QtyRequired],
	[RunTimeIssued] AS [HrsIssued],
	[Complete] AS [Complete]
FROM (
SELECT
	'THIS ONE' as [MARKER],
	[WipJobAllMat].*
FROM
	[WipJobAllMat]
LEFT JOIN
	@T
ON
	[@T].[WipMaster.StockCode] = [WipJobAllMat].[StockCode]
WHERE
	[Job] = @WO AND [@T].[WipMaster.StockCode] IS NULL
) AS [A]
INNER JOIN (
	SELECT * FROM (
	SELECT ROW_NUMBER() OVER (
		PARTITION BY [MStockCode]
		ORDER BY [MLatestDueDate] DESC
	) AS [Row#],
	[PurchaseOrder], [MStockCode], [MLatestDueDate], [PorMasterDetail].[MWarehouse] FROM [PorMasterDetail] WITH (NOLOCK)
	) AS [Src]
	INNER JOIN
		[InvWarehouse]
	ON
		[InvWarehouse].[StockCode] = [Src].[MStockCode] and [InvWarehouse].[Warehouse] = [Src].[MWarehouse]
	WHERE
		[Row#] = 1
	) AS [B]
ON
	[A].[StockCode] = [B].[MStockCode]
INNER JOIN
	[WipMaster]
ON
	[A].[Job] = [WipMaster].[Job]
INNER JOIN (
	SELECT [Job], SUM([RunTimeIssued]) AS [RunTimeIssued] FROM
	[WipJobAllLab]
	GROUP BY
		[Job]
) AS [C]
ON
	[A].[Job] = [C].[Job]
WHERE
	((@INCOMPLETEONLY = 1 AND [WipMaster].[Complete] = 'N') OR @INCOMPLETEONLY = 0)
ORDER BY
	[ph], [Complete], [WipMaster.JobStartDate], [WipMaster.StockCode]
END