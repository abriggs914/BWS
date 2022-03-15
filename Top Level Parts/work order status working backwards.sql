USE SysproCompanyA
GO

ALTER PROCEDURE [dbo].[sp_TopLevelWOReportJamieMultiV2]

--DECLARE
	@WO VARCHAR(MAX),
	@INCOMPLETEONLY BIT,
	@PARTCATEGORY NVARCHAR(MAX)=NULL,
	@OPERATION NVARCHAR(MAX)=NULL,
	@WAREHOUSE NVARCHAR(MAX)=NULL,
	@MACHINE NVARCHAR(MAX)=NULL,
	@WORKCENTRE NVARCHAR(MAX)=NULL
AS BEGIN
--DECLARE
--	@WO VARCHAR(MAX),
--	@INCOMPLETEONLY BIT,
--	@PARTCATEGORY NVARCHAR(MAX)=NULL,
--	@OPERATION NVARCHAR(MAX)=NULL,
--	@WAREHOUSE NVARCHAR(MAX)=NULL,
--	@MACHINE NVARCHAR(MAX)=NULL,
--	@WORKCENTRE NVARCHAR(MAX)=NULL

--SET @WO='10015454;10015455';
--SET @INCOMPLETEONLY=0;
--SET @PARTCATEGORY='M;B;S';
--SET @OPERATION='03;04;05'
--SET @WAREHOUSE='01;04;06';
--SET @WORKCENTRE=NULL
--SET @MACHINE=NULL;

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

--SELECT 'A' AS [WOs], * FROM @wos
--SELECT 'C' AS [@split_pc], * FROM @split_pc
--SELECT 'D' AS [@split_op], * FROM @split_op
--SELECT 'E' AS [@split_wh], * FROM @split_wh
--SELECT 'F' AS [@split_im], * FROM @split_im
--SELECT 'G' AS [@split_wc], * FROM @split_wc

	/***********************************************************************************************************************************************************************/
	/***********************************************************************************************************************************************************************/
	/***********************************************************************************************************************************************************************/
	/*********************************                                      good version 2022-03-15 9:40 AM                                  *******************************/
	/***********************************************************************************************************************************************************************/
	/***********************************************************************************************************************************************************************/
	/***********************************************************************************************************************************************************************/


															--select
															--	WipMaster.Job,
															--	WipMaster.JobDescription,
															--	WipMaster.StockCode AS ParentPart,
															--	WipMaster.StockDescription as ParentDescription,
															--	WipMaster.JobTenderDate, 
															--	WipMaster.ActCompleteDate, WipMaster.QtyToMake, 
															--	case PartCategory when 'B' then 'Total Bought Out Material:'
															--	when 'M' then 'Total Made In Material:'
															--	when 'G' then 'Total Phantom Material:'
															--	when 'S' then 'Total Subcontracted Material:'
															--	when 'P' then 'Total Planning Material:'
															--	when 'K' then 'Total Kit Material:'
															--	when 'C' then 'Total Co-Product Material:'
															--	else '' end as MaterialGrouping, 
															--	case when PartCategory is null or PartCategory = 'S' then 'B'
															--	else PartCategory end as PartCategory,
															--	WipJobAllMat.StockCode, 
															--	WipJobAllMat.StockDescription,
															--	WipJobAllMat.SequenceNum,
															--	WipJobAllMat.OperationOffset,
															--	WipJobAllMat.Uom,
															--	UnitCost,
															--	WipJobAllMat.Warehouse as WarehouseToUse /*InvMaster.WarehouseToUse*/, 
															--	cast(UnitQtyReqd * QtyToMake as decimal(18, 2)) AS QtyRequired, 
															--	WipJobAllMat.QtyIssuedEnt as QtyIssued, 
															--	WipJobAllMat.ValueIssued, 
															--	v_JobWIPValue.Total
															--	,(CASE WHEN (CAST(ROUND(([UnitQtyReqd]), 0) AS int)) - CAST(ROUND(([QtyIssued]), 0) AS int) <= 0 THEN 'Y' else 'N' END) AS [Complete]

															--from WipMaster with (nolock)
															--left outer join WipJobAllMat with (nolock) on WipMaster.Job = WipJobAllMat.Job
															--left outer join v_JobWIPValue on WipMaster.Job = v_JobWIPValue.Job
															--left outer join InvMaster with (nolock) on WipJobAllMat.StockCode = InvMaster.StockCode
															----left outer join WipJobAllLab with (nolock) on WipMaster.Job = WipJobAllLab.Job

															--WHERE 
															--	[WipMaster].[Job] IN (SELECT [Job] FROM @wos)
															--	AND [PartCategory] IN (SELECT [splitted_data] FROM @split_pc)
															--	AND RIGHT('00' + [WipJobAllMat].[Warehouse], 2) IN (SELECT [splitted_data] FROM @split_wh)
															--	AND RIGHT('00' + CAST([OperationOffset] AS NVARCHAR(2)), 2) IN (SELECT [splitted_data] FROM @split_op)
															--	--AND [Operation] IN (SELECT [splitted_data] FROM @split_op) -- doesnt seem safe to use this one.
															--	--AND [Part Category] IN (SELECT [splitted_data] FROM @split_pc)
															--	--AND [WorkCentre] IN (SELECT [splitted_data] FROM @split_wc)
															--	--AND [IMachine] IN (SELECT [splitted_data] FROM @split_im)
															--	AND ((@INCOMPLETEONLY = 1 AND (CASE WHEN (CAST(ROUND(([UnitQtyReqd]), 0) AS int)) - CAST(ROUND(([QtyIssued]), 0) AS int) <= 0 THEN 'Y' else 'N' END) = 'N') OR @INCOMPLETEONLY = 0)

	/***********************************************************************************************************************************************************************/
	/***********************************************************************************************************************************************************************/
	/***********************************************************************************************************************************************************************/
	/***********************************************************************************************************************************************************************/
	/***********************************************************************************************************************************************************************/


	
	/***********************************************************************************************************************************************************************/
	/***********************************************************************************************************************************************************************/
	/***********************************************************************************************************************************************************************/
	/*********************************                                      good version 2022-03-15 1:34 PM                                  *******************************/
	/***********************************************************************************************************************************************************************/
	/***********************************************************************************************************************************************************************/
	/***********************************************************************************************************************************************************************/



