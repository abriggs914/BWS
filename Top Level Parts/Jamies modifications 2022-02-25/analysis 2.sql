USE [SysproCompanyA]
GO
/****** Object:  StoredProcedure [dbo].[sp_TopLevelWOReportJamieMulti]    Script Date: 2022-03-01 8:26:14 AM ******/
--SET ANSI_NULLS ON
--GO
--SET QUOTED_IDENTIFIER ON
--GO

--ALTER PROCEDURE [dbo].[sp_TopLevelWOReportJamieMulti]
DECLARE
	@WO VARCHAR(MAX),
	@INCOMPLETEONLY BIT,
	@PARTCATEGORY NVARCHAR(MAX)=NULL,
	@OPERATION NVARCHAR(MAX)=NULL,
	@WAREHOUSE NVARCHAR(MAX)=NULL

	
SET @WO = '10014747;10014748';
SET @INCOMPLETEONLY = 0;
SET @OPERATION='01;04;05';
SET @WAREHOUSE='04;06'
SET @PARTCATEGORY='M;B;S'

-- WIDE OPEN
SET @WO = '10014747;10014748';
SET @WO = '10014747';
SET @INCOMPLETEONLY = 0;
SET @OPERATION=NULL;
SET @WAREHOUSE=NULL;
SET @PARTCATEGORY=NULL;


--AS
--BEGIN

