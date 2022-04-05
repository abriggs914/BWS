USE [SysproCompanyA]
GO

-- GOOD VERSION 2022-03-30 4:44 PM

/****** Object:  StoredProcedure [dbo].[sp_TopLevelWOReportJamieMulti]    Script Date: 2022-03-30 4:16:17 PM ******/
--SET ANSI_NULLS ON
--GO
--SET QUOTED_IDENTIFIER ON
--GO

----  (IO + PC + WH + OP + WC + MC)

--ALTER PROCEDURE [dbo].[sp_TopLevelWOReportJamieMulti]

------DECLARE
--	@WO VARCHAR(MAX),
--	@INCOMPLETEONLY BIT,
--	@PARTCATEGORY NVARCHAR(MAX)=NULL,
--	@OPERATION NVARCHAR(MAX)=NULL,
--	@WAREHOUSE NVARCHAR(MAX)=NULL,
--	@MACHINE NVARCHAR(MAX)=NULL,
--	@WORKCENTRE NVARCHAR(MAX)=NULL

--AS
--BEGIN

--/****** Object:  StoredProcedure [dbo].[sp_TopLevelWOReportJamieMultiV2]    Script Date: 2022-03-30 1:59:19 PM ******/
--SET ANSI_NULLS ON
--GO
--SET QUOTED_IDENTIFIER ON
--GO

--ALTER PROCEDURE [dbo].[sp_TopLevelWOReportJamieMultiV2]

--AS BEGIN
DECLARE
	@WO VARCHAR(MAX),
	@INCOMPLETEONLY BIT,
	@PARTCATEGORY NVARCHAR(MAX)=NULL,
	@OPERATION NVARCHAR(MAX)=NULL,
	@WAREHOUSE NVARCHAR(MAX)=NULL,
	@MACHINE NVARCHAR(MAX)=NULL,
	@WORKCENTRE NVARCHAR(MAX)=NULL

SET @WO= '10015400';
SET @INCOMPLETEONLY=0;
SET @PARTCATEGORY='B';
--SET @OPERATION='03;04;05';
SET @WAREHOUSE='01;06';
--SET @WORKCENTRE='S'
--SET @MACHINE='37';

DECLARE @wos AS TABLE([idx] INT, [Job] NVARCHAR(MAX));
INSERT INTO @wos SELECT * FROM [BWSdb].[dbo].[split_string_idx](@wo, ';');

