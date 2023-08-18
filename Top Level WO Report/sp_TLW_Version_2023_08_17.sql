USE SysproCompanyA
GO


-- 2023-08-17 1411

ALTER PROCEDURE [sp_TLW_Version_2023_08_17]


--DECLARE
	@WO VARCHAR(MAX),
	@INCOMPLETEONLY BIT=NULL,
	@PARTCATEGORY NVARCHAR(MAX)=NULL,
	@OPERATION NVARCHAR(MAX)=NULL,
	@WAREHOUSE NVARCHAR(MAX)=NULL,
	@MACHINE NVARCHAR(MAX)=NULL,
	@WORKCENTRE NVARCHAR(MAX)=NULL

AS BEGIN
	
--	SET @WO= '10016583';
	--SET @INCOMPLETEONLY=0;
	--SET @PARTCATEGORY='M';
	--SET @OPERATION='03;04;05';
	--SET @WAREHOUSE='01;06';
--	SET @WORKCENTRE=NULL
	--SET @MACHINE=NULL  --'41';


	DECLARE @wos AS TABLE([idx] INT, [Job] NVARCHAR(MAX));
	INSERT INTO @wos SELECT * FROM [BWSdb].[dbo].[split_string_idx](@wo, ';');

	IF @INCOMPLETEONLY IS NULL BEGIN
		SELECT @INCOMPLETEONLY = 0;
	END

	DECLARE @split_wh AS TABLE ([idx] INT, [Warehouse] NVARCHAR(2))
	INSERT INTO @split_wh SELECT * FROM [BWSdb].[dbo].[split_string_idx](@WAREHOUSE, ';')
	IF (SELECT COUNT(*) FROM @split_wh) = 0 BEGIN
		-- If no warehouses are selected then return all warehouses
		--INSERT INTO @split_wh ([idx], [splitted_data]) SELECT ROW_NUMBER() OVER (ORDER BY [Warehouse]) AS [Row#], [Warehouse] FROM [SysproCompanyA].[dbo].[InvWhControl] GROUP BY [Warehouse]
		INSERT INTO @split_wh SELECT * FROM [SysproCompanyA].[dbo].[v_TLWRAllWarehouses]
	END

	DECLARE @split_op AS TABLE ([idx] INT, [Operation] NVARCHAR(MAX))
	INSERT INTO @split_op SELECT * FROM [BWSdb].[dbo].[split_string_idx](@OPERATION, ';')
	IF (SELECT COUNT(*) FROM @split_op) = 0 BEGIN
		-- If no operations are selected then return all operations
		--INSERT INTO @split_op ([idx], [splitted_data]) SELECT ROW_NUMBER() OVER (ORDER BY [Warehouse]) AS [Row#], [Warehouse] FROM [SysproCompanyA].[dbo].[InvWarehouse] GROUP BY [Warehouse]
		INSERT INTO @split_op SELECT * FROM [SysproCompanyA].[dbo].[v_TLWRAllOperations]
	END

	DECLARE @split_pc AS TABLE ([idx] INT, [PartCategory] NVARCHAR(MAX))
	INSERT INTO @split_pc SELECT * FROM [BWSdb].[dbo].[split_string_idx](@PARTCATEGORY, ';')
	IF (SELECT COUNT(*) FROM @split_pc) = 0 BEGIN
		-- If no part categories are selected then return all part categories
		--INSERT INTO @split_pc ([idx], [splitted_data]) SELECT ROW_NUMBER() OVER (ORDER BY [PartCategory]) AS [Row#], [PartCategory] FROM [SysproCompanyA].[dbo].[InvMaster] GROUP BY [PartCategory]
		INSERT INTO @split_pc SELECT * FROM [SysproCompanyA].[dbo].[v_TLWRAllPartCategories]
	END

	DECLARE @split_wc AS TABLE ([idx] INT, [WorkCentre] NVARCHAR(MAX))
	INSERT INTO @split_wc SELECT * FROM [BWSdb].[dbo].[split_string_idx](@WORKCENTRE, ';')
	IF (SELECT COUNT(*) FROM @split_wc) = 0 BEGIN
		-- If no workcentres are selected then return all work centres
		--INSERT INTO @split_wc ([idx], [splitted_data]) SELECT ROW_NUMBER() OVER (ORDER BY [WorkCentre]) AS [Row#], [WorkCentre] FROM [SysproCompanyA].[dbo].[WipJobAllLab] GROUP BY [WorkCentre]
		INSERT INTO @split_wc SELECT * FROM [SysproCompanyA].[dbo].[v_TLWRAllWorkCentres]
	END

	DECLARE @split_im AS TABLE ([idx] INT, [Machine] NVARCHAR(MAX))
	INSERT INTO @split_im SELECT * FROM [BWSdb].[dbo].[split_string_idx](@MACHINE, ';')
	IF (SELECT COUNT(*) FROM @split_im) = 0 BEGIN
		-- If no machines are selected then return all machines
		--INSERT INTO @split_im ([idx], [splitted_data]) SELECT ROW_NUMBER() OVER (ORDER BY [IMachine]) AS [Row#], [IMachine] FROM [SysproCompanyA].[dbo].[WipJobAllLab] GROUP BY [IMachine]
		INSERT INTO @split_im SELECT * FROM [SysproCompanyA].[dbo].[v_TLWRAllMachines]
	END

	--SELECT 'wos' AS [T], * FROM @wos
	--SELECT 'split_wh' AS [T], * FROM @split_wh
	--SELECT 'split_op' AS [T], * FROM @split_op
	--SELECT 'split_pc' AS [T], * FROM @split_pc
	--SELECT 'split_wc' AS [T], * FROM @split_wc
	--SELECT 'split_im' AS [T], * FROM @split_im

	DECLARE @StockCodes AS TABLE (
		[ID] INT IDENTITY(0, 1)
		, [StockCode] NVARCHAR(MAX)
		, [Operation] INT
		, [Warehouse] NVARCHAR(MAX)
		, [PartCategory] NVARCHAR(MAX)
		, [Machine] NVARCHAR(MAX)
		, [WorkCentre] NVARCHAR(MAX)
		, [TLJob] NVARCHAR(MAX)
		, [TLStartDate] DATETIME
	)

	DECLARE @UnitStartDate AS DATETIME;
	SELECT @UnitStartDate = [JobStartDate] FROM [WipMaster] WHERE [Job] = @WO

	INSERT INTO @StockCodes ([StockCode], [Operation], [Warehouse], [PartCategory], [Machine], [WorkCentre], [TLJob], [TLStartDate]) 
	SELECT
		[Mat].[StockCode]
		,[Mat].[OperationOffset]
		,[Mat].[Warehouse]
		,[Inv].[PartCategory]
		,[IMachine]
		,[Lab].[WorkCentre]
		,[SWO].[Job]
		,[Wip].[JobStartDate]
	FROM
		[WipJobAllMat] AS [Mat]
	LEFT JOIN
		[InvMaster] AS [Inv]
	ON
		[Mat].[StockCode] = [Inv].[StockCode]
	LEFT JOIN
		[WipJobAllLab] AS [Lab]
	ON
		[Mat].[Job] = [Lab].[Job]
		AND [Mat].[OperationOffset] = [Lab].[Operation]

	INNER JOIN
		@wos AS [SWO]
	ON
		[Mat].[Job] = [SWO].[Job]
	INNER JOIN
		@split_wh AS [SWH]
	ON
		[Mat].[Warehouse] = [SWH].[Warehouse]
	INNER JOIN
		@split_op AS [SOP]
	ON
		[Mat].[OperationOffset] = CAST([SOP].[Operation] AS INT)
	INNER JOIN
		@split_pc AS [SPC]
	ON
		[Inv].[PartCategory] = [SPC].[PartCategory]
	INNER JOIN
		@split_im AS [SIM]
	ON
		[Lab].[IMachine] = [SIM].[Machine]
	INNER JOIN
		@split_wc AS [SWC]
	ON
		[Lab].[WorkCentre] = [SWC].[WorkCentre]

	INNER JOIN
		[WipMaster] AS [Wip]
	ON
		[Mat].[Job] = [Wip].[Job]
	LEFT JOIN
		[InvWarehouse] AS [Whs]
	ON
		[Whs].[StockCode] = [Mat].[StockCode]
		AND [Mat].[Warehouse] = [Whs].[Warehouse]
	--WHERE
		--[Mat].[Job] = @WO
		--AND
		--[Mat].[Warehouse] = CAST(@WH AS INT)
		--AND ISNULL([Wip].[Complete], 'N') = 'N'
	GROUP BY
		[SWO].[Job]
		, [Lab].[IMachine]
		, [Lab].[WorkCentre]
		, [Wip].[JobStartDate]
		, [Mat].[OperationOffset]
		, [Inv].[PartCategory]
		, [Mat].[Warehouse]
		, [Mat].[StockCode]
		, [Mat].[StockDescription]
		, [Whs].[QtyOnHand]
		, [Whs].[QtyOnOrder]
		, [Whs].[QtyAllocated]
		, [Mat].[UnitQtyReqd]
		, [Mat].[QtyIssued]
	ORDER BY
		[OperationOffset]
		, [StockCode]
	;

	--SELECT * FROM @StockCodes

	SELECT
		CAST([Operation]AS int) AS [Operation]
		, [SrcB].[StockCode]
		, ISNULL([SrcB].[Description], [MStockDes]) AS [StockDescription]
		, [TLJob]

		--, ISNULL([SrcB].[Job], [PurchaseOrder]) AS [JobOrPO]

		, (CASE 
			WHEN [SrcB].[Description] IS NULL THEN [PurchaseOrder]
			WHEN [MStockDes] IS NULL THEN [SrcB].[Job]
			WHEN [SrcB].[JobStartDate] IS NULL THEN [PurchaseOrder]
			WHEN (ABS(DATEDIFF(SECOND, [SrcB].[JobStartDate], @UnitStartDate)) <= ABS(DATEDIFF(SECOND, [MLatestDueDate], @UnitStartDate))) THEN [SrcB].[Job]
			ELSE [PurchaseOrder]
			END) AS [JobOrPO]

		--, ISNULL([JobStartDate], [MLatestDueDate]) AS [StartOrDueDate]

		, (CASE 
			WHEN [SrcB].[Description] IS NULL THEN [MLatestDueDate]
			WHEN [MStockDes] IS NULL THEN [SrcB].[JobStartDate]
			WHEN [SrcB].[JobStartDate] IS NULL THEN [MLatestDueDate]
			WHEN (ABS(DATEDIFF(SECOND, [SrcB].[JobStartDate], @UnitStartDate)) <= ABS(DATEDIFF(SECOND, [MLatestDueDate], @UnitStartDate))) THEN [JobStartDate]
			ELSE [MLatestDueDate]
			END) AS [StartOrDueDate]
			
		--, [MLatestDueDate] AS [DEL_MLatestDueDate]
		--, [PurchaseOrder] AS [DEL_PurchaseOrder]
		--, [JobStartDate] AS [DEL_JobStartDate]
		--, [SrcB].[Job] AS [DEL_BJob]

		, [Mat].[UnitQtyReqd]
		, [QtyOnHand]
		, [QtyOnOrder]
		, [QtyAllocatedWip]
		, [QtyIssued]
		, [Inv].[Warehouse]
		, [PartCategory]
		, [Machine]
		, [WorkCentre]
		, [Complete]
	FROM (
		SELECT
			[SrcA].*
			,ROW_NUMBER() OVER(
					PARTITION BY
						[SrcA].[StockCode]
					ORDER BY
						ABS(DATEDIFF(SECOND, [SrcA].[TLStartDate], [Por].[MLatestDueDate]))
			) AS [RnPOs]
			, [Por].[PurchaseOrder]
			, [Por].[MLatestDueDate]
			, [Por].[MStockDes]
		FROM (
			SELECT
				[SC].[ID],
				[SC].[TLJob],
				[SC].[StockCode],
				[Inv].[Description],
				[SC].[Operation],
				[SC].[TLStartDate],
				[Wip].[JobStartDate],
				[Wip].[Job],
				[SC].[Warehouse],
				[SC].[PartCategory],
				[SC].[Machine],
				[SC].[WorkCentre],
				[Wip].[Complete],
				ABS(DATEDIFF(SECOND, [SC].[TLStartDate], [Wip].[JobStartDate])) AS [DiffSec],
				ROW_NUMBER() OVER(
					PARTITION BY
						[SC].[StockCode]
					ORDER BY
						ABS(DATEDIFF(SECOND, [SC].[TLStartDate], [Wip].[JobStartDate]))
				) AS [RnSubs]
			FROM
				@StockCodes AS [SC]
			LEFT JOIN
				[WipMaster] AS [Wip]
			ON
				[SC].[StockCode] = [Wip].[StockCode]
			LEFT JOIN
				[InvMaster] AS [Inv]
			ON
				[SC].[StockCode] = [Inv].[StockCode]
		) AS [SrcA]
		LEFT JOIN
			[PorMasterDetail] AS [Por]
		ON
			[SrcA].[StockCode] = [Por].[MStockCode]
			--AND [SrcA].[Job] IS NULL
		WHERE
			[RnSubs] = 1
	) AS [SrcB]
	LEFT JOIN
		[WipJobAllMat] AS [Mat]
	ON
		[SrcB].[StockCode] = [Mat].[StockCode]
		AND [SrcB].[Operation] = [Mat].[OperationOffset]
		AND [Mat].[Job] = [SrcB].[TLJob]
	LEFT JOIN
		[InvWarehouse] AS [Inv]
	ON
		[SrcB].[StockCode] = [Inv].[StockCode]
		AND [SrcB].[Warehouse] = [Inv].[Warehouse]
		--AND ISNULL([SrcB].[Warehouse], [Inv].[Warehouse]) = [Inv].[Warehouse]
	WHERE
		[RnPOs] = 1
		--AND [Inv].[Warehouse] = @WH
		AND (CASE WHEN @INCOMPLETEONLY = 0 THEN 1 ELSE
			(CASE WHEN [UnitQtyReqd] > [QtyIssued] THEN 1 ELSE 0 END )
		END) = 1
	ORDER BY
		[Operation]
		,[SrcB].[StockCode]
END