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
--SET @OPERATION='03;04;05;10;13';
SET @WAREHOUSE='01;06';
--SET @WORKCENTRE='S'
SET @MACHINE='37';

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


select
			0 AS [Aph]
			,WipMaster.Job AS [AMasterJob]
			,case when PartCategory is null or PartCategory = 'S' then 'B' else PartCategory end as [APart Category]
			,WipJobAllMat.OperationOffset AS [AOperation]


			,(SELECT TOP 1 OperationOffset FROM 
					WipMaster with (nolock)
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
					AND [RunTimeIssued] = 0
					--AND WipJobAllMat.OperationOffset <> (SELECT MIN([]))
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
					,[Operation]
					) as [ANextOperation]


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
			,[Operation]