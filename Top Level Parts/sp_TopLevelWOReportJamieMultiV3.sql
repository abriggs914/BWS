USE [SysproCompanyA]
GO
/****** Object:  StoredProcedure [dbo].[sp_TopLevelWOReportJamieMultiV2]    Script Date: 2022-04-06 10:21:49 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- New version to include WO / IO / OP / WH / PC / MC / WC

ALTER PROCEDURE [dbo].[sp_TopLevelWOReportJamieMultiV3]

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

--SET @WO= '10015400';
--SET @INCOMPLETEONLY=0;
----SET @PARTCATEGORY='M';
--SET @OPERATION='02;03';
----SET @WAREHOUSE='01';
----SET @WORKCENTRE=NULL
----SET @MACHINE=NULL;

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

/*************************************************************************************************************************************************************************************************************************************************************************************/
/*************************************************************************************************************************************************************************************************************************************************************************************/
/*************************************************************************************************************************************************************************************************************************************************************************************/
/*************************************************************************************************************************************************************************************************************************************************************************************/
/*************************************************************************************************************************************************************************************************************************************************************************************/
/*************************************************************************************************************************************************************************************************************************************************************************************/
/*************************************************************************************************************************************************************************************************************************************************************************************/
/*************************************************************************************************************************************************************************************************************************************************************************************/

SELECT
	[MasterJob]
	,[MasterJobDescription]
	,[MasterStockCode]
	,[MasterJobStartDate]
	,[MasterComplete]
	,[StockCode]
	,[StockCodeDescription]
	,[StockCodeQtyReqd]
	,[StockCodeQtyIssued]
	,[StockCodeOperationOffset (Mat)]
	--,[WipJobAllLab].[Operation] AS [StockCodeOperation (Lab)]
	--,[WipJobAllLab].[RunTimeIssued] AS [RunTimeIssued]
	--,[WipJobAllLab].[OperCompleted] AS [OperationComplete]
	,SUM([QtyOnHand]) AS [QtyOnHand]
	,'PO#' + RIGHT([PurchaseOrder], 10) AS [PurchaseOrder]
	,[PurchaseOrderDate]
	,[BWipMaster Job]
	,[BWipMaster JobStartDate]
	,(CASE WHEN (CAST(ROUND([StockCodeQtyReqd], 0) AS int)) - CAST(ROUND([StockCodeQtyIssued], 0) AS int) <= 0 THEN 'Y' else 'N' END) AS [CalcComplete]
