
-- 2025-10-14
-- Added Alt Path columns to check against the listed stockcode and DrawOfficeNum

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
	[DrawOfficeNum],

	(CASE 
		WHEN LTRIM(RTRIM(ISNULL([IM].[DrawOfficeNum], ''))) <> ''
		THEN @PDF_FileRootBWS + [IM].[DrawOfficeNum] + '.pdf'
		ELSE @PDF_FileRootBWS + [IM].[StockCode] + '.pdf' 
	END) AS [PDF_BWSPath],

	(CASE 
		WHEN LTRIM(RTRIM(ISNULL([IM].[StockCode], ''))) <> ''
		THEN @PDF_FileRootBWS + [IM].[StockCode] + '.pdf'
		ELSE NULL
	END) AS [ALT_PDF_BWSPath],

	(CASE 
		WHEN LTRIM(RTRIM(ISNULL([IM].[DrawOfficeNum], ''))) <> ''
		THEN @DWG_FileRootBWS + [IM].[DrawOfficeNum] + '.dwg'
		ELSE @DWG_FileRootBWS + [IM].[StockCode] + '.dwg' 
	END) AS [DWG_BWSPath],

	(CASE 
		WHEN LTRIM(RTRIM(ISNULL([IM].[StockCode], ''))) <> ''
		THEN @DWG_FileRootBWS + [IM].[StockCode] + '.dwg'
		ELSE NULL
	END) AS [ALT_DWG_BWSPath],

	(CASE 
		WHEN LTRIM(RTRIM(ISNULL([IM].[DrawOfficeNum], ''))) <> ''
		THEN @DXF_FileRootBWS + [IM].[DrawOfficeNum] + '.dxf'
		ELSE @DXF_FileRootBWS + [IM].[StockCode] + '.dxf' 
	END) AS [DXF_BWSPath],

	(CASE 
		WHEN LTRIM(RTRIM(ISNULL([IM].[StockCode], ''))) <> ''
		THEN @DXF_FileRootBWS + [IM].[StockCode] + '.dxf'
		ELSE NULL
	END) AS [ALT_DXF_BWSPath],

	(CASE 
		WHEN LTRIM(RTRIM(ISNULL([IM].[DrawOfficeNum], ''))) <> ''
		THEN @STP_FileRootBWS + [IM].[DrawOfficeNum] + '.stp'
		ELSE @STP_FileRootBWS + [IM].[StockCode] + '.stp' 
	END) AS [STP_BWSPath],

	(CASE 
		WHEN LTRIM(RTRIM(ISNULL([IM].[StockCode], ''))) <> ''
		THEN @STP_FileRootBWS + [IM].[StockCode] + '.stp'
		ELSE NULL
	END) AS [STP_BWSPath],

	(CASE 
		WHEN LTRIM(RTRIM(ISNULL([IM].[DrawOfficeNum], ''))) <> ''
		THEN @STEP_FileRootBWS + [IM].[DrawOfficeNum] + '.step'
		ELSE @STEP_FileRootBWS + [IM].[StockCode] + '.step' 
	END) AS [STEP_BWSPath],

	(CASE 
		WHEN LTRIM(RTRIM(ISNULL([IM].[StockCode], ''))) <> ''
		THEN @STEP_FileRootBWS + [IM].[StockCode] + '.step'
		ELSE NULL
	END) AS [ALT_STEP_BWSPath],

	(CASE 
		WHEN LTRIM(RTRIM(ISNULL([IM].[DrawOfficeNum], ''))) <> ''
		THEN @STP_FileRootSTG + [IM].[DrawOfficeNum] + '.stp'
		ELSE @STP_FileRootSTG + [IM].[StockCode] + '.stp' 
	END) AS [STP_STGPath],

	(CASE 
		WHEN LTRIM(RTRIM(ISNULL([IM].[StockCode], ''))) <> ''
		THEN @STP_FileRootSTG + [IM].[StockCode] + '.stp' 
		ELSE NULL
	END) AS [ALT_STP_STGPath],

	(CASE 
		WHEN LTRIM(RTRIM(ISNULL([IM].[DrawOfficeNum], ''))) <> ''
		THEN @STEP_FileRootSTG + [IM].[DrawOfficeNum] + '.step'
		ELSE @STEP_FileRootSTG + [IM].[StockCode] + '.step' 
	END) AS [STEP_STGPath],

	(CASE 
		WHEN LTRIM(RTRIM(ISNULL([IM].[StockCode], ''))) <> ''
		THEN @STEP_FileRootSTG + [IM].[StockCode] + '.step'
		ELSE NULL
	END) AS [ALT_STEP_STGPath]
FROM
	[SysproCompanyA].[dbo].[PorMasterDetail] [PMD]
INNER JOIN
	[SysproCompanyA].[dbo].[InvMaster] [IM]
ON
	([PMD].[MStockCode] = [IM].[StockCode])
	AND ([PMD].[MWarehouse] = [IM].[WarehouseToUse])
WHERE
	([PMD].[MLatestDueDate] >= DATEADD(DAY, -400, GETDATE()))
	AND ([PurchaseOrder] = '000000000150099')
	AND ([StockCode] = 'TR-UC-P002L')
