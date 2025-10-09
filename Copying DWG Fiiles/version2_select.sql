SELECT
	*
FROM
	[BWSdb].[dbo].[v_REC-MACHParts]
;

SELECT
	[PMD].[PurchaseOrder]
FROM
	[SysproCompanyA].[dbo].[PorMasterDetail] [PMD]
WHERE
	([PMD].[MLatestDueDate] >= DATEADD(DAY, -400, GETDATE()))
	AND (LTRIM(RTRIM(ISNULL([PMD].[PurchaseOrder], ''))) <> '')
GROUP BY
	[PMD].[PurchaseOrder]
;
	
DECLARE @po NVARCHAR(MAX) = RIGHT('000000000000000' + '149721', 15)
DECLARE @PDF_FileRootBWS NVARCHAR(MAX) = '\\server4.bwsdomain.local\Design\VaultWorkspace_BWS\PDFS\'
DECLARE @dwg_FileRootBWS NVARCHAR(MAX) = '\\server4.bwsdomain.local\Design\DRAWINGS\STANDARDS\'
DECLARE @dxf_FileRootBWS NVARCHAR(MAX) = '\\server4.bwsdomain.local\Design\DRAWINGS\STANDARDS\'
DECLARE @stp_FileRootBWS NVARCHAR(MAX) = '\\server4.bwsdomain.local\Design\SheetMetal_Step_Files_\'
DECLARE @step_FileRootBWS NVARCHAR(MAX) = '\\server4.bwsdomain.local\Design\SheetMetal_Step_Files_\'
DECLARE @stp_FileRootSTG NVARCHAR(MAX) = '\\server4.bwsdomain.local\Design\SheetMetal_Step_Files_\STARGATE STEP FILES\'
DECLARE @step_FileRootSTG NVARCHAR(MAX) = '\\server4.bwsdomain.local\Design\SheetMetal_Step_Files_\STARGATE STEP FILES\'

SELECT
	[PMD].[PurchaseOrder],
	[PMD].[Line],
	[PMD].[MStockCode],
	[PMD].[MWarehouse],
	[PMD].[MOrderQty],
	[PMD].[MReceivedQty],
	[PMD].[MPrice],
	[PMD].[MLatestDueDate],
	[PMD].[MJob],

	(CASE 
		WHEN LTRIM(RTRIM(ISNULL([IM].[DrawOfficeNum], ''))) <> ''
		THEN @PDF_FileRootBWS + [IM].[DrawOfficeNum] + '.pdf'
		ELSE @PDF_FileRootBWS + [IM].[StockCode] + '.pdf' 
	END) AS [PDF_BWSPath],

	(CASE 
		WHEN LTRIM(RTRIM(ISNULL([IM].[DrawOfficeNum], ''))) <> ''
		THEN @DWG_FileRootBWS + [IM].[DrawOfficeNum] + '.dwg'
		ELSE @DWG_FileRootBWS + [IM].[StockCode] + '.dwg' 
	END) AS [DWG_BWSPath],

	(CASE 
		WHEN LTRIM(RTRIM(ISNULL([IM].[DrawOfficeNum], ''))) <> ''
		THEN @DXF_FileRootBWS + [IM].[DrawOfficeNum] + '.dxf'
		ELSE @DXF_FileRootBWS + [IM].[StockCode] + '.dxf' 
	END) AS [DXF_BWSPath],

	(CASE 
		WHEN LTRIM(RTRIM(ISNULL([IM].[DrawOfficeNum], ''))) <> ''
		THEN @STP_FileRootBWS + [IM].[DrawOfficeNum] + '.stp'
		ELSE @STP_FileRootBWS + [IM].[StockCode] + '.stp' 
	END) AS [STP_BWSPath],

	(CASE 
		WHEN LTRIM(RTRIM(ISNULL([IM].[DrawOfficeNum], ''))) <> ''
		THEN @STEP_FileRootBWS + [IM].[DrawOfficeNum] + '.step'
		ELSE @STEP_FileRootBWS + [IM].[StockCode] + '.step' 
	END) AS [STEP_BWSPath],

	(CASE 
		WHEN LTRIM(RTRIM(ISNULL([IM].[DrawOfficeNum], ''))) <> ''
		THEN @STP_FileRootSTG + [IM].[DrawOfficeNum] + '.stp'
		ELSE @STP_FileRootSTG + [IM].[StockCode] + '.stp' 
	END) AS [STP_STGPath],

	(CASE 
		WHEN LTRIM(RTRIM(ISNULL([IM].[DrawOfficeNum], ''))) <> ''
		THEN @STEP_FileRootSTG + [IM].[DrawOfficeNum] + '.step'
		ELSE @STEP_FileRootSTG + [IM].[StockCode] + '.step' 
	END) AS [STEP_STGPath]
FROM
	[SysproCompanyA].[dbo].[PorMasterDetail] [PMD]
INNER JOIN
	[SysproCompanyA].[dbo].[InvMaster] [IM]
ON
	([PMD].[MStockCode] = [IM].[StockCode])
	AND ([PMD].[MWarehouse] = [IM].[WarehouseToUse])
WHERE
	([PMD].[MLatestDueDate] >= DATEADD(DAY, -400, GETDATE()))
	--AND (LTRIM(RTRIM(ISNULL([PMD].[PurchaseOrder], ''))) <> '')
/*WHERE
	[PMD].[PurchaseOrder] = @po*/
	