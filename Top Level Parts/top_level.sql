--USE SysproCompanyA
--GO

--SELECT * FROM [WipMaster] WITH (NOLOCK) ORDER BY [Job] DESC;
--SELECT * FROM [MrpJobMaster] WITH (NOLOCK) ORDER BY [Job] DESC;
--SELECT * FROM [WipJobAllLab] WITH (NOLOCK) ORDER BY [Job] DESC;
--SELECT * FROM [WipLabJnl] WITH (NOLOCK) ORDER BY [Job] DESC;
--SELECT * FROM [WipJobAllMat];


--USE BWSdb
--GO

--SELECT * FROM [Production]

-----------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------
USE SysproCompanyA
GO

DECLARE @WO AS VARCHAR(8);
SET @WO = '10014747';

SELECT
	[JobStartDate] AS [WipJobAllMat.JobStartDate],
	[WipJobAllMat].[Job] AS [WipJobAllMat.Job],
	[WipMaster].[Job] AS [WipMaster.Job],
	[WipJobAllMat].[StockCode] AS [WipMaster.StockCode],
	[WipJobAllMat].[StockDescription] AS [WipMaster.StockDescription],
	[WipMaster].[Complete] AS [WipMaster.Complete],
	[WipJobAllMat].[QtyIssued] AS [WipJobAllMat.QtyIssued],
	[WipMaster].[QtyToMake] AS [WipMaster.QtyToMake],
	*
FROM
	[WipJobAllMat] WITH (NOLOCK)
INNER JOIN
	[WipMaster] WITH (NOLOCK)
ON
	[WipJobAllMat].[StockCode] = [WipMaster].[StockCode] and [WipJobAllMat].[Warehouse] = [WipMaster].[Warehouse]
WHERE
	[WipJobAllMat].[Job] = @WO
ORDER BY
	[WipMaster].[JobStartDate] DESC
;