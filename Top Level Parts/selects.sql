USE [SysproCompanyA]
GO
----/****** Object:  StoredProcedure [dbo].[sp_TopLevelWOSubsReport]    Script Date: 2021-10-04 4:45:22 PM ******/
----SET ANSI_NULLS ON
----GO
----SET QUOTED_IDENTIFIER ON
----GO

----ALTER PROCEDURE [dbo].[sp_TopLevelWOSubsReport]
--declare	@WO VARCHAR(8), @INCOMPLETEONLY BIT

--SET @INCOMPLETEONLY = 0;
--SET @WO = '10014841'
----AS
----BEGIN
--SELECT
--	0 AS [ph],
--	MIN([WipMaster].[JobStartDate]) AS [WipMaster.JobStartDate],
--	MIN([WipMaster].[Job]) AS [WipMaster.Job],
--	[WipJobAllMat].[StockCode] AS [WipMaster.StockCode],
--	[WipJobAllMat].[StockDescription] AS [WipMaster.StockDescription],
--	CAST(ROUND(AVG(QtyOnHand), 0) AS int) AS [QtyOnHand],
--	CAST(ROUND(AVG([QtyToMake]) * AVG([UnitQtyReqd]), 0) AS int) AS [QtyRequired],
--	CAST(ROUND(SUM([RunTimeIssued]), 2) AS decimal(14, 2)) AS [HrsIssued],
--	[WipMaster].[Complete] AS [WipMaster.Complete]
--FROM
--	[WipJobAllMat] WITH (NOLOCK)
--INNER JOIN
--	[WipMaster] WITH (NOLOCK)
--ON
--	[WipJobAllMat].[StockCode] = [WipMaster].[StockCode] and [WipJobAllMat].[Warehouse] = [WipMaster].[Warehouse]
--INNER JOIN
--	[WipJobAllLab]
--ON
--	[WipJobAllLab].[Job] = [WipMaster].[Job]
--INNER JOIN
--	[InvWarehouse]
--ON
--	[InvWarehouse].[StockCode] = [WipMaster].[StockCode] and [InvWarehouse].[Warehouse] = [WipMaster].[Warehouse]
--WHERE
--	[WipJobAllMat].[Job] = @WO
--	AND ((@INCOMPLETEONLY = 1 AND [WipMaster].[Complete] = 'N') OR @INCOMPLETEONLY = 0)
--	AND QtyOnHand = 0
--GROUP BY
--	[WipJobAllMat].[StockCode], [WipJobAllMat].[StockDescription], [WipMaster].[Complete]

--UNION ALL (
--	SELECT
--		1 AS [ph],
--		MAX([WipMaster].[JobStartDate]) AS [WipMaster.JobStartDate],
--		MIN([WipMaster].[Job]) AS [WipMaster.Job],
--		[WipJobAllMat].[StockCode] AS [WipMaster.StockCode],
--		[WipJobAllMat].[StockDescription] AS [WipMaster.StockDescription],
--		CAST(ROUND(AVG(QtyOnHand), 0) AS int) AS [QtyOnHand],
--		CAST(ROUND(AVG([QtyToMake]) * AVG([UnitQtyReqd]), 0) AS int) AS [QtyRequired],
--		CAST(ROUND(SUM([RunTimeIssued]), 2) AS decimal(14, 2)) AS [HrsIssued],
--		[WipMaster].[Complete] AS [WipMaster.Complete]
--	FROM
--		[WipJobAllMat] WITH (NOLOCK)
--	INNER JOIN
--		[WipMaster] WITH (NOLOCK)
--	ON
--		[WipJobAllMat].[StockCode] = [WipMaster].[StockCode] and [WipJobAllMat].[Warehouse] = [WipMaster].[Warehouse]
--	INNER JOIN
--		[WipJobAllLab]
--	ON
--		[WipJobAllLab].[Job] = [WipMaster].[Job]
--	INNER JOIN
--		[InvWarehouse]
--	ON
--		[InvWarehouse].[StockCode] = [WipMaster].[StockCode] and [InvWarehouse].[Warehouse] = [WipMaster].[Warehouse]
--	WHERE
--		[WipJobAllMat].[Job] = @WO
--		AND ((@INCOMPLETEONLY = 1 AND [WipMaster].[Complete] = 'N') OR @INCOMPLETEONLY = 0)
--		AND QtyOnHand > 0
--	GROUP BY
--		[WipJobAllMat].[StockCode], [WipJobAllMat].[StockDescription], [WipMaster].[Complete]
--	--ORDER BY
--	--	[WipMaster.JobStartDate]
--)
--ORDER BY
--	[ph], [WipMaster.JobStartDate], [WipJobAllMat].[StockCode]
----END