;



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
	[DrawOfficeNum],

	(CASE 
		WHEN LTRIM(RTRIM(ISNULL([IM].[DrawOfficeNum], ''))) <> ''
		THEN @PDF_FileRootBWS + [IM].[DrawOfficeNum] + '.pdf'
		ELSE @PDF_FileRootBWS + [IM].[StockCode] + '.pdf' 
	END) AS [PDF_BWSPath],

	(CASE 
		WHEN LTRIM(RTRIM(ISNULL([IM].[StockCode], ''))) <> ''
		THEN @PDF_FileRootBWS + [IM].[StockCode] + '.pdf'
		ELSE NULL
	END) AS [ALT_PDF_BWSPath],

	(CASE 
		WHEN LTRIM(RTRIM(ISNULL([IM].[DrawOfficeNum], ''))) <> ''
		THEN @DWG_FileRootBWS + [IM].[DrawOfficeNum] + '.dwg'
		ELSE @DWG_FileRootBWS + [IM].[StockCode] + '.dwg' 
	END) AS [DWG_BWSPath],

	(CASE 
		WHEN LTRIM(RTRIM(ISNULL([IM].[StockCode], ''))) <> ''
		THEN @DWG_FileRootBWS + [IM].[StockCode] + '.dwg'
		ELSE NULL
	END) AS [ALT_DWG_BWSPath],

	(CASE 
		WHEN LTRIM(RTRIM(ISNULL([IM].[DrawOfficeNum], ''))) <> ''
		THEN @DXF_FileRootBWS + [IM].[DrawOfficeNum] + '.dxf'
		ELSE @DXF_FileRootBWS + [IM].[StockCode] + '.dxf' 
	END) AS [DXF_BWSPath],

	(CASE 
		WHEN LTRIM(RTRIM(ISNULL([IM].[StockCode], ''))) <> ''
		THEN @DXF_FileRootBWS + [IM].[StockCode] + '.dxf'
		ELSE NULL
	END) AS [ALT_DXF_BWSPath],

	(CASE 
		WHEN LTRIM(RTRIM(ISNULL([IM].[DrawOfficeNum], ''))) <> ''
		THEN @STP_FileRootBWS + [IM].[DrawOfficeNum] + '.stp'
		ELSE @STP_FileRootBWS + [IM].[StockCode] + '.stp' 
	END) AS [STP_BWSPath],

	(CASE 
		WHEN LTRIM(RTRIM(ISNULL([IM].[StockCode], ''))) <> ''
		THEN @STP_FileRootBWS + [IM].[StockCode] + '.stp'
		ELSE NULL
	END) AS [ALT_STP_BWSPath],

	(CASE 
		WHEN LTRIM(RTRIM(ISNULL([IM].[DrawOfficeNum], ''))) <> ''
		THEN @STEP_FileRootBWS + [IM].[DrawOfficeNum] + '.step'
		ELSE @STEP_FileRootBWS + [IM].[StockCode] + '.step' 
	END) AS [STEP_BWSPath],

	(CASE 
		WHEN LTRIM(RTRIM(ISNULL([IM].[StockCode], ''))) <> ''
		THEN @STEP_FileRootBWS + [IM].[StockCode] + '.step'
		ELSE NULL
	END) AS [ALT_STEP_BWSPath],

	(CASE 
		WHEN LTRIM(RTRIM(ISNULL([IM].[DrawOfficeNum], ''))) <> ''
		THEN @STP_FileRootSTG + [IM].[DrawOfficeNum] + '.stp'
		ELSE @STP_FileRootSTG + [IM].[StockCode] + '.stp' 
	END) AS [STP_STGPath],

	(CASE 
		WHEN LTRIM(RTRIM(ISNULL([IM].[StockCode], ''))) <> ''
		THEN @STP_FileRootSTG + [IM].[StockCode] + '.stp' 
		ELSE NULL
	END) AS [ALT_STP_STGPath],

	(CASE 
		WHEN LTRIM(RTRIM(ISNULL([IM].[DrawOfficeNum], ''))) <> ''
		THEN @STEP_FileRootSTG + [IM].[DrawOfficeNum] + '.step'
		ELSE @STEP_FileRootSTG + [IM].[StockCode] + '.step' 
	END) AS [STEP_STGPath],

	(CASE 
		WHEN LTRIM(RTRIM(ISNULL([IM].[StockCode], ''))) <> ''
		THEN @STEP_FileRootSTG + [IM].[StockCode] + '.step'
		ELSE NULL
	END) AS [ALT_STEP_STGPath]
FROM
	[SysproCompanyA].[dbo].[PorMasterDetail] [PMD]
INNER JOIN
	[SysproCompanyA].[dbo].[InvMaster] [IM]
ON
	([PMD].[MStockCode] = [IM].[StockCode])
	AND ([PMD].[MWarehouse] = [IM].[WarehouseToUse])
WHERE
	([PMD].[MLatestDueDate] >= DATEADD(DAY, -400, GETDATE()))
;