FROM (
	SELECT
		[WipMaster].[Job] AS [MasterJob]
		,[WipMaster].[JobDescription] AS [MasterJobDescription]
		,[WipMaster].[StockCode] AS [MasterStockCode]
		,[WipMaster].[JobStartDate] AS [MasterJobStartDate]
		,[WipMaster].[Complete] AS [MasterComplete]
		,[WipJobAllMat].[StockCode] AS [StockCode]
		,[WipJobAllMat].[StockDescription] AS [StockCodeDescription]
		,[WipJobAllMat].[UnitQtyReqd] AS [StockCodeQtyReqd]
		,[WipJobAllMat].[QtyIssued] AS [StockCodeQtyIssued]
		,MIN([WipJobAllMat].[OperationOffset]) AS [StockCodeOperationOffset (Mat)]
		--,[WipJobAllLab].[Operation] AS [StockCodeOperation (Lab)]
		--,[WipJobAllLab].[RunTimeIssued] AS [RunTimeIssued]
		--,[WipJobAllLab].[OperCompleted] AS [OperationComplete]
		,[InvWarehouse].[QtyOnHand] AS [QtyOnHand]
		,MAX([PorMasterDetail].[PurchaseOrder]) AS [PurchaseOrder]
		,MAX([PorMasterDetail].[MLastReceiptDat]) AS [PurchaseOrderDate]
	FROM
		[WipMaster] WITH (NOLOCK)
	LEFT OUTER JOIN
		[WipJobAllMat] WITH (NOLOCK) 
	ON
		[WipMaster].[Job] = [WipJobAllMat].[Job]
		--AND [WipMaster].[StockCode] = [WipJobAllMat].[StockCode]
	LEFT OUTER JOIN
		[WipJobAllLab] WITH (NOLOCK)
	ON
		[WipMaster].[Job] = [WipJobAllLab].[Job]
		--AND [WipMaster].[StockCode] = [WipJobAllLab].[Stock]
	LEFT OUTER JOIN
		[v_JobWIPValue] WITH (NOLOCK)
	ON
		[WipMaster].[Job] = [v_JobWIPValue].[Job]
	LEFT OUTER JOIN
		[InvMaster] WITH (NOLOCK)
	ON
		[WipJobAllMat].[StockCode] = [InvMaster].[StockCode]
	LEFT OUTER JOIN
		[InvWarehouse] WITH (NOLOCK)
	ON
		[WipJobAllMat].[StockCode] = [InvWarehouse].[StockCode]
		--AND [WipJobAllMat].[Warehouse] = [InvWarehouse].Warehouse -- For sure not this
	LEFT OUTER JOIN
		[PorMasterDetail] WITH (NOLOCK)
	ON
		[WipJobAllMat].[StockCode] = [PorMasterDetail].[MStockCode]
	--	AND [WipJobAllMat].[Warehouse] = [PorMasterDetail].[MWarehouse]
	--	--AND [WipMaster].[StockCode] = [PorMasterDetail].[MWarehouse]

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
		AND ((@INCOMPLETEONLY = 1 AND (CASE WHEN (CAST(ROUND(([UnitQtyReqd]), 0) AS INT)) - CAST(ROUND(([QtyIssued]), 0) AS INT) <= 0 THEN 'Y' else 'N' END) = 'N') OR @INCOMPLETEONLY = 0)
	GROUP BY
		[WipMaster].[Job]
		,[WipMaster].[JobDescription]
		,[WipMaster].[StockCode]
		,[WipMaster].[JobStartDate]
		,[WipMaster].[Complete]
		,[WipJobAllMat].[StockCode]
		,[WipJobAllMat].[StockDescription]
		,[WipJobAllMat].[UnitQtyReqd]
		,[WipJobAllMat].[QtyIssued]
		--,[WipJobAllMat].[OperationOffset]
		--,[WipJobAllLab].[Operation]
		--,[WipJobAllLab].[RunTimeIssued]
		--,[WipJobAllLab].[OperCompleted]
		,[InvWarehouse].[QtyOnHand]
		--,[PorMasterDetail].[PurchaseOrder]
) AS [SrcB]

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
					MIN([WipMaster].[JobStartDate]) AS [BWipMaster JobStartDate],
					MIN([WipMaster].[Job]) AS [BWipMaster Job],
					[WipJobAllMat].[StockCode] AS [BWipMaster.StockCode],
					[WipJobAllMat].[StockDescription] AS [BWipMaster.StockDescription],
					CAST(ROUND((QtyOnHand), 0) AS int) AS [BQtyOnHand],
					CAST(ROUND([QtyIssued], 0) AS int) AS [BQtyIssued],
					CAST(ROUND([UnitQtyReqd], 0) AS int) AS [BQtyRequired],
					CAST(ROUND(SUM([RunTimeIssued]), 2) AS decimal(14, 2)) AS [BHrsIssued],
					(CASE WHEN (CAST(ROUND([UnitQtyReqd], 0) AS int)) - CAST(ROUND([QtyIssued], 0) AS int) <= 0 THEN 'Y' else 'N' END) AS [BComplete],
					[WipMaster].[Warehouse] AS [BWarehouse]
					,MAX([PurchaseOrder]) AS [BPurchaseOrder]
					--,[WipJobAllLab].[WorkCentre] AS [WorkCentre]
					--,[WipJobAllLab].[IMachine] AS [IMachine]
				FROM
					[WipJobAllMat] WITH (NOLOCK)
				LEFT OUTER JOIN
					[WipMaster] WITH (NOLOCK)
				ON
					[WipJobAllMat].[StockCode] = [WipMaster].[StockCode] and [WipJobAllMat].[Warehouse] = [WipMaster].[Warehouse]
				LEFT OUTER  JOIN
					[WipJobAllLab] WITH (NOLOCK)
				ON
					[WipJobAllLab].[Job] = [WipMaster].[Job]
				LEFT OUTER  JOIN
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
					--,[WipJobAllLab].[WorkCentre]
					--,[WipJobAllLab].[IMachine]
	
					,[Operation]
					,[UnitQtyReqd]
					,[QtyIssued]
					,[QtyOnHand]
					,[Complete]
					--,[PurchaseOrder]
				--ORDER BY
				--	[WipMaster.JobStartDate]
			) AS [SrcA]
			WHERE
				[SrcA].[BRow#] = 1
) AS [SrcC]
ON
	[SrcB].[StockCode] = [SrcC].[BWipMaster.StockCode]









GROUP BY
	[MasterJob]
	,[MasterJobDescription]
	,[MasterStockCode]
	,[MasterJobStartDate]
	,[MasterComplete]
	,[StockCode]
	,[StockCodeDescription]
	,[StockCodeQtyReqd]
	,[StockCodeQtyIssued]
	,[StockCodeOperationOffset (Mat)]
	,[PurchaseOrder]
	,[PurchaseOrderDate]
	,[BWipMaster Job]
	,[BWipMaster JobStartDate]
ORDER BY
	[StockCode]

END