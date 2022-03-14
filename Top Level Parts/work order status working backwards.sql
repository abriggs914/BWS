

DECLARE
	@WO VARCHAR(MAX),
	@INCOMPLETEONLY BIT,
	@PARTCATEGORY NVARCHAR(MAX)=NULL,
	@OPERATION NVARCHAR(MAX)=NULL,
	@WAREHOUSE NVARCHAR(MAX)=NULL,
	@MACHINE NVARCHAR(MAX)=NULL,
	@WORKCENTRE NVARCHAR(MAX)=NULL

SET @WO='10015454';
SET @INCOMPLETEONLY=0;
SET @PARTCATEGORY='M;B;S';
SET @OPERATION='03;04;05'
SET @WAREHOUSE='01;04;06';
SET @WORKCENTRE=NULL
SET @MACHINE=NULL;

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

SELECT 'C' AS [@split_pc], * FROM @split_pc
SELECT 'D' AS [@split_op], * FROM @split_op
SELECT 'E' AS [@split_wh], * FROM @split_wh
SELECT 'F' AS [@split_im], * FROM @split_im
SELECT 'G' AS [@split_wc], * FROM @split_wc


select
	WipMaster.Job,
	WipMaster.JobDescription,
	WipMaster.StockCode AS ParentPart,
	WipMaster.StockDescription as ParentDescription,
	WipMaster.JobTenderDate, 
	WipMaster.ActCompleteDate, WipMaster.QtyToMake, 
	case PartCategory when 'B' then 'Total Bought Out Material:'
	when 'M' then 'Total Made In Material:'
	when 'G' then 'Total Phantom Material:'
	when 'S' then 'Total Subcontracted Material:'
	when 'P' then 'Total Planning Material:'
	when 'K' then 'Total Kit Material:'
	when 'C' then 'Total Co-Product Material:'
	else '' end as MaterialGrouping, 
	case when PartCategory is null or PartCategory = 'S' then 'B'
	else PartCategory end as PartCategory,
	WipJobAllMat.StockCode, 
	WipJobAllMat.StockDescription,
	WipJobAllMat.SequenceNum,
	WipJobAllMat.OperationOffset,
	WipJobAllMat.Uom,
	UnitCost,
	WipJobAllMat.Warehouse as WarehouseToUse /*InvMaster.WarehouseToUse*/, 
	cast(UnitQtyReqd * QtyToMake as decimal(18, 2)) AS QtyRequired, 
	WipJobAllMat.QtyIssuedEnt as QtyIssued, 
	WipJobAllMat.ValueIssued, 
	v_JobWIPValue.Total
	,(CASE WHEN (CAST(ROUND(([UnitQtyReqd]), 0) AS int)) - CAST(ROUND(([QtyIssued]), 0) AS int) <= 0 THEN 'Y' else 'N' END) AS [Complete]

from WipMaster with (nolock)
left outer join WipJobAllMat with (nolock) on WipMaster.Job = WipJobAllMat.Job
left outer join v_JobWIPValue on WipMaster.Job = v_JobWIPValue.Job
left outer join InvMaster with (nolock) on WipJobAllMat.StockCode = InvMaster.StockCode
--left outer join WipJobAllLab with (nolock) on WipMaster.Job = WipJobAllLab.Job

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


