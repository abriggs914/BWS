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
--SET @PARTCATEGORY='M';
--SET @OPERATION='03;04;05';
--SET @WAREHOUSE='01';
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

/*************************************************************************************************************************************************************************************************************************************************************************************/
/*************************************************************************************************************************************************************************************************************************************************************************************/
/*************************************************************************************************************************************************************************************************************************************************************************************/
/*************************************************************************************************************************************************************************************************************************************************************************************/
/*************************************************************************************************************************************************************************************************************************************************************************************/
/*************************************************************************************************************************************************************************************************************************************************************************************/
/*************************************************************************************************************************************************************************************************************************************************************************************/
/*************************************************************************************************************************************************************************************************************************************************************************************/


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
			) AS [Src]
			WHERE
				[Src].[BRow#] = 1