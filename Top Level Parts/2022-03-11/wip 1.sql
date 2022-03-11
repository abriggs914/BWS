
DECLARE
	@WO VARCHAR(MAX),
	@INCOMPLETEONLY BIT,
	@PARTCATEGORY NVARCHAR(MAX)=NULL,
	@OPERATION NVARCHAR(MAX)=NULL,
	@WAREHOUSE NVARCHAR(MAX)=NULL,
	@MACHINE NVARCHAR(MAX)=NULL,
	@WORKCENTRE NVARCHAR(MAX)=NULL


--SET @WO = '10014747;10014748';
--SET @INCOMPLETEONLY = 0;
--SET @OPERATION='01;04;05';
--SET @WAREHOUSE='04;06';
--SET @PARTCATEGORY='M';
--SET @MACHINE='01;02';
--SET @WORKCENTRE='A;B';
SET @WO='10015476';
SET @INCOMPLETEONLY=1;
SET @PARTCATEGORY='M;B;S';
SET @OPERATION='03;04;05'
SET @WAREHOUSE='01';
SET @WORKCENTRE=NULL
SET @MACHINE=NULL;


DECLARE @wos AS TABLE([Job#] INT, [Job] NVARCHAR(MAX));
INSERT INTO @wos SELECT * FROM [BWSdb].[dbo].[split_string_idx](@wo, ';');




SELECT
		1 AS [ph],
		[WipMaster].[Job],
		'M' AS [Part Category],
		[Operation],
		MIN([WipMaster].[JobStartDate]) AS [WipMaster.JobStartDate],
		MIN([WipMaster].[Job]) AS [WipMaster.Job],
		[WipJobAllMat].[StockCode] AS [WipMaster.StockCode],
		[WipJobAllMat].[StockDescription] AS [WipMaster.StockDescription],
		CAST(ROUND((QtyOnHand), 0) AS int) AS [QtyOnHand],
		CAST(ROUND([QtyIssued], 0) AS int) AS [QtyIssued],
		CAST(ROUND([UnitQtyReqd], 0) AS int) AS [QtyRequired],
		CAST(ROUND(SUM([RunTimeIssued]), 2) AS decimal(14, 2)) AS [HrsIssued],
		(CASE WHEN (CAST(ROUND([UnitQtyReqd], 0) AS int)) - CAST(ROUND([QtyIssued], 0) AS int) <= 0 THEN 'Y' else 'N' END) AS [Complete],
		[WipMaster].[Warehouse] AS [Warehouse]
		--,[WipJobAllLab].[WorkCentre] AS [WorkCentre]
		--,[WipJobAllLab].[IMachine] AS [IMachine]
	FROM
		[WipJobAllMat] WITH (NOLOCK)
	INNER JOIN
		[WipMaster] WITH (NOLOCK)
	ON
		[WipJobAllMat].[StockCode] = [WipMaster].[StockCode] and [WipJobAllMat].[Warehouse] = [WipMaster].[Warehouse]
	INNER JOIN
		[WipJobAllLab]
	ON
		[WipJobAllLab].[Job] = [WipMaster].[Job]
	INNER JOIN
		[InvWarehouse]
	ON
		[InvWarehouse].[StockCode] = [WipMaster].[StockCode] and [InvWarehouse].[Warehouse] = [WipMaster].[Warehouse]
	WHERE
		[WipJobAllMat].[Job] IN (SELECT [Job] FROM @wos)
		AND (
			RIGHT([WipJobAllMat].[Job], 1) = '1' 
			OR RIGHT([WipJobAllMat].[Job], 1) = '7' 
			OR RIGHT([WipJobAllMat].[Job], 1) = '2'
		)
		AND ((@INCOMPLETEONLY = 1 AND [WipMaster].[Complete] = 'N') OR @INCOMPLETEONLY = 0)
		AND QtyOnHand > 0
	GROUP BY
		[WipMaster].[Job],
		[WipJobAllMat].[StockCode],
		[WipJobAllMat].[StockDescription],
		[WipMaster].[Warehouse]
		--,[WipJobAllLab].[WorkCentre]
		--,[WipJobAllLab].[IMachine]
	
		,[Operation]
		,[UnitQtyReqd]
		,[QtyIssued]
		,[QtyOnHand]
	--ORDER BY
	--	[WipMaster.JobStartDate]














	SELECT
		1 AS [ph],
		[WipMaster].[Job],
		'M' AS [Part Category],
		[Operation],
		MIN([WipMaster].[JobStartDate]) AS [WipMaster.JobStartDate],
		MIN([WipMaster].[Job]) AS [WipMaster.Job],
		[WipJobAllMat].[StockCode] AS [WipMaster.StockCode],
		[WipJobAllMat].[StockDescription] AS [WipMaster.StockDescription],
		CAST(ROUND((QtyOnHand), 0) AS int) AS [QtyOnHand],
		CAST(ROUND([QtyIssued], 0) AS int) AS [QtyIssued],
		CAST(ROUND([UnitQtyReqd], 0) AS int) AS [QtyRequired],
		CAST(ROUND(SUM([RunTimeIssued]), 2) AS decimal(14, 2)) AS [HrsIssued],
		(CASE WHEN (CAST(ROUND([UnitQtyReqd], 0) AS int)) - CAST(ROUND([QtyIssued], 0) AS int) <= 0 THEN 'Y' else 'N' END) AS [Complete],
		[WipMaster].[Warehouse] AS [Warehouse]
		--,[WipJobAllLab].[WorkCentre] AS [WorkCentre]
		--,[WipJobAllLab].[IMachine] AS [IMachine]
	FROM
		[WipJobAllMat] WITH (NOLOCK)
	LEFT JOIN
		[WipMaster] WITH (NOLOCK)
	ON
		[WipJobAllMat].[StockCode] = [WipMaster].[StockCode] and [WipJobAllMat].[Warehouse] = [WipMaster].[Warehouse]
	LEFT JOIN
		[WipJobAllLab]
	ON
		[WipJobAllLab].[Job] = [WipMaster].[Job]
	LEFT JOIN
		[InvWarehouse]
	ON
		[InvWarehouse].[StockCode] = [WipMaster].[StockCode] and [InvWarehouse].[Warehouse] = [WipMaster].[Warehouse]
	WHERE
		[WipJobAllMat].[Job] IN (SELECT [Job] FROM @wos)
		--AND (
		--	RIGHT([WipJobAllMat].[Job], 1) = '1' 
		--	OR RIGHT([WipJobAllMat].[Job], 1) = '7' 
		--	OR RIGHT([WipJobAllMat].[Job], 1) = '2'
		--)
		AND ((@INCOMPLETEONLY = 1 AND [WipMaster].[Complete] = 'N') OR @INCOMPLETEONLY = 0)
		AND QtyOnHand > 0
	GROUP BY
		[WipMaster].[Job],
		[WipJobAllMat].[StockCode],
		[WipJobAllMat].[StockDescription],
		[WipMaster].[Warehouse]
		--,[WipJobAllLab].[WorkCentre]
		--,[WipJobAllLab].[IMachine]
	
		,[Operation]
		,[UnitQtyReqd]
		,[QtyIssued]
		,[QtyOnHand]
	--ORDER BY
	--	[WipMaster.JobStartDate]