--select
--	0 AS [ph]
--	,WipMaster.Job AS [MasterJob]
--	--case PartCategory when 'B' then 'Total Bought Out Material:'
--	--when 'M' then 'Total Made In Material:'
--	--when 'G' then 'Total Phantom Material:'
--	--when 'S' then 'Total Subcontracted Material:'
--	--when 'P' then 'Total Planning Material:'
--	--when 'K' then 'Total Kit Material:'
--	--when 'C' then 'Total Co-Product Material:'
--	--else '' end as MaterialGrouping, 
--	,case when PartCategory is null or PartCategory = 'S' then 'B' else PartCategory end as [Part Category]
--	,WipJobAllMat.OperationOffset AS [Operation]
--	,WipMaster.JobTenderDate AS [JobStartDate]
--	,WipMaster.Job AS [WipMasterJob]
--	,WipJobAllMat.StockCode AS [WipMasterStockCode]
--	,WipJobAllMat.StockDescription as [WipMasterStockDescription]

--	,[QtyOnHand] AS [QtyOnHand]
--	,[QtyIssued] AS [QtyIssued]
--	,cast(UnitQtyReqd * QtyToMake as decimal(18, 2)) AS QtyRequired
--	,[RunTimeIssued] AS [HrsIssued]

--	--WipMaster.QtyToMake, 
--	--WipMaster.JobDescription,
--	--WipMaster.ActCompleteDate,
	

--	,(CASE WHEN (CAST(ROUND(([UnitQtyReqd]), 0) AS int)) - CAST(ROUND(([QtyIssued]), 0) AS int) <= 0 THEN 'Y' else 'N' END) AS [Complete]
--	,WipJobAllMat.[Warehouse]
--	,[WorkCentre]
--	,[IMachine]
	
--	--WipJobAllMat.StockCode, 
--	--WipJobAllMat.StockDescription,
--	--WipJobAllMat.SequenceNum,
--	--WipJobAllMat.Uom,
--	--UnitCost,
--	--WipJobAllMat.Warehouse as WarehouseToUse /*InvMaster.WarehouseToUse*/, 
--	--cast(UnitQtyReqd * QtyToMake as decimal(18, 2)) AS QtyRequired, 
--	--WipJobAllMat.QtyIssuedEnt as QtyIssued, 
--	--WipJobAllMat.ValueIssued, 
--	--v_JobWIPValue.Total