--INNER JOIN
--	[WipJobAllLab] WITH (NOLOCK)
--ON
--	[WipJobAllLab].[Job] = [WipMaster].[Job]
--INNER JOIN
--	[InvWarehouse] WITH (NOLOCK)
--ON
--	[InvWarehouse].[StockCode] = [WipMaster].[StockCode] and [InvWarehouse].[Warehouse] = [WipMaster].[Warehouse]
















--declare	@WO VARCHAR(8), @INCOMPLETEONLY BIT

--SET @INCOMPLETEONLY = 0;
--SET @WO = '10014841'


--SELECT
--	CAST(ROUND(AVG([InvWarehouse].[QtyOnHand]), 0) AS int) AS [QtyOnHand],
--	*
--FROM (
--	SELECT
--		[WipJobAllMat].[StockCode] AS [WipMaster.StockCode],
--		[WipMaster].[Job] AS [WipMaster.Job],
--		[WipJobAllMat].[StockDescription] AS [WipMaster.StockDescription],
--		[WipMaster].[Warehouse] as [WipMaster.Warehouse]
--	FROM
--		[WipJobAllMat] WITH (NOLOCK)
--	INNER JOIN
--		[WipMaster] WITH (NOLOCK)
--	ON
--		[WipJobAllMat].[StockCode] = [WipMaster].[StockCode] and [WipJobAllMat].[Warehouse] = [WipMaster].[Warehouse]
--	WHERE
--		[WipJobAllMat].[Job] = @WO
--		AND ((@INCOMPLETEONLY = 1 AND [WipMaster].[Complete] = 'N') OR @INCOMPLETEONLY = 0)
--	GROUP BY
--		[WipJobAllMat].[StockCode], [WipJobAllMat].[StockDescription], [WipMaster].[Job], [WipMaster].[Warehouse]
--) AS [SRC]
--INNER JOIN
--	[WipJobAllLab] WITH (NOLOCK)
--ON
--	[WipJobAllLab].[Job] = [SRC].[WipMaster.Job]
--INNER JOIN
--	[InvWarehouse] WITH (NOLOCK)
--ON
--	[InvWarehouse].[StockCode] = [SRC].[WipMaster.StockCode] and [InvWarehouse].[Warehouse] = [SRC].[WipMaster.Warehouse]






















declare	@WO VARCHAR(8), @INCOMPLETEONLY BIT

SET @INCOMPLETEONLY = 0;
SET @WO = '10014841'

SELECT
	SUM([CQtyOnHand]) AS [CQtyOnHand],
	MIN([WipMaster.Job]) AS [WipMaster.Job],
	[WipMaster.StockCode],
	[WipMaster.StockDescription]
FROM (
	SELECT
		CAST(ROUND([InvWarehouse].[QtyOnHand], 0) AS int) AS [CQtyOnHand],
		[WipMaster.StockCode],
		[WipMaster.Job],
		[WipMaster.StockDescription],
		[WipMaster.Warehouse],
		[WipMaster.Complete]
		--, *
	FROM (
		SELECT
			[WipJobAllMat].[StockCode] AS [WipMaster.StockCode],
			[WipMaster].[Job] AS [WipMaster.Job],
			[WipJobAllMat].[StockDescription] AS [WipMaster.StockDescription],
			[WipMaster].[Warehouse] as [WipMaster.Warehouse],
			[WipMaster].[Complete] AS [WipMaster.Complete]
		FROM
			[WipJobAllMat] WITH (NOLOCK)
		INNER JOIN
			[WipMaster] WITH (NOLOCK)
		ON
			[WipJobAllMat].[StockCode] = [WipMaster].[StockCode] and [WipJobAllMat].[Warehouse] = [WipMaster].[Warehouse]
		WHERE
			[WipJobAllMat].[Job] = @WO
			AND ((@INCOMPLETEONLY = 1 AND [WipMaster].[Complete] = 'N') OR @INCOMPLETEONLY = 0)
		GROUP BY
			[WipJobAllMat].[StockCode], [WipJobAllMat].[StockDescription], [WipMaster].[Job], [WipMaster].[Warehouse], [WipMaster].[Complete]
	) AS [SRC]
	INNER JOIN
		[WipJobAllLab] WITH (NOLOCK)
	ON
		[WipJobAllLab].[Job] = [SRC].[WipMaster.Job]
	INNER JOIN
		[InvWarehouse] WITH (NOLOCK)
	ON
		[InvWarehouse].[StockCode] = [SRC].[WipMaster.StockCode] and [InvWarehouse].[Warehouse] = [SRC].[WipMaster.Warehouse]
) AS [SRC2]
GROUP BY
	[WipMaster.StockCode], [WipMaster.StockDescription]