DECLARE @wos AS TABLE([Job#] INT, [Job] NVARCHAR(MAX));
INSERT INTO @wos SELECT * FROM [BWSdb].[dbo].[split_string_idx](@wo, ';');

--DECLARE @T TABLE (
--	[ph] INT,
--	[WO] NVARCHAR(MAX),
--	[Part Category] CHAR(1),
--	[Operation] INT,
--	[WipMaster.JobStartDate] DATETIME,
--	[WipMaster.Job] NVARCHAR(100),
--	[WipMaster.StockCode] NVARCHAR(MAX),
--	[WipMaster.StockDescription] NVARCHAR(MAX),
--	[QtyOnHand] INT,
--	[QtyIssued] INT,
--	[QtyRequired] INT,
--	[HrsIssued] FLOAT,
--	[Complete] VARCHAR(1),
--	[Warehouse] NVARCHAR(MAX)
--)











--INSERT INTO @T
--EXEC [dbo].[sp_TopLevelWOSubsReportJamie] @WO=@WO, @INCOMPLETEONLY=@INCOMPLETEONLY, @PARTCATEGORY=@PARTCATEGORY, @OPERATION=@OPERATION, @WAREHOUSE=@WAREHOUSE
SELECT

	[WipMaster].[Job] AS [A],
	[WipJobAllLab].[Job] AS [B],
	[WipJobAllMat].[Job] AS [C],
	--[InvWarehouse].[Job] AS [D],
	[WipMaster].[StockCode] AS [E],
	--[WipJobAllLab].[StockCode] AS [F],
	[WipJobAllMat].[StockCode] AS [G],
	[InvWarehouse].[StockCode] AS [H],

	[WipMaster].[Warehouse] AS [I],
	--[WipJobAllLab].[Warehouse] AS [J],
	[WipJobAllMat].[Warehouse] AS [K],
	[InvWarehouse].[Warehouse] AS [L],

	--[WipMaster].[Bin] AS [M],
	--[WipJobAllLab].[Bin] AS [N],
	[WipJobAllMat].[Bin] AS [O],
	--[InvWarehouse].[Bin] AS [P],

	--[WipMaster].[Operation] AS [Q],
	[WipJobAllLab].[Operation] AS [R],
	[WipJobAllMat].[OperationOffset] AS [S],
	--[InvWarehouse].[Operationoff] AS [T],

	--[WipMaster].[QtyIssued] AS [U],
	--[WipJobAllLab].[QtyIssued] AS [V],
	[WipJobAllMat].[QtyIssued] AS [W],
	--[InvWarehouse].[QtyIssued] AS [X],

	--[WipMaster].[ValueIssued] AS [Y],
	[WipJobAllLab].[ValueIssued] AS [Z],
	[WipJobAllMat].[ValueIssued] AS [AA],
	--[InvWarehouse].[ValueIssued] AS [AB],

	--[WipMaster].[UnitQtyReqdEnt] AS [AC],
	--[WipJobAllLab].[UnitQtyReqdEnt] AS [AD],
	[WipJobAllMat].[UnitQtyReqdEnt] AS [AE],
	--[InvWarehouse].[UnitQtyReqdEnt] AS [AF],

	--[WipMaster].[QtyIssuedEnt] AS [AG],
	--[WipJobAllLab].[QtyIssuedEnt] AS [AH],
	[WipJobAllMat].[QtyIssuedEnt] AS [AI],
	--[InvWarehouse].[QtyIssuedEnt] AS [AJ],

	[WipMaster].[JobDescription] AS [AK],
	--[WipJobAllLab].[JobDescription] AS [AL],
	--[WipJobAllMat].[JobDescription] AS [AM],
	--[InvWarehouse].[JobDescription] AS [AN],

	[WipMaster].[StockDescription] AS [AO],
	--[WipJobAllLab].[StockDescription] AS [AP],
	[WipJobAllMat].[StockDescription] AS [AQ],
	--[InvWarehouse].[StockDescription] AS [AR],

	[WipMaster].[Complete] AS [AS],
	--[WipJobAllLab].[Complete] AS [AT],
	--[WipJobAllMat].[Complete] AS [AU],
	--[InvWarehouse].[Complete] AS [AV],


	--[WipMaster].[IMachine] AS [AW],
	[WipJobAllLab].[IMachine] AS [AX],
	--[WipJobAllMat].[IMachine] AS [AY],
	--[InvWarehouse].[IMachine] AS [AZ],

	--[WipMaster].[OperCompleted] AS [BA],
	[WipJobAllLab].[OperCompleted] AS [BB],
	--[WipJobAllMat].[OperCompleted] AS [BC],
	--[InvWarehouse].[OperCompleted] AS [BD],

	--[WipMaster].[WorkCentre] AS [BA],
	[WipJobAllLab].[WorkCentre] AS [BB],
	--[WipJobAllMat].[WorkCentre] AS [BC],
	--[InvWarehouse].[WorkCentre] AS [BD],

	--[WipMaster].[QtyOnHand] AS [BE],
	--[WipJobAllLab].[QtyOnHand] AS [BF],
	--[WipJobAllMat].[QtyOnHand] AS [BG],
	[InvWarehouse].[QtyOnHand] AS [BH],

	--[WipMaster].[DefaultBin] AS [BE],
	--[WipJobAllLab].[DefaultBin] AS [BF],
	--[WipJobAllMat].[DefaultBin] AS [BG],
	[InvWarehouse].[DefaultBin] AS [BH],

	*

	--0 AS [ph],
	--[WipMaster].[Job],
	--'M' AS [Part Category],
	--[Operation],
	--MAX([WipMaster].[JobStartDate]) AS [WipMaster.JobStartDate],
	--MAX([WipMaster].[Job]) AS [WipMaster.Job],
	--[WipJobAllMat].[StockCode] AS [WipMaster.StockCode],
	--[WipJobAllMat].[StockDescription] AS [WipMaster.StockDescription],
	--CAST(ROUND((QtyOnHand), 0) AS INT) AS [QtyOnHand],
	--CAST(ROUND([QtyIssued], 0) AS INT) AS [QtyIssued],
	--CAST(ROUND([UnitQtyReqd], 0) AS INT) AS [QtyRequired],
	--CAST(ROUND(SUM([RunTimeIssued]), 2) AS decimal(14, 2)) AS [HrsIssued],
	--(CASE WHEN (CAST(ROUND(([UnitQtyReqd]), 0) AS INT)) - CAST(ROUND(([QtyIssued]), 0) AS INT) <= 0 THEN 'Y' ELSE 'N' END) AS [Complete],
	--[WipMaster].[Warehouse] AS [Warehouse]
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
	AND ((@INCOMPLETEONLY = 1 AND [WipMaster].[Complete] = 'N') OR @INCOMPLETEONLY = 0)
	AND QtyOnHand = 0
--GROUP BY
--	[WipMaster].[Job],
--	[WipJobAllMat].[StockCode],
--	[WipJobAllMat].[StockDescription],
--	[WipMaster].[Warehouse]
	
--	,[Operation]
--	,[UnitQtyReqd]
--	,[QtyIssued]
--	,[QtyOnHand]

--SELECT * FROM @T







SELECT

	[WipJobAllMat].[Job],
	--[InvWarehouse].[Job],
	[WipMaster].[StockCode] AS [D]
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
	AND ((@INCOMPLETEONLY = 1 AND [WipMaster].[Complete] = 'N') OR @INCOMPLETEONLY = 0)
	AND QtyOnHand = 0
GROUP BY
	[WipJobAllMat].[Job],
	[WipMaster].[StockCode]
	
UNION ALL (
	SELECT

	[WipJobAllMat].[Job],
	--[InvWarehouse].[Job],
	[WipMaster].[StockCode] AS [D]
		--1 AS [ph],
		--[WipMaster].[Job],
		--'M' AS [Part Category],
		--[Operation],
		--MAX([WipMaster].[JobStartDate]) AS [WipMaster.JobStartDate],
		--MAX([WipMaster].[Job]) AS [WipMaster.Job],
		--[WipJobAllMat].[StockCode] AS [WipMaster.StockCode],
		--[WipJobAllMat].[StockDescription] AS [WipMaster.StockDescription],
		--CAST(ROUND((QtyOnHand), 0) AS int) AS [QtyOnHand],
		--CAST(ROUND([QtyIssued], 0) AS int) AS [QtyIssued],
		--CAST(ROUND([UnitQtyReqd], 0) AS int) AS [QtyRequired],
		--CAST(ROUND(SUM([RunTimeIssued]), 2) AS decimal(14, 2)) AS [HrsIssued],
		--(CASE WHEN (CAST(ROUND([UnitQtyReqd], 0) AS int)) - CAST(ROUND([QtyIssued], 0) AS int) <= 0 THEN 'Y' else 'N' END) AS [Complete],
		--[WipMaster].[Warehouse] AS [Warehouse]
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
		AND ((@INCOMPLETEONLY = 1 AND [WipMaster].[Complete] = 'N') OR @INCOMPLETEONLY = 0)
		AND QtyOnHand > 0
	GROUP BY

	[WipJobAllMat].[Job],
	[WipMaster].[StockCode]
		--[WipMaster].[Job],
		--[WipJobAllMat].[StockCode],
		--[WipJobAllMat].[StockDescription],
		--[WipMaster].[Warehouse]
	
		--,[Operation]
		--,[UnitQtyReqd]
		--,[QtyIssued]
		--,[QtyOnHand]
	--ORDER BY
	--	[WipMaster.JobStartDate]
)