--from WipMaster with (nolock)
--left outer join WipJobAllMat with (nolock) on WipMaster.Job = WipJobAllMat.Job
--left outer join v_JobWIPValue on WipMaster.Job = v_JobWIPValue.Job
--left outer join InvMaster with (nolock) on WipJobAllMat.StockCode = InvMaster.StockCode
--left outer join WipJobAllLab with (nolock) on WipMaster.Job = WipJobAllLab.Job
--left outer join InvWarehouse with (nolock) on WipMaster.StockCode = InvWarehouse.StockCode

--WHERE 
--	[WipMaster].[Job] IN (SELECT [Job] FROM @wos)
--	AND [PartCategory] IN (SELECT [splitted_data] FROM @split_pc)
--	AND RIGHT('00' + [WipJobAllMat].[Warehouse], 2) IN (SELECT [splitted_data] FROM @split_wh)
--	AND RIGHT('00' + CAST([OperationOffset] AS NVARCHAR(2)), 2) IN (SELECT [splitted_data] FROM @split_op)
--	--AND [Operation] IN (SELECT [splitted_data] FROM @split_op) -- doesnt seem safe to use this one.
--	--AND [Part Category] IN (SELECT [splitted_data] FROM @split_pc)
--	--AND [WorkCentre] IN (SELECT [splitted_data] FROM @split_wc)
--	--AND [IMachine] IN (SELECT [splitted_data] FROM @split_im)
--	AND ((@INCOMPLETEONLY = 1 AND (CASE WHEN (CAST(ROUND(([UnitQtyReqd]), 0) AS int)) - CAST(ROUND(([QtyIssued]), 0) AS int) <= 0 THEN 'Y' else 'N' END) = 'N') OR @INCOMPLETEONLY = 0)
--GROUP BY
--	WipMaster.Job,
--	(case PartCategory when 'B' then 'Total Bought Out Material:'
--	when 'M' then 'Total Made In Material:'
--	when 'G' then 'Total Phantom Material:'
--	when 'S' then 'Total Subcontracted Material:'
--	when 'P' then 'Total Planning Material:'
--	when 'K' then 'Total Kit Material:'
--	when 'C' then 'Total Co-Product Material:'
--	else '' end), 
--	(case when PartCategory is null or PartCategory = 'S' then 'B'
--	else PartCategory end),
--	WipJobAllMat.OperationOffset,
--	WipMaster.JobTenderDate, 
--	WipMaster.Job,
--	WipJobAllMat.StockCode,
--	WipJobAllMat.StockDescription,

--	--WipMaster.JobDescription,
--	--WipMaster.ActCompleteDate,
--	--WipMaster.QtyToMake, 
	
--	[QtyOnHand],
--	[QtyIssued],
--	cast(UnitQtyReqd * QtyToMake as decimal(18, 2)),
--	[RunTimeIssued],
--	(CASE WHEN (CAST(ROUND(([UnitQtyReqd]), 0) AS int)) - CAST(ROUND(([QtyIssued]), 0) AS int) <= 0 THEN 'Y' else 'N' END),
--	WipJobAllMat.[Warehouse],
--	[WorkCentre],
--	[IMachine]


	/***********************************************************************************************************************************************************************/
	/***********************************************************************************************************************************************************************/
	/***********************************************************************************************************************************************************************/
	/***********************************************************************************************************************************************************************/
	/***********************************************************************************************************************************************************************/


/*********************************************************************************************************************************************************/
/*********************************************************************************************************************************************************/
/*********************************************************************************************************************************************************/
/*************************************                    Working version 2022-03-15 4:21 PM                 *********************************************/
/*********************************************************************************************************************************************************/
/*********************************************************************************************************************************************************/
/*********************************************************************************************************************************************************/



--SELECT
--	[Aph] AS [ph]
--	,[AMasterJob] AS [MasterJob]
--	,case when [APart Category] is null or [APart Category] = 'S' then 'B' else [APart Category] end as [Part Category]
--	,[AOperation] AS [Operation]
--	,[BWipMaster.JobStartDate] AS [JobStartDate]
--	,ISNULL([BJob], 'PO#' + [BPurchaseOrder]) AS [WipMasterJob]
--	,[AWipMasterStockCode] AS [WipMasterStockCode]
--	,[BWipMaster.StockDescription] AS [WipMasterStockDescription]
--	,ISNULL([BQtyOnHand], 0) AS [QtyOnHand]
--	,[AQtyIssued] AS [QtyIssued]
--	,[AQtyRequired] AS [QtyRequired]
--	,[AHrsIssued] AS [HrsIssued]
--	,[AComplete] AS [Complete]
--	,[AWarehouse] AS [Warehouse]