DECLARE @split_wh AS TABLE ([idx] INT, [splitted_data] NVARCHAR(2))
INSERT INTO @split_wh SELECT * FROM [BWSdb].[dbo].[split_string_idx](@WAREHOUSE, ';')
IF (SELECT COUNT(*) FROM @split_wh) = 0 BEGIN
	-- If no warehouses are selected then return all warehouses
	--INSERT INTO @split_wh ([idx], [splitted_data]) SELECT ROW_NUMBER() OVER (ORDER BY [Warehouse]) AS [Row#], [Warehouse] FROM [SysproCompanyA].[dbo].[InvWhControl] GROUP BY [Warehouse]
	INSERT INTO @split_wh SELECT * FROM [SysproCompanyA].[dbo].[v_TLWRAllWarehouses]
END

DECLARE @split_op AS TABLE ([idx] INT, [splitted_data] NVARCHAR(MAX))
INSERT INTO @split_op SELECT * FROM [BWSdb].[dbo].[split_string_idx](@OPERATION, ';')
IF (SELECT COUNT(*) FROM @split_op) = 0 BEGIN
	-- If no operations are selected then return all operations
	--INSERT INTO @split_op ([idx], [splitted_data]) SELECT ROW_NUMBER() OVER (ORDER BY [Warehouse]) AS [Row#], [Warehouse] FROM [SysproCompanyA].[dbo].[InvWarehouse] GROUP BY [Warehouse]
	INSERT INTO @split_op SELECT * FROM [SysproCompanyA].[dbo].[v_TLWRAllOperations]
END

DECLARE @split_pc AS TABLE ([idx] INT, [splitted_data] NVARCHAR(MAX))
INSERT INTO @split_pc SELECT * FROM [BWSdb].[dbo].[split_string_idx](@PARTCATEGORY, ';')
IF (SELECT COUNT(*) FROM @split_pc) = 0 BEGIN
	-- If no part categories are selected then return all part categories
	--INSERT INTO @split_pc ([idx], [splitted_data]) SELECT ROW_NUMBER() OVER (ORDER BY [PartCategory]) AS [Row#], [PartCategory] FROM [SysproCompanyA].[dbo].[InvMaster] GROUP BY [PartCategory]
	INSERT INTO @split_pc SELECT * FROM [SysproCompanyA].[dbo].[v_TLWRAllPartCategories]
END

DECLARE @split_wc AS TABLE ([idx] INT, [splitted_data] NVARCHAR(MAX))
INSERT INTO @split_wc SELECT * FROM [BWSdb].[dbo].[split_string_idx](@WORKCENTRE, ';')
IF (SELECT COUNT(*) FROM @split_wc) = 0 BEGIN
	-- If no workcentres are selected then return all work centres
	--INSERT INTO @split_wc ([idx], [splitted_data]) SELECT ROW_NUMBER() OVER (ORDER BY [WorkCentre]) AS [Row#], [WorkCentre] FROM [SysproCompanyA].[dbo].[WipJobAllLab] GROUP BY [WorkCentre]
	INSERT INTO @split_wc SELECT * FROM [SysproCompanyA].[dbo].[v_TLWRAllWorkCentres]
END

DECLARE @split_im AS TABLE ([idx] INT, [splitted_data] NVARCHAR(MAX))
INSERT INTO @split_im SELECT * FROM [BWSdb].[dbo].[split_string_idx](@MACHINE, ';')
IF (SELECT COUNT(*) FROM @split_im) = 0 BEGIN
	-- If no machines are selected then return all machines
	--INSERT INTO @split_im ([idx], [splitted_data]) SELECT ROW_NUMBER() OVER (ORDER BY [IMachine]) AS [Row#], [IMachine] FROM [SysproCompanyA].[dbo].[WipJobAllLab] GROUP BY [IMachine]
	INSERT INTO @split_im SELECT * FROM [SysproCompanyA].[dbo].[v_TLWRAllMachines]
END

SELECT
	[ph]
	,[Part Category]
	,[Operation]
	,ISNULL([JobStartDate], MAX([MLatestDueDate])) AS [JobStartDate]
	,ISNULL([WipMasterJob], 'PO#' + MAX([PurchaseOrder])) AS [WipMasterJob]
	,[WipMasterStockCode]
	,[WipMasterStockDescription]
	,[InvWarehouse].[QtyOnHand]
	,[QtyIssued]
	,[QtyRequired]
	,[HrsIssued]
	,[Complete]
	,[InvWarehouse].[Warehouse]
	,[WorkCentre]
	,[Machine]
	--,MAX([PurchaseOrder]) AS [PurchaseOrder]
FROM (
	SELECT
		[Aph] AS [ph]
		,case when [APart Category] is null or [APart Category] = 'S' then 'B' else [APart Category] end as [Part Category]
		,[AOperation] AS [Operation]
		,[BWipMaster.JobStartDate] AS [JobStartDate]
		,ISNULL([BJob], 'PO#' + [BPurchaseOrder]) AS [WipMasterJob]
		,[AWipMasterStockCode] AS [WipMasterStockCode]
		,[BWipMaster.StockDescription] AS [WipMasterStockDescription]
		,ISNULL(SUM([BQtyOnHand]), 0) AS [QtyOnHand]
		,SUM([AQtyIssued]) AS [QtyIssued]
		,SUM([AQtyRequired]) AS [QtyRequired]
		,SUM([AHrsIssued]) AS [HrsIssued]
		,[AComplete] AS [Complete]
		,[AWarehouse] AS [Warehouse]
		,[SrcA].[WorkCentre]
		,[SrcA].[Machine]

	FROM (
		select
			0 AS [Aph]
			,WipMaster.Job AS [AMasterJob]
			,case when PartCategory is null or PartCategory = 'S' then 'B' else PartCategory end as [APart Category]
			,WipJobAllMat.OperationOffset AS [AOperation]
			,WipMaster.JobTenderDate AS [AJobStartDate]
			,WipMaster.Job AS [AWipMasterJob]
			,WipJobAllMat.StockCode AS [AWipMasterStockCode]
			,WipJobAllMat.StockDescription as [AWipMasterStockDescription]
			,[InvWarehouse].[QtyOnHand] AS [AQtyOnHand]
			,[QtyIssued] AS [AQtyIssued]
			,cast(UnitQtyReqd * QtyToMake as decimal(18, 2)) AS AQtyRequired
			,SUM([RunTimeIssued]) AS [AHrsIssued]
			,(CASE WHEN (CAST(ROUND(([UnitQtyReqd]), 0) AS int)) - CAST(ROUND(([QtyIssued]), 0) AS int) <= 0 THEN 'Y' else 'N' END) AS [AComplete]
			,WipJobAllMat.[Warehouse] AS [AWarehouse]
			,[WorkCentre]
			,[IMachine] AS [Machine]

		from WipMaster with (nolock)
		left outer join WipJobAllMat with (nolock) on WipMaster.Job = WipJobAllMat.Job
		left outer join v_JobWIPValue on WipMaster.Job = v_JobWIPValue.Job
		left outer join InvMaster with (nolock) on WipJobAllMat.StockCode = InvMaster.StockCode
		left outer join WipJobAllLab with (nolock) on WipMaster.Job = WipJobAllLab.Job
		left outer join InvWarehouse with (nolock) on WipJobAllMat.StockCode = InvWarehouse.StockCode

		WHERE 
			[WipMaster].[Job] IN (SELECT [Job] FROM @wos)
			AND [PartCategory] IN (SELECT [splitted_data] FROM @split_pc)
			AND RIGHT('00' + [WipJobAllMat].[Warehouse], 2) IN (SELECT [splitted_data] FROM @split_wh)
			AND RIGHT('00' + CAST([OperationOffset] AS NVARCHAR(2)), 2) IN (SELECT [splitted_data] FROM @split_op)
			AND [ProductClass] <> 'BF'
			--AND [Operation] IN (SELECT [splitted_data] FROM @split_op) -- doesnt seem safe to use this one.
			--AND [Part Category] IN (SELECT [splitted_data] FROM @split_pc)
			AND [WorkCentre] IN (SELECT [splitted_data] FROM @split_wc)
			AND [IMachine] IN (SELECT [splitted_data] FROM @split_im)
			AND ((@INCOMPLETEONLY = 1 AND (CASE WHEN (CAST(ROUND(([UnitQtyReqd]), 0) AS int)) - CAST(ROUND(([QtyIssued]), 0) AS int) <= 0 THEN 'Y' else 'N' END) = 'N') OR @INCOMPLETEONLY = 0)
		GROUP BY
			WipMaster.Job,
			(case PartCategory when 'B' then 'Total Bought Out Material:'
			when 'M' then 'Total Made In Material:'
			when 'G' then 'Total Phantom Material:'
			when 'S' then 'Total Subcontracted Material:'
			when 'P' then 'Total Planning Material:'
			when 'K' then 'Total Kit Material:'
			when 'C' then 'Total Co-Product Material:'
			else '' end), 
			(case when PartCategory is null or PartCategory = 'S' then 'B'
			else PartCategory end),
			WipJobAllMat.OperationOffset,
			WipMaster.JobTenderDate, 
			WipMaster.Job,
			WipJobAllMat.StockCode,
			WipJobAllMat.StockDescription,
			[InvWarehouse].[QtyOnHand],
			[QtyIssued],
			cast(UnitQtyReqd * QtyToMake as decimal(18, 2)),
			(CASE WHEN (CAST(ROUND(([UnitQtyReqd]), 0) AS int)) - CAST(ROUND(([QtyIssued]), 0) AS int) <= 0 THEN 'Y' else 'N' END),
			WipJobAllMat.[Warehouse]
			,[WorkCentre]
			,[IMachine]
	) AS [SrcA]
	LEFT OUTER JOIN (
		SELECT
			*
		FROM (
			SELECT
				ROW_NUMBER() OVER (
					PARTITION BY
						[WipJobAllMat].[StockCode],
						[WipJobAllMat].[StockDescription]
					ORDER BY
						(CASE WHEN ISNULL([Complete], 'N') = 'N' THEN 0 ELSE 1 END),
						[WipMaster].[JobStartDate]
				) AS [BRow#],
					1 AS [Bph],
					[WipMaster].[Job] AS [BJob],
					'M' AS [BPart Category],
					[Operation] AS [BOperation],
					MIN([WipMaster].[JobStartDate]) AS [BWipMaster.JobStartDate],
					MIN([WipMaster].[Job]) AS [BWipMaster.Job],
					[WipJobAllMat].[StockCode] AS [BWipMaster.StockCode],
					[WipJobAllMat].[StockDescription] AS [BWipMaster.StockDescription],
					CAST(ROUND((QtyOnHand), 0) AS int) AS [BQtyOnHand],
					CAST(ROUND([QtyIssued], 0) AS int) AS [BQtyIssued],
					CAST(ROUND([UnitQtyReqd], 0) AS int) AS [BQtyRequired],
					CAST(ROUND(SUM([RunTimeIssued]), 2) AS decimal(14, 2)) AS [BHrsIssued],
					(CASE WHEN (CAST(ROUND([UnitQtyReqd], 0) AS int)) - CAST(ROUND([QtyIssued], 0) AS int) <= 0 THEN 'Y' else 'N' END) AS [BComplete],
					[WipMaster].[Warehouse] AS [BWarehouse]
					,MAX([PurchaseOrder]) AS [BPurchaseOrder]
					,[WipJobAllLab].[WorkCentre] AS [WorkCentre]
					,[WipJobAllLab].[IMachine] AS [Machine]
				FROM
					[WipJobAllMat] WITH (NOLOCK)
				LEFT OUTER JOIN
					[WipMaster] WITH (NOLOCK)
				ON
					[WipJobAllMat].[StockCode] = [WipMaster].[StockCode] and [WipJobAllMat].[Warehouse] = [WipMaster].[Warehouse]
				LEFT OUTER JOIN
					[WipJobAllLab] WITH (NOLOCK)
				ON
					[WipJobAllLab].[Job] = [WipMaster].[Job]
				LEFT OUTER JOIN
					[InvWarehouse] WITH (NOLOCK)
				ON
					[InvWarehouse].[StockCode] = [WipMaster].[StockCode] and [InvWarehouse].[Warehouse] = [WipMaster].[Warehouse]
				LEFT OUTER JOIN
					[PorMasterDetail] WITH (NOLOCK)
				ON	
					[WipMaster].[StockCode] = [PorMasterDetail].[MStockCode]
				LEFT JOIN
					[InvMaster] WITH (NOLOCK)
				ON
					[WipJobAllMat].[StockCode] = [InvMaster].[StockCode]
				WHERE
					[ProductClass] <> 'BF' AND
					[WipJobAllMat].[Job] IN (SELECT [Job] FROM @wos)
					AND ([JobStartDate] > DATEADD(YEAR, -1, GETDATE()) OR [JobStartDate] IS NULL)
				GROUP BY
					[WipMaster].[Job],
					[WipJobAllMat].[StockCode],
					[WipJobAllMat].[StockDescription],
		
					[WipMaster].[JobStartDate]
					,[WipMaster].[Warehouse]
					,[WipJobAllLab].[WorkCentre]
					,[WipJobAllLab].[IMachine]
	
					,[Operation]
					,[UnitQtyReqd]
					,[QtyIssued]
					,[QtyOnHand]
					,[Complete]
					--,[PurchaseOrder]
				--ORDER BY
				--	[WipMaster.JobStartDate]
			) AS [Src]
			WHERE
				[Src].[BRow#] = 1
		) AS [SrcB]
	ON
		[SrcA].[AWipMasterStockCode] = [SrcB].[BWipMaster.StockCode]
	GROUP BY
		[Aph]
		,case when [APart Category] is null or [APart Category] = 'S' then 'B' else [APart Category] end
		,[AOperation]
		,[BWipMaster.JobStartDate]
		,ISNULL([BJob], 'PO#' + [BPurchaseOrder])
		,[AWipMasterStockCode]
		,[BWipMaster.StockDescription]
		,[AWarehouse]
		,[AComplete]
		,[SrcA].[WorkCentre]
		,[SrcA].[Machine]
	
		--,ISNULL([BQtyOnHand], 0) AS [QtyOnHand]
		--,[AQtyIssued] AS [QtyIssued]
		--,[AQtyRequired] AS [QtyRequired]
		--,[AHrsIssued] AS [HrsIssued]
) AS [FinalA]
LEFT JOIN
	[InvWarehouse]
ON
	[FinalA].[WipMasterStockCode] = [InvWarehouse].[StockCode]
LEFT JOIN
	[PorMasterDetail]
ON
	[FinalA].[WipMasterStockCode] = [InvWarehouse].[StockCode]
GROUP BY
	[ph]
	,[Part Category]
	,[Operation]
	,[JobStartDate]
	,[WipMasterJob]
	,[WipMasterStockCode]
	,[WipMasterStockDescription]
	,[InvWarehouse].[QtyOnHand]
	,[QtyIssued]
	,[QtyRequired]
	,[HrsIssued]
	,[Complete]
	,[InvWarehouse].[Warehouse]
	,[FinalA].[WorkCentre]
	,[FinalA].[Machine]
ORDER BY
	[Complete]
	,[JobStartDate]
	,[WipMasterStockCode]

--END


/*********************************************************************************************************************/
/*********************************************************************************************************************/
/********************************    Most recent working version 2022-03-30 4:17 PM    *******************************/
/*********************************************************************************************************************/
/*********************************************************************************************************************/
/*********************************************************************************************************************/
/*********************************************************************************************************************/
/*********************************************************************************************************************/

--DECLARE @wos AS TABLE([Job#] INT, [Job] NVARCHAR(MAX));
--INSERT INTO @wos SELECT * FROM [BWSdb].[dbo].[split_string_idx](@wo, ';');

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
--	--,[WorkCentre] NVARCHAR(255)
--	--,[IMachine] NVARCHAR(255)
--)











--INSERT INTO @T
----EXEC [dbo].[sp_TopLevelWOSubsReportJamie] @WO=@WO, @INCOMPLETEONLY=@INCOMPLETEONLY, @PARTCATEGORY=@PARTCATEGORY, @OPERATION=@OPERATION, @WAREHOUSE=@WAREHOUSE
--SELECT
--	0 AS [ph],
--	[WipMaster].[Job],
--	'M' AS [Part Category],
--	[Operation],
--	MAX([WipMaster].[JobStartDate]) AS [WipMaster.JobStartDate],
--	MAX([WipMaster].[Job]) AS [WipMaster.Job],
--	[WipJobAllMat].[StockCode] AS [WipMaster.StockCode],
--	[WipMaster].[StockDescription] AS [WipMaster.StockDescription],
--	CAST(ROUND((QtyOnHand), 0) AS int) AS [QtyOnHand],
--	CAST(ROUND([QtyIssued], 0) AS int) AS [QtyIssued],
--	CAST(ROUND([UnitQtyReqd], 0) AS int) AS [QtyRequired],
--	CAST(ROUND(SUM([RunTimeIssued]), 2) AS decimal(14, 2)) AS [HrsIssued],
--	(CASE WHEN (CAST(ROUND(([UnitQtyReqd]), 0) AS int)) - CAST(ROUND(([QtyIssued]), 0) AS int) <= 0 THEN 'Y' else 'N' END) AS [Complete],
--	[WipMaster].[Warehouse] AS [Warehouse]
--	--,[WipJobAllLab].[WorkCentre] AS [WorkCentre]
--	--,[WipJobAllLab].[IMachine] AS [IMachine]
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
--	[WipJobAllMat].[Job] IN (SELECT [Job] FROM @wos)
--	--AND (
--	--	RIGHT([WipJobAllMat].[Job], 1) = '1' 
--	--	OR RIGHT([WipJobAllMat].[Job], 1) = '7' 
--	--	OR RIGHT([WipJobAllMat].[Job], 1) = '2'
--	--)
--	AND ((@INCOMPLETEONLY = 1 AND [WipMaster].[Complete] = 'N') OR @INCOMPLETEONLY = 0)
--	AND QtyOnHand = 0
--GROUP BY
--	[WipMaster].[Job],
--	[WipJobAllMat].[StockCode],
--	[WipMaster].[StockDescription],
--	[WipMaster].[Warehouse]
--	--,[WipJobAllLab].[WorkCentre]
--	--,[WipJobAllLab].[IMachine]
	
--	,[Operation]
--	,[UnitQtyReqd]
--	,[QtyIssued]
--	,[QtyOnHand]

--INSERT INTO @T 
--	SELECT
--		1 AS [ph],
--		[WipMaster].[Job],
--		'M' AS [Part Category],
--		[Operation],
--		MIN([WipMaster].[JobStartDate]) AS [WipMaster.JobStartDate],
--		MIN([WipMaster].[Job]) AS [WipMaster.Job],
--		[WipJobAllMat].[StockCode] AS [WipMaster.StockCode],
--		[WipJobAllMat].[StockDescription] AS [WipMaster.StockDescription],
--		CAST(ROUND((QtyOnHand), 0) AS int) AS [QtyOnHand],
--		CAST(ROUND([QtyIssued], 0) AS int) AS [QtyIssued],
--		CAST(ROUND([UnitQtyReqd], 0) AS int) AS [QtyRequired],
--		CAST(ROUND(SUM([RunTimeIssued]), 2) AS decimal(14, 2)) AS [HrsIssued],
--		(CASE WHEN (CAST(ROUND([UnitQtyReqd], 0) AS int)) - CAST(ROUND([QtyIssued], 0) AS int) <= 0 THEN 'Y' else 'N' END) AS [Complete],
--		[WipMaster].[Warehouse] AS [Warehouse]
--		--,[WipJobAllLab].[WorkCentre] AS [WorkCentre]
--		--,[WipJobAllLab].[IMachine] AS [IMachine]
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
--		[WipJobAllMat].[Job] IN (SELECT [Job] FROM @wos)
--		--AND (
--		--	RIGHT([WipJobAllMat].[Job], 1) = '1' 
--		--	OR RIGHT([WipJobAllMat].[Job], 1) = '7' 
--		--	OR RIGHT([WipJobAllMat].[Job], 1) = '2'
--		--)
--		AND ((@INCOMPLETEONLY = 1 AND [WipMaster].[Complete] = 'N') OR @INCOMPLETEONLY = 0)
--		AND QtyOnHand > 0
--	GROUP BY
--		[WipMaster].[Job],
--		[WipJobAllMat].[StockCode],
--		[WipJobAllMat].[StockDescription],
--		[WipMaster].[Warehouse]
--		--,[WipJobAllLab].[WorkCentre]
--		--,[WipJobAllLab].[IMachine]
	
--		,[Operation]
--		,[UnitQtyReqd]
--		,[QtyIssued]
--		,[QtyOnHand]
--	--ORDER BY
--	--	[WipMaster.JobStartDate]

--DECLARE @results TABLE (
--	[ph] INT,
--	[Job] NVARCHAR(MAX),
--	[Part Category] CHAR(1),
--	[Operation] NVARCHAR(MAX),
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
--	--,[WorkCentre] NVARCHAR(MAX)
--	--,[IMachine] NVARCHAR(255)
--)

--INSERT INTO @results
--SELECT * FROM @T
--UNION ALL
--SELECT 
--	(CASE WHEN [QtyOnHand] = 0 THEN 0 ELSE 1 END) AS [ph],
--	[WipMaster].[Job],
--	'B' AS [Part Category],
--	[OperationOffset],
--	[MLatestDueDate] AS [WipMaster.JobStartDate],
--	'PO#' + RIGHT([PurchaseOrder], 8) AS [WipMaster.Job],
--	[MStockCode] AS [WipMaster.StockCode],
--	[A].[StockDescription] AS [WipMaster.StockDescription],
--	[QtyOnHand],
--	[QtyIssued],
--	[UnitQtyReqd] AS [QtyRequired],
--	[RunTimeIssued] AS [HrsIssued],
--	(CASE WHEN (CAST(ROUND([UnitQtyReqd], 0) AS int)) - CAST(ROUND([QtyIssued], 0) AS int) <= 0 THEN 'Y' else 'N' END) AS [Complete],
--	[A].[Warehouse]
--	--,[C].[WorkCentre]
--	--,[C].[IMachine]
--FROM (
--SELECT
--	'THIS ONE' as [MARKER],
--	[WipJobAllMat].*
--FROM
--	[WipJobAllMat]
--LEFT JOIN
--	@T
--ON
--	[@T].[WipMaster.StockCode] = [WipJobAllMat].[StockCode]
--WHERE
--	[Job] IN (SELECT [Job] FROM @wos) AND [@T].[WipMaster.StockCode] IS NULL
--) AS [A]
--INNER JOIN (
--	SELECT * FROM (
--	SELECT ROW_NUMBER() OVER (
--		PARTITION BY [MStockCode]
--		ORDER BY [MLatestDueDate] DESC
--	) AS [Row#],
--	[PurchaseOrder], [MStockCode], [MLatestDueDate], [PorMasterDetail].[MWarehouse] FROM [PorMasterDetail] WITH (NOLOCK)
--	) AS [Src]
--	INNER JOIN
--		[InvWarehouse]
--	ON
--		[InvWarehouse].[StockCode] = [Src].[MStockCode] and [InvWarehouse].[Warehouse] = [Src].[MWarehouse]
--	WHERE
--		[Row#] = 1
--	) AS [B]
--ON
--	[A].[StockCode] = [B].[MStockCode]
--INNER JOIN
--	[WipMaster]
--ON
--	[A].[Job] = [WipMaster].[Job]
--INNER JOIN (
--	SELECT [Job], SUM([RunTimeIssued]) AS [RunTimeIssued], [WorkCentre], [IMachine] FROM
--	[WipJobAllLab]
--	GROUP BY
--		[Job],
--		[WorkCentre],
--		[IMachine]
--) AS [C]
--ON
--	[A].[Job] = [C].[Job]
--WHERE
--	((@INCOMPLETEONLY = 1 AND [WipMaster].[Complete] = 'N') OR @INCOMPLETEONLY = 0)
--ORDER BY
--	[ph], [Complete], [WipMaster.JobStartDate], [WipMaster.StockCode]
	

--DECLARE @split_wh AS TABLE ([idx] INT, [splitted_data] NVARCHAR(MAX))
--INSERT INTO @split_wh SELECT * FROM [BWSdb].[dbo].[split_string_idx](@WAREHOUSE, ';')
--IF (SELECT COUNT(*) FROM @split_wh) = 0 BEGIN
--	-- If no warehouses are selected then return all warehouses
--	--INSERT INTO @split_wh ([idx], [splitted_data]) SELECT ROW_NUMBER() OVER (ORDER BY [Warehouse]) AS [Row#], [Warehouse] FROM [SysproCompanyA].[dbo].[InvWhControl] GROUP BY [Warehouse]
--	INSERT INTO @split_wh SELECT * FROM [SysproCompanyA].[dbo].[v_TLWRAllWarehouses]
--END

--DECLARE @split_op AS TABLE ([idx] INT, [splitted_data] NVARCHAR(MAX))
--INSERT INTO @split_op SELECT * FROM [BWSdb].[dbo].[split_string_idx](@OPERATION, ';')
--IF (SELECT COUNT(*) FROM @split_op) = 0 BEGIN
--	-- If no operations are selected then return all operations
--	--INSERT INTO @split_op ([idx], [splitted_data]) SELECT ROW_NUMBER() OVER (ORDER BY [Warehouse]) AS [Row#], [Warehouse] FROM [SysproCompanyA].[dbo].[InvWarehouse] GROUP BY [Warehouse]
--	INSERT INTO @split_op SELECT * FROM [SysproCompanyA].[dbo].[v_TLWRAllOperations]
--END

--DECLARE @split_pc AS TABLE ([idx] INT, [splitted_data] NVARCHAR(MAX))
--INSERT INTO @split_pc SELECT * FROM [BWSdb].[dbo].[split_string_idx](@PARTCATEGORY, ';')
--IF (SELECT COUNT(*) FROM @split_pc) = 0 BEGIN
--	-- If no part categories are selected then return all part categories
--	--INSERT INTO @split_pc ([idx], [splitted_data]) SELECT ROW_NUMBER() OVER (ORDER BY [PartCategory]) AS [Row#], [PartCategory] FROM [SysproCompanyA].[dbo].[InvMaster] GROUP BY [PartCategory]
--	INSERT INTO @split_pc SELECT * FROM [SysproCompanyA].[dbo].[v_TLWRAllPartCategories]
--END

--DECLARE @split_wc AS TABLE ([idx] INT, [splitted_data] NVARCHAR(MAX))
--INSERT INTO @split_wc SELECT * FROM [BWSdb].[dbo].[split_string_idx](@WORKCENTRE, ';')
--IF (SELECT COUNT(*) FROM @split_wc) = 0 BEGIN
--	-- If no workcentres are selected then return all work centres
--	--INSERT INTO @split_wc ([idx], [splitted_data]) SELECT ROW_NUMBER() OVER (ORDER BY [WorkCentre]) AS [Row#], [WorkCentre] FROM [SysproCompanyA].[dbo].[WipJobAllLab] GROUP BY [WorkCentre]
--	INSERT INTO @split_wc SELECT * FROM [SysproCompanyA].[dbo].[v_TLWRAllWorkCentres]
--END

--DECLARE @split_im AS TABLE ([idx] INT, [splitted_data] NVARCHAR(MAX))
--INSERT INTO @split_im SELECT * FROM [BWSdb].[dbo].[split_string_idx](@MACHINE, ';')
--IF (SELECT COUNT(*) FROM @split_im) = 0 BEGIN
--	-- If no machines are selected then return all machines
--	--INSERT INTO @split_im ([idx], [splitted_data]) SELECT ROW_NUMBER() OVER (ORDER BY [IMachine]) AS [Row#], [IMachine] FROM [SysproCompanyA].[dbo].[WipJobAllLab] GROUP BY [IMachine]
--	INSERT INTO @split_im SELECT * FROM [SysproCompanyA].[dbo].[v_TLWRAllMachines]
--END

----SELECT 'A' AS [@T], * FROM @T
----SELECT 'B' AS [@results], * FROM @results
----SELECT 'C' AS [@split_pc], * FROM @split_pc
----SELECT 'D' AS [@split_op], * FROM @split_op
----SELECT 'E' AS [@split_wh], * FROM @split_wh
----SELECT 'F' AS [@split_im], * FROM @split_im
----SELECT 'G' AS [@split_wc], * FROM @split_wc
----SELECT 'H' AS [@results], * FROM @results WHERE 
----	[Warehouse] IN (SELECT [Splitted_data] FROM @split_wh)
----	AND RIGHT('00' + [Operation], 2) IN (SELECT [Splitted_data] FROM @split_op)
----	--AND [Operation] IN (SELECT [Splitted_data] FROM @split_op) -- doesnt seem safe to use this one.
----	AND [Part Category] IN (SELECT [Splitted_data] FROM @split_pc)
----	--AND [WorkCentre] IN (SELECT [Splitted_data] FROM @split_wc)
----	--AND [IMachine] IN (SELECT [Splitted_data] FROM @split_im)

--SELECT
--	[ph],
--	MIN([Job]) AS [MasterJob],
--	[Part Category],
--	MAX([Operation]) AS [Operation],
--	MIN([WipMaster.JobStartDate]) AS [JobStartDate],
--	MIN([WipMaster.Job]) AS [WipMasterJob],
--	[WipMaster.StockCode] AS [WipMasterStockCode],
--	[WipMaster.StockDescription] AS [WipMasterStockDescription],
--	MAX([QtyOnHand]) AS [QtyOnHand],
--	SUM([QtyIssued]) AS [QtyIssued],
--	SUM([QtyRequired]) AS [QtyRequired],
--	SUM([HrsIssued]) AS [HrsIssued],
--	[Complete],
--	[Warehouse]
--	--,[WorkCentre]
--	--,[IMachine]
--FROM
--	@results
--WHERE 
--	[Warehouse] IN (SELECT [Splitted_data] FROM @split_wh)
--	AND RIGHT('00' + [Operation], 2) IN (SELECT [Splitted_data] FROM @split_op)
--	--AND [Operation] IN (SELECT [Splitted_data] FROM @split_op) -- doesnt seem safe to use this one.
--	AND [Part Category] IN (SELECT [Splitted_data] FROM @split_pc)
--	--AND [WorkCentre] IN (SELECT [Splitted_data] FROM @split_wc)
--	--AND [IMachine] IN (SELECT [Splitted_data] FROM @split_im)
--GROUP BY
--	[ph]
--	--,[Job]
--	,[Part Category]
--	--,[WipMaster.JobStartDate]
--	--,[WipMaster.Job]
--	,[WipMaster.StockCode],
--	[WipMaster.StockDescription],
--	[Complete],
--	[Warehouse]
--	--,[WorkCentre]
--	--,[IMachine]

--END


/*********************************************************************************************************************/
/*********************************************************************************************************************/
/*********************************************************************************************************************/
/*********************************************************************************************************************/
/*********************************************************************************************************************/
/*********************************************************************************************************************/