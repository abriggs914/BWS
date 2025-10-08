USE [BWSdb]
GO


/****** Object:  View [dbo].[v_PROD_YellowTags]    Script Date: 2025-10-06 2:08:08 PM ******/

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



-- 2025-09-18 15:27 - Avery Briggs - View to speed up processing on the Access Yellow Tags form.
-- 2025-09-22 12:54 - Avery Briggs - New joins to improve processing.
-- 2025-09-23 14:50 - Avery Briggs - Add Expected Due Date
-- 2025-09-30 12:46 - Avery Briggs - Add [DefaultBin], [POReceivedQty], and [DrawingPath]
-- 2025-10-06 15:50 - Avery Briggs - Convert view to pull more up-to-date Syspro values ([PO] specific)


ALTER VIEW [dbo].[v_PROD_YellowTags]

AS

	SELECT
		  [YT].[ID]
		, [YT].[DateCreated]
		, [YT].[LastModified]
		, [YT].[Active]
		, [YT].[DateActive]
		, [YT].[DateInActive]
		, [Src].[PurchaseOrder] AS [PO]
		, [YT].[WO]
		, UPPER([IM].[StockCode]) AS [StockCode]
		--, [YT].[StockCode]
		, [YT].[Description] AS [YTDescription]
		, [YT].[QtyMissing]
		, [YT].[Notes]
		, [IW].[QtyOnHand]
		, [IM].[Description]
		, [IM].[LongDesc]
		, [ASup].[SupShortName] AS [Supplier]
		, [IW].[Warehouse]
		, [ASup].[LastPurchDate]
		, [Src].[OrigDueDate] AS [POOrigDueDate]
		, [Src].[LatestDueDate] AS [POLatestDueDate]
		, [IW].[DefaultBin] AS [Bin]
		, [Src].[MReceivedQty] AS [POReceivedQty]
		, (CASE WHEN LTRIM(RTRIM(ISNULL([IM].[DrawOfficeNum], ''))) <> '' THEN '\\server4\Design\VaultWorkspace_BWS\PDFS\' + [IM].[DrawOfficeNum] + '.pdf' ELSE NULL END) AS [DrawingPath]
	FROM
		[BWSdb].[dbo].[PROD_YellowTags] AS [YT]
	INNER JOIN 
		[SysproCompanyA].[dbo].[InvMaster] AS [IM]
	ON
		[YT].[StockCode] COLLATE DATABASE_DEFAULT = [IM].[StockCode]
	INNER JOIN 
		[SysproCompanyA].[dbo].[InvWarehouse] AS [IW]
	ON 
		([IM].[StockCode] = [IW].[StockCode])
		AND ([IM].[WarehouseToUse] = [IW].[Warehouse])
	LEFT JOIN 
		[SysproCompanyA].[dbo].[ApSupplier] AS [ASup]
	ON
		[IM].[Supplier] = [ASup].[Supplier]
	LEFT JOIN (
		SELECT 
			[MD].[PurchaseOrder],
			[MD].[MStockCode],
			[MD].[MWarehouse],
			[MD].[MOrigDueDate] AS [OrigDueDate],
			[MD].[MLatestDueDate] AS [LatestDueDate],
			[MD].[MReceivedQty],
			ROW_NUMBER() OVER(
				PARTITION BY
					[MD].[MStockCode]
				ORDER BY
					[MD].[MOrigDueDate] DESC
			) AS [RN]
		FROM [SysproCompanyA].[dbo].[PorMasterDetail] [MD]
		INNER JOIN [BWSdb].[dbo].[PROD_YellowTags] [YT] ON [MD].[MStockCode] = [YT].[StockCode] COLLATE DATABASE_DEFAULT
		WHERE ([MD].[MLastReceiptDat] IS NULL)
	) AS [Src]
	ON
		([IM].[StockCode] = [Src].[MStockCode] COLLATE DATABASE_DEFAULT)
		AND ([IM].[WarehouseToUse] = [Src].[MWarehouse])
	WHERE
		[Active] = 1
;

-- Version 202510061552 - Avery Briggs
/*
SELECT
		  [YT].[ID]
		, [YT].[DateCreated]
		, [YT].[LastModified]
		, [YT].[Active]
		, [YT].[DateActive]
		, [YT].[DateInActive]
		, [YT].[PO]
		, [YT].[WO]
		, [YT].[StockCode]
		, [YT].[Description] AS [YTDescription]
		, [YT].[QtyMissing]
		, [YT].[Notes]
		, [IW].[QtyOnHand]
		, [IM].[Description]
		, [IM].[LongDesc]
		, [ASup].[SupShortName] AS [Supplier]
		, [IW].[Warehouse]
		, [ASup].[LastPurchDate]
		, [YT].[POOrigDueDate]
		, [YT].[POLatestDueDate]
		, [IW].[DefaultBin] AS [Bin]
		, [YT].[POReceivedQty]
		, (CASE WHEN LTRIM(RTRIM(ISNULL([IM].[DrawOfficeNum], ''))) <> '' THEN '\\server4\Design\VaultWorkspace_BWS\PDFS\' + [IM].[DrawOfficeNum] + '.pdf' ELSE NULL END) AS [DrawingPath]
	FROM
		[BWSdb].[dbo].[PROD_YellowTags] AS [YT]
	INNER JOIN 
		[SysproCompanyA].[dbo].[InvMaster] AS [IM]
	ON
		[YT].[StockCode] COLLATE DATABASE_DEFAULT = [IM].[StockCode]
	INNER JOIN 
		[SysproCompanyA].[dbo].[InvWarehouse] AS [IW]
	ON 
		([IM].[StockCode] = [IW].[StockCode])
		AND ([IM].[WarehouseToUse] = [IW].[Warehouse])
	LEFT JOIN 
		[SysproCompanyA].[dbo].[ApSupplier] AS [ASup]
	ON
		[IM].[Supplier] = [ASup].[Supplier]
	WHERE
		[Active] = 1
;
*/


-- Version 202509301304 - Avery Briggs
/*	SELECT
		  [YT].[ID]
		, [YT].[DateCreated]
		, [YT].[LastModified]
		, [YT].[Active]
		, [YT].[DateActive]
		, [YT].[DateInActive]
		, [YT].[PO]
		, [YT].[WO]
		, [YT].[StockCode]
		, [YT].[Description] AS [YTDescription]
		, [YT].[QtyMissing]
		, [YT].[Notes]
		, [IW].[QtyOnHand]
		, [IM].[Description]
		, [IM].[LongDesc]
		, [ASup].[SupShortName] AS [Supplier]
		, [IW].[Warehouse]
		, [ASup].[LastPurchDate]
		, [YT].[POOrigDueDate]
		, [YT].[POLatestDueDate]
	FROM
		[BWSdb].[dbo].[PROD_YellowTags] AS [YT]
	INNER JOIN 
		[SysproCompanyA].[dbo].[InvMaster] AS [IM]
	ON
		[YT].[StockCode] COLLATE DATABASE_DEFAULT = [IM].[StockCode]
	INNER JOIN 
		[SysproCompanyA].[dbo].[InvWarehouse] AS [IW]
	ON 
		([IM].[StockCode] = [IW].[StockCode])
		AND ([IM].[WarehouseToUse] = [IW].[Warehouse])
	LEFT JOIN 
		[SysproCompanyA].[dbo].[ApSupplier] AS [ASup]
	ON
		[IM].[Supplier] = [ASup].[Supplier]
;*/

-- Version 202509221250 - Avery Briggs
/*
	SELECT
		[YT].[ID],
		[YT].[DateCreated],
		[YT].[LastModified],
		[YT].[Active],
		[YT].[DateActive],
		[YT].[DateInActive],
		[YT].[PO],
		[YT].[WO],
		[YT].[StockCode],
		[YT].[Description] AS [YTDescription],
		[YT].[QtyMissing],
		--[YT].[Supplier],
		[YT].[Notes],
		[IW].[QtyOnHand],
		[IM].[Description],
		[IM].[LongDesc],
		[AS].[SupShortName] AS [Supplier],
		[IW].[Warehouse]
	FROM 
		[BWSdb].[dbo].[PROD_YellowTags] [YT]
	LEFT JOIN
		[SysproCompanyA].[dbo].[InvMaster] [IM]
	ON
		[YT].[StockCode] = [IM].[StockCode] COLLATE DATABASE_DEFAULT
	LEFT JOIN
		[SysproCompanyA].[dbo].[InvWarehouse] [IW]
	ON
		([IM].[StockCode] = [IW].[StockCode])
		AND ([IM].[WarehouseToUse] = [IW].[Warehouse])
	LEFT JOIN
		[SysproCompanyA].[dbo].[ApSupplier] [AS]
	ON
		[IM].[Supplier] = [AS].[Supplier]
*/
;
GO