--FROM (
--	select
--		0 AS [Aph]
--		,WipMaster.Job AS [AMasterJob]
--		,case when PartCategory is null or PartCategory = 'S' then 'B' else PartCategory end as [APart Category]
--		,WipJobAllMat.OperationOffset AS [AOperation]
--		,WipMaster.JobTenderDate AS [AJobStartDate]
--		,WipMaster.Job AS [AWipMasterJob]
--		,WipJobAllMat.StockCode AS [AWipMasterStockCode]
--		,WipJobAllMat.StockDescription as [AWipMasterStockDescription]
--		,[QtyOnHand] AS [AQtyOnHand]
--		,[QtyIssued] AS [AQtyIssued]
--		,cast(UnitQtyReqd * QtyToMake as decimal(18, 2)) AS AQtyRequired
--		,SUM([RunTimeIssued]) AS [AHrsIssued]
--		,(CASE WHEN (CAST(ROUND(([UnitQtyReqd]), 0) AS int)) - CAST(ROUND(([QtyIssued]), 0) AS int) <= 0 THEN 'Y' else 'N' END) AS [AComplete]
--		,WipJobAllMat.[Warehouse] AS [AWarehouse]
--		--,[WorkCentre]
--		--,[IMachine]

--	from WipMaster with (nolock)
--	left outer join WipJobAllMat with (nolock) on WipMaster.Job = WipJobAllMat.Job
--	left outer join v_JobWIPValue on WipMaster.Job = v_JobWIPValue.Job
--	left outer join InvMaster with (nolock) on WipJobAllMat.StockCode = InvMaster.StockCode
--	left outer join WipJobAllLab with (nolock) on WipMaster.Job = WipJobAllLab.Job
--	left outer join InvWarehouse with (nolock) on WipMaster.StockCode = InvWarehouse.StockCode

--	WHERE 
--		[WipMaster].[Job] IN (SELECT [Job] FROM @wos)
--		AND [PartCategory] IN (SELECT [splitted_data] FROM @split_pc)
--		AND RIGHT('00' + [WipJobAllMat].[Warehouse], 2) IN (SELECT [splitted_data] FROM @split_wh)
--		AND RIGHT('00' + CAST([OperationOffset] AS NVARCHAR(2)), 2) IN (SELECT [splitted_data] FROM @split_op)
--		--AND [Operation] IN (SELECT [splitted_data] FROM @split_op) -- doesnt seem safe to use this one.
--		--AND [Part Category] IN (SELECT [splitted_data] FROM @split_pc)
--		--AND [WorkCentre] IN (SELECT [splitted_data] FROM @split_wc)
--		--AND [IMachine] IN (SELECT [splitted_data] FROM @split_im)
--		AND ((@INCOMPLETEONLY = 1 AND (CASE WHEN (CAST(ROUND(([UnitQtyReqd]), 0) AS int)) - CAST(ROUND(([QtyIssued]), 0) AS int) <= 0 THEN 'Y' else 'N' END) = 'N') OR @INCOMPLETEONLY = 0)
--	GROUP BY
--		WipMaster.Job,
--		(case PartCategory when 'B' then 'Total Bought Out Material:'
--		when 'M' then 'Total Made In Material:'
--		when 'G' then 'Total Phantom Material:'
--		when 'S' then 'Total Subcontracted Material:'
--		when 'P' then 'Total Planning Material:'
--		when 'K' then 'Total Kit Material:'
--		when 'C' then 'Total Co-Product Material:'
--		else '' end), 
--		(case when PartCategory is null or PartCategory = 'S' then 'B'
--		else PartCategory end),
--		WipJobAllMat.OperationOffset,
--		WipMaster.JobTenderDate, 
--		WipMaster.Job,
--		WipJobAllMat.StockCode,
--		WipJobAllMat.StockDescription,
--		[QtyOnHand],
--		[QtyIssued],
--		cast(UnitQtyReqd * QtyToMake as decimal(18, 2)),
--		(CASE WHEN (CAST(ROUND(([UnitQtyReqd]), 0) AS int)) - CAST(ROUND(([QtyIssued]), 0) AS int) <= 0 THEN 'Y' else 'N' END),
--		WipJobAllMat.[Warehouse]
--		--,[WorkCentre]
--		--,[IMachine]
--) AS [SrcA]
--LEFT OUTER JOIN (
--	SELECT * FROM (
--	SELECT
--		ROW_NUMBER() OVER (
--			PARTITION BY
--				[WipJobAllMat].[StockCode],
--				[WipJobAllMat].[StockDescription]
--			ORDER BY
--				[WipMaster].[JobStartDate]
--		) AS [BRow#],
--			1 AS [Bph],
--			[WipMaster].[Job] AS [BJob],
--			'M' AS [BPart Category],
--			[Operation] AS [BOperation],
--			MIN([WipMaster].[JobStartDate]) AS [BWipMaster.JobStartDate],
--			MIN([WipMaster].[Job]) AS [BWipMaster.Job],
--			[WipJobAllMat].[StockCode] AS [BWipMaster.StockCode],
--			[WipJobAllMat].[StockDescription] AS [BWipMaster.StockDescription],
--			CAST(ROUND((QtyOnHand), 0) AS int) AS [BQtyOnHand],
--			CAST(ROUND([QtyIssued], 0) AS int) AS [BQtyIssued],
--			CAST(ROUND([UnitQtyReqd], 0) AS int) AS [BQtyRequired],
--			CAST(ROUND(SUM([RunTimeIssued]), 2) AS decimal(14, 2)) AS [BHrsIssued],
--			(CASE WHEN (CAST(ROUND([UnitQtyReqd], 0) AS int)) - CAST(ROUND([QtyIssued], 0) AS int) <= 0 THEN 'Y' else 'N' END) AS [BComplete],
--			[WipMaster].[Warehouse] AS [BWarehouse]
--			,[PurchaseOrder] AS [BPurchaseOrder]
--			--,[WipJobAllLab].[WorkCentre] AS [WorkCentre]
--			--,[WipJobAllLab].[IMachine] AS [IMachine]
--		FROM
--			[WipJobAllMat] WITH (NOLOCK)
--		LEFT OUTER JOIN
--			[WipMaster] WITH (NOLOCK)
--		ON
--			[WipJobAllMat].[StockCode] = [WipMaster].[StockCode] and [WipJobAllMat].[Warehouse] = [WipMaster].[Warehouse]
--		LEFT OUTER  JOIN
--			[WipJobAllLab]
--		ON
--			[WipJobAllLab].[Job] = [WipMaster].[Job]
--		LEFT OUTER  JOIN
--			[InvWarehouse]
--		ON
--			[InvWarehouse].[StockCode] = [WipMaster].[StockCode] and [InvWarehouse].[Warehouse] = [WipMaster].[Warehouse]
--		LEFT OUTER JOIN
--			[PorMasterDetail]
--		ON	
--			[WipMaster].[StockCode] = [PorMasterDetail].[MStockCode]
--		WHERE
--			[WipJobAllMat].[Job] IN (SELECT [Job] FROM @wos)
--			AND ([JobStartDate] > DATEADD(YEAR, -1, GETDATE()) OR [JobStartDate] IS NULL)
--		GROUP BY
--			[WipMaster].[Job],
--			[WipJobAllMat].[StockCode],
--			[WipJobAllMat].[StockDescription],
		
--			[WipMaster].[JobStartDate]
--			,[WipMaster].[Warehouse]
--			--,[WipJobAllLab].[WorkCentre]
--			--,[WipJobAllLab].[IMachine]
	
--			,[Operation]
--			,[UnitQtyReqd]
--			,[QtyIssued]
--			,[QtyOnHand]
--			,[PurchaseOrder]
--		--ORDER BY
--		--	[WipMaster.JobStartDate]
--	) AS [Src]
--	WHERE
--		[Src].[BRow#] = 1
--) AS [SrcB]
--ON
--	[SrcA].[AWipMasterStockCode] = [SrcB].[BWipMaster.StockCode]
--ORDER BY
--	[Complete]
--	,[JobStartDate]
--	,[WipMasterStockCode]


/*********************************************************************************************************************************************************/
/*********************************************************************************************************************************************************/
/*********************************************************************************************************************************************************/
/*********************************************************************************************************************************************************/
/*********************************************************************************************************************************************************/
/*********************************************************************************************************************************************************/
/*********************************************************************************************************************************************************/


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
		,[QtyOnHand] AS [AQtyOnHand]
		,[QtyIssued] AS [AQtyIssued]
		,cast(UnitQtyReqd * QtyToMake as decimal(18, 2)) AS AQtyRequired
		,SUM([RunTimeIssued]) AS [AHrsIssued]
		,(CASE WHEN (CAST(ROUND(([UnitQtyReqd]), 0) AS int)) - CAST(ROUND(([QtyIssued]), 0) AS int) <= 0 THEN 'Y' else 'N' END) AS [AComplete]
		,WipJobAllMat.[Warehouse] AS [AWarehouse]
		--,[WorkCentre]
		--,[IMachine]

	from WipMaster with (nolock)
	left outer join WipJobAllMat with (nolock) on WipMaster.Job = WipJobAllMat.Job
	left outer join v_JobWIPValue on WipMaster.Job = v_JobWIPValue.Job
	left outer join InvMaster with (nolock) on WipJobAllMat.StockCode = InvMaster.StockCode
	left outer join WipJobAllLab with (nolock) on WipMaster.Job = WipJobAllLab.Job
	left outer join InvWarehouse with (nolock) on WipMaster.StockCode = InvWarehouse.StockCode

	WHERE 
		[WipMaster].[Job] IN (SELECT [Job] FROM @wos)
		AND [PartCategory] IN (SELECT [splitted_data] FROM @split_pc)
		AND RIGHT('00' + [WipJobAllMat].[Warehouse], 2) IN (SELECT [splitted_data] FROM @split_wh)
		AND RIGHT('00' + CAST([OperationOffset] AS NVARCHAR(2)), 2) IN (SELECT [splitted_data] FROM @split_op)
		--AND [Operation] IN (SELECT [splitted_data] FROM @split_op) -- doesnt seem safe to use this one.
		--AND [Part Category] IN (SELECT [splitted_data] FROM @split_pc)
		--AND [WorkCentre] IN (SELECT [splitted_data] FROM @split_wc)
		--AND [IMachine] IN (SELECT [splitted_data] FROM @split_im)
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
		[QtyOnHand],
		[QtyIssued],
		cast(UnitQtyReqd * QtyToMake as decimal(18, 2)),
		(CASE WHEN (CAST(ROUND(([UnitQtyReqd]), 0) AS int)) - CAST(ROUND(([QtyIssued]), 0) AS int) <= 0 THEN 'Y' else 'N' END),
		WipJobAllMat.[Warehouse]
		--,[WorkCentre]
		--,[IMachine]
) AS [SrcA]
LEFT OUTER JOIN (
	SELECT * FROM (
	SELECT
		ROW_NUMBER() OVER (
			PARTITION BY
				[WipJobAllMat].[StockCode],
				[WipJobAllMat].[StockDescription]
			ORDER BY
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
			,[PurchaseOrder] AS [BPurchaseOrder]
			--,[WipJobAllLab].[WorkCentre] AS [WorkCentre]
			--,[WipJobAllLab].[IMachine] AS [IMachine]
		FROM
			[WipJobAllMat] WITH (NOLOCK)
		LEFT OUTER JOIN
			[WipMaster] WITH (NOLOCK)
		ON
			[WipJobAllMat].[StockCode] = [WipMaster].[StockCode] and [WipJobAllMat].[Warehouse] = [WipMaster].[Warehouse]
		LEFT OUTER  JOIN
			[WipJobAllLab]
		ON
			[WipJobAllLab].[Job] = [WipMaster].[Job]
		LEFT OUTER  JOIN
			[InvWarehouse]
		ON
			[InvWarehouse].[StockCode] = [WipMaster].[StockCode] and [InvWarehouse].[Warehouse] = [WipMaster].[Warehouse]
		LEFT OUTER JOIN
			[PorMasterDetail]
		ON	
			[WipMaster].[StockCode] = [PorMasterDetail].[MStockCode]
		WHERE
			[WipJobAllMat].[Job] IN (SELECT [Job] FROM @wos)
			AND ([JobStartDate] > DATEADD(YEAR, -1, GETDATE()) OR [JobStartDate] IS NULL)
		GROUP BY
			[WipMaster].[Job],
			[WipJobAllMat].[StockCode],
			[WipJobAllMat].[StockDescription],
		
			[WipMaster].[JobStartDate]
			,[WipMaster].[Warehouse]
			--,[WipJobAllLab].[WorkCentre]
			--,[WipJobAllLab].[IMachine]
	
			,[Operation]
			,[UnitQtyReqd]
			,[QtyIssued]
			,[QtyOnHand]
			,[PurchaseOrder]
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
	
	--,ISNULL([BQtyOnHand], 0) AS [QtyOnHand]
	--,[AQtyIssued] AS [QtyIssued]
	--,[AQtyRequired] AS [QtyRequired]
	--,[AHrsIssued] AS [HrsIssued]
ORDER BY
	[Complete]
	,[JobStartDate]
	,[WipMasterStockCode]



END