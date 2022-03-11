USE SysproCompanyA
GO


DECLARE
	@WO VARCHAR(MAX),
	@INCOMPLETEONLY BIT,
	@PARTCATEGORY NVARCHAR(MAX)=NULL,
	@OPERATION NVARCHAR(MAX)=NULL,
	@WAREHOUSE NVARCHAR(MAX)=NULL,
	@MACHINE NVARCHAR(MAX)=NULL,
	@WORKCENTRE NVARCHAR(MAX)=NULL

SET @WO='10015454';
SET @INCOMPLETEONLY=1;
SET @PARTCATEGORY='M;B;S';
SET @OPERATION='03;04;05'
SET @WAREHOUSE='01;04;06';
SET @WORKCENTRE=NULL
SET @MACHINE=NULL;

DECLARE @wos AS TABLE([Job#] INT, [Job] NVARCHAR(MAX));
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



DECLARE @T TABLE (
	[ph] INT,
	[WO] NVARCHAR(MAX),
	[Part Category] CHAR(1),
	[Operation] NVARCHAR(2),
	[WipMaster.JobStartDate] DATETIME,
	[WipMaster.Job] NVARCHAR(100),
	[WipMaster.StockCode] NVARCHAR(MAX),
	[WipMaster.StockDescription] NVARCHAR(MAX),
	[QtyOnHand] INT,
	[QtyIssued] INT,
	[QtyRequired] INT,
	[HrsIssued] FLOAT,
	[Complete] VARCHAR(1),
	[Warehouse] NVARCHAR(MAX)
	--,[WorkCentre] NVARCHAR(255)
	--,[IMachine] NVARCHAR(255)
)


DECLARE @results TABLE (
	[ph] INT,
	[Job] NVARCHAR(MAX),
	[Part Category] CHAR(1),
	[Operation] NVARCHAR(MAX),
	[WipMaster.JobStartDate] DATETIME,
	[WipMaster.Job] NVARCHAR(100),
	[WipMaster.StockCode] NVARCHAR(MAX),
	[WipMaster.StockDescription] NVARCHAR(MAX),
	[QtyOnHand] INT,
	[QtyIssued] INT,
	[QtyRequired] INT,
	[HrsIssued] FLOAT,
	[Complete] VARCHAR(1),
	[Warehouse] NVARCHAR(2)
	--,[WorkCentre] NVARCHAR(MAX)
	--,[IMachine] NVARCHAR(255)
)


INSERT INTO @T
SELECT
	0 AS [ph]
	,[WipMaster].[Job] AS [WO#]
	,'M' AS [Part Category]
	,RIGHT('00' + [WipJobAllLab].[Operation], 2) AS [Operation]
	,[JobStartDate]
	,MIN([WipMaster].[Job])
	,[WipJobAllMat].[StockCode]
	,[WipJobAllMat].[StockDescription]
	,[QtyOnHand]
	,[QtyIssued]
	,[UnitQtyReqd] AS [QtyRequired]
	,[RunTimeIssued] AS [HrsIssued]
	,(CASE WHEN (CAST(ROUND(([UnitQtyReqd]), 0) AS int)) - CAST(ROUND(([QtyIssued]), 0) AS int) <= 0 THEN 'Y' else 'N' END) AS [Complete]
	,[WipJobAllMat].[Warehouse]
FROM 
	[WipMaster] WITH (NOLOCK)
INNER JOIN
	[WipJobAllMat] WITH (NOLOCK)
ON
	[WipMaster].[StockCode] = [WipJobAllMat].[StockCode]
INNER JOIN
	[WipJobAllLab] WITH (NOLOCK)
ON
	[WipMaster].[Job] = [WipJobAllLab].[Job]
LEFT JOIN
	[InvWarehouse] WITH (NOLOCK)
ON
	[WipMaster].[StockCode] = [InvWarehouse].[StockCode]
WHERE
	[WipJobAllMat].[Job] IN (SELECT [Job] FROM @wos)
GROUP BY
	[WipMaster].[Job]
	,[JobStartDate]
	,[Operation]
	,[WipJobAllMat].[StockCode]
	,[WipJobAllMat].[StockDescription]
	,[UnitQtyReqd]
	,[QtyIssued]
	,[QtyOnHand]
	,[RunTimeIssued]
	,[WipJobAllMat].[Warehouse]


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







INSERT INTO @results
SELECT * FROM @T





















SELECT (CASE WHEN '01' IN (SELECT [Splitted_data] FROM @split_wh) THEN 'Y' ELSE 'N' END) AS [ANS]

SELECT 'A' AS [@T], * FROM @T
SELECT 'B' AS [@results], * FROM @results
SELECT 'C' AS [@split_pc], * FROM @split_pc
SELECT 'D' AS [@split_op], * FROM @split_op
SELECT 'E' AS [@split_wh], * FROM @split_wh
SELECT 'F' AS [@split_im], * FROM @split_im
SELECT 'G' AS [@split_wc], * FROM @split_wc
--SELECT 'H' AS [@resultsH], * FROM @results WHERE 
--	[Warehouse] IN (SELECT [Splitted_data] FROM @split_wh)
--	--AND
--	--RIGHT('00' + [Operation], 2) IN (SELECT [Splitted_data] FROM @split_op)
--	--AND [Operation] IN (SELECT [Splitted_data] FROM @split_op) -- doesnt seem safe to use this one.
--	--AND [Part Category] IN (SELECT [Splitted_data] FROM @split_pc)
--	--AND [WorkCentre] IN (SELECT [Splitted_data] FROM @split_wc)
--	--AND [IMachine] IN (SELECT [Splitted_data] FROM @split_im)


SELECT
	[ph],
	MIN([Job]) AS [MasterJob],
	[Part Category],
	MAX([Operation]) AS [Operation],
	MIN([WipMaster.JobStartDate]) AS [JobStartDate],
	MIN([WipMaster.Job]) AS [WipMasterJob],
	[WipMaster.StockCode] AS [WipMasterStockCode],
	[WipMaster.StockDescription] AS [WipMasterStockDescription],
	MAX([QtyOnHand]) AS [QtyOnHand],
	SUM([QtyIssued]) AS [QtyIssued],
	SUM([QtyRequired]) AS [QtyRequired],
	SUM([HrsIssued]) AS [HrsIssued],
	[Complete],
	[Warehouse]
	--,[WorkCentre]
	--,[IMachine]
FROM
	@results
WHERE 
	RIGHT('00' + [Warehouse], 2) IN (SELECT [splitted_data] FROM @split_wh)
	AND RIGHT('00' + [Operation], 2) IN (SELECT [splitted_data] FROM @split_op)
	--AND [Operation] IN (SELECT [splitted_data] FROM @split_op) -- doesnt seem safe to use this one.
	--AND [Part Category] IN (SELECT [splitted_data] FROM @split_pc)
	--AND [WorkCentre] IN (SELECT [splitted_data] FROM @split_wc)
	--AND [IMachine] IN (SELECT [splitted_data] FROM @split_im)
	AND ((@INCOMPLETEONLY = 1 AND [Complete] = 'N') OR @INCOMPLETEONLY = 0)
GROUP BY
	[ph]
	--,[Job]
	,[Part Category]
	--,[WipMaster.JobStartDate]
	--,[WipMaster.Job]
	,[WipMaster.StockCode],
	[WipMaster.StockDescription],
	[Complete],
	[Warehouse]
	--,[WorkCentre]
	--,[IMachine]
ORDER BY
	[WipMaster.StockCode]

--END


--SELECT
--	[Warehouse] AS [WH A]
--	,'<' + [Warehouse] + '>' AS [WH B]
--	,'<' + [splitted_data] + '>' AS [WH C]
--	, (CASE WHEN [Warehouse] IN (SELECT [splitted_data] FROM @split_wh) THEN 'Y' ELSE 'N' END) AS [ANS 1]
--	, (CASE WHEN [Warehouse] = [splitted_data] THEN 'Y' ELSE 'N' END) AS [ANS 2]
--FROM
--	@results
--CROSS JOIN
--	@